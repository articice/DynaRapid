/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.parser;

import ch.agsl.dynarapid.modules.*;
import ch.agsl.dynarapid.strings.*;

import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.zip.CRC32;

/*
 * Reads the hw.mlir of a new Dynamatic (lower-handshake-to-hw, the input of export-rtl) and builds
 * DynaRapid's node graph from it. The legacy DOT export is gone from new Dynamatic, and its new
 * DOT export has no bit widths.
 *
 * hw.mlir has one hw.module per kernel (plus <kernel>_wrapper with the memory adapters, which the
 * shell replaces) holding one hw.instance per dataflow unit. Each instance refers to a
 * hw.module.extern whose hw.name and hw.parameters identify the RTL unit; that pair is the library
 * variant (dcpName), e.g. fork_DATA_TYPE_i32_SIZE_3.
 *
 * Ports:
 * - channel (!handshake.channel<iN>) and control (!handshake.control<>) ports become the node's
 *   inputs/outputs in declaration order; control ports have data width 0. The library wrapper of a
 *   variant exposes them with DynaRapid's standard names (dataInArray_<i>, pValidArray_<i>, ...).
 * - plain iN ports (memory interface, e.g. mem_controller loadData/loadAddr) keep their RTL names;
 *   DynaRapid brings them out as top-level ports (<node>_<port>_Port).
 * - kernel arguments and results are left unconnected on the node, so DynaRapid makes top-level
 *   ports for them; the port map file records which kernel port became which design ports.
 */
public class HwMlirParser {

    public static final int maxVariantNameLength = 120;

    //One port of a hw.module.extern / hw.module
    public static class Port {
        public final boolean isInput;
        public final String name;
        public final String type;

        Port(boolean isInput, String name, String type) {
            this.isInput = isInput;
            this.name = name;
            this.type = type;
        }

        //-1: not a handshake channel (plain signal); 0: control channel; else the data width
        public int channelWidth() {
            if (type.equals("!handshake.control<>"))
                return 0;
            if (!type.startsWith("!handshake.channel<"))
                return -1;
            String data = type.substring("!handshake.channel<".length(), type.length() - 1);
            if (data.contains(","))
                throw new IllegalArgumentException("channels with extra signals are not supported: " + type);
            return Integer.parseInt(data.substring(1)); //iN or fN
        }

        public boolean isClockOrReset() {
            return name.equals("clk") || name.equals("rst");
        }
    }

    public static class ExternModule {
        public String symbol;          //e.g. handshake_fork_1 (numbered per file)
        public String unitName;        //hw.name, e.g. handshake.fork
        public String parameters = ""; //hw.parameters, as printed
        public String variantName;     //library variant, stable across kernels
        public List<Port> ports = new ArrayList<>();
    }

    //Where a value comes from: an output port of a node, or an input port of the kernel
    static class Source {
        Node node;
        int channelIndex = -1; //index among the node's channel outputs, if a channel
        String port;           //RTL port name on the node, or kernel input name
        boolean kernelInput;
    }

    public static Map<String, ExternModule> externs = new LinkedHashMap<>();
    public static List<Port> kernelPorts = new ArrayList<>();
    public static String kernelName;
    //kernel port -> top-level design ports of the DynaRapid design
    public static Map<String, List<String>> portMap = new LinkedHashMap<>();

    public static Map<String, Node> parser(String mlirLoc) {
        StringUtils.printIntro("Parsing " + mlirLoc);
        Input.exactBitwidths = true;
        externs.clear();
        portMap.clear();

        try {
            List<String> lines = Files.readAllLines(Paths.get(mlirLoc));
            for (String line : lines)
                if (line.trim().startsWith("hw.module.extern "))
                    parseExtern(line.trim());

            int start = findKernelModule(lines);
            return parseKernel(lines, start);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR: Could not parse " + mlirLoc);
            return null;
        }
    }

    //The kernel is the hw.module that is not a <kernel>_wrapper
    static int findKernelModule(List<String> lines) {
        for (int i = 0; i < lines.size(); i++) {
            String s = lines.get(i).trim();
            if (s.startsWith("hw.module @") && !symbolAfter(s, "hw.module @").endsWith("_wrapper"))
                return i;
        }
        throw new IllegalArgumentException("no kernel hw.module found");
    }

    static String symbolAfter(String s, String prefix) {
        int b = s.indexOf(prefix) + prefix.length();
        int e = b;
        while (e < s.length() && (Character.isLetterOrDigit(s.charAt(e)) || s.charAt(e) == '_' || s.charAt(e) == '.'))
            e++;
        return s.substring(b, e);
    }

    //hw.module.extern @handshake_fork_1(in %ins : T, ..., out outs_0 : T) attributes {hw.name = "...", hw.parameters = {...}}
    static void parseExtern(String s) {
        ExternModule m = new ExternModule();
        m.symbol = symbolAfter(s, "hw.module.extern @");
        int open = s.indexOf('(', s.indexOf('@'));
        int close = matchingParen(s, open);
        m.ports = parsePortList(s.substring(open + 1, close));

        String attrs = s.substring(close + 1);
        int n = attrs.indexOf("hw.name = \"");
        if (n == -1)
            throw new IllegalArgumentException("extern module without hw.name: " + m.symbol);
        n += "hw.name = \"".length();
        m.unitName = attrs.substring(n, attrs.indexOf('"', n));

        int p = attrs.indexOf("hw.parameters = {");
        if (p != -1) {
            int b = p + "hw.parameters = ".length();
            m.parameters = attrs.substring(b + 1, matchingBrace(attrs, b));
        }
        m.variantName = variantName(m.unitName, m.parameters);
        externs.put(m.symbol, m);
    }

    static List<Port> parsePortList(String list) {
        List<Port> ports = new ArrayList<>();
        for (String item : splitTopLevel(list)) {
            item = item.trim();
            if (item.isEmpty())
                continue;
            boolean in = item.startsWith("in ");
            String rest = item.substring(item.indexOf(' ') + 1);
            String name = rest.substring(0, rest.indexOf(" : ")).trim();
            if (name.startsWith("%"))
                name = name.substring(1);
            ports.add(new Port(in, name, rest.substring(rest.indexOf(" : ") + 3).trim()));
        }
        return ports;
    }

    //One hw.instance of the kernel module
    static class Instance {
        String name;
        ExternModule module;
        Map<String, String> operands = new LinkedHashMap<>(); //port -> value
        String[] results;
        Boolean folded; //null: not decided yet
        Node node;      //the instance's node, if it isn't folded
    }

    static Map<String, Node> parseKernel(List<String> lines, int start) {
        String header = lines.get(start).trim();
        kernelName = symbolAfter(header, "hw.module @");
        int open = header.indexOf('(');
        kernelPorts = parsePortList(header.substring(open + 1, matchingParen(header, open)));

        Kernel k = new Kernel();
        for (Port p : kernelPorts)
            if (p.isInput)
                k.kernelInputs.put("%" + p.name, p);

        //Read every instance first: whether a unit folds depends on its operands, which may be
        //defined further down (loops)
        String output = null;
        for (int i = start + 1; i < lines.size(); i++) {
            String s = lines.get(i).trim();
            if (s.equals("}"))
                break;
            if (s.startsWith("hw.output")) {
                output = s;
                continue;
            }
            if (!s.contains("hw.instance \""))
                continue;

            Instance inst = new Instance();
            String results = s.contains(" = hw.instance") ? s.substring(0, s.indexOf(" = hw.instance")) : "";
            int q = s.indexOf("hw.instance \"") + "hw.instance \"".length();
            inst.name = s.substring(q, s.indexOf('"', q));
            String symbol = symbolAfter(s, "\" @");
            inst.module = externs.get(symbol);
            if (inst.module == null)
                throw new IllegalArgumentException("instance " + inst.name + " of unknown module @" + symbol);

            int ob = s.indexOf('(', s.indexOf("\" @"));
            for (String item : splitTopLevel(s.substring(ob + 1, matchingParen(s, ob)))) {
                //port: %value: type
                String[] parts = item.trim().split(":\\s*", 3);
                inst.operands.put(parts[0].trim(), parts[1].trim());
            }
            inst.results = results.isEmpty() ? new String[0] : results.split(",\\s*");
            for (int r = 0; r < inst.results.length; r++)
                inst.results[r] = inst.results[r].trim();
            List<Port> outs = new ArrayList<>();
            for (Port p : inst.module.ports)
                if (!p.isInput)
                    outs.add(p);
            if (inst.results.length != outs.size())
                throw new IllegalArgumentException(inst.name + ": " + inst.results.length + " results for " + outs.size() + " outputs");
            for (int r = 0; r < outs.size(); r++)
                k.producer.put(inst.results[r], Map.entry(inst, outs.get(r)));
            k.instances.add(inst);
        }

        //Fold what can be folded; everything else becomes a node
        Map<String, Node> nodes = new LinkedHashMap<>();
        Map<String, Source> values = new HashMap<>();
        Map<String, Integer> folds = new TreeMap<>();
        for (Instance inst : k.instances) {
            if (k.decide(inst)) {
                folds.merge(inst.module.unitName, 1, Integer::sum);
                continue;
            }
            ExternModule m = inst.module;
            List<Integer> inWidths = new ArrayList<>(), outWidths = new ArrayList<>();
            List<Port> outs = new ArrayList<>();
            for (Port p : m.ports) {
                int w = p.channelWidth();
                if (p.isInput && w >= 0)
                    inWidths.add(w);
                if (!p.isInput) {
                    outs.add(p);
                    if (w >= 0)
                        outWidths.add(w);
                }
            }

            String description = inst.name + " @" + m.symbol + " (" + m.unitName + " {" + m.parameters + "})";
            Node node = new Node(inst.name, m.unitName, m.variantName, inWidths, outWidths, description);
            inst.node = node;
            nodes.put(inst.name, node);

            int channelIndex = 0;
            for (int r = 0; r < outs.size(); r++) {
                Source src = new Source();
                src.node = node;
                src.port = outs.get(r).name;
                if (outs.get(r).channelWidth() >= 0)
                    src.channelIndex = channelIndex++;
                values.put(inst.results[r], src);
            }
        }
        for (Map.Entry<String, Port> e : k.kernelInputs.entrySet()) {
            Source src = new Source();
            src.kernelInput = true;
            src.port = e.getValue().name;
            values.put(e.getKey(), src);
        }

        //Connect the channel inputs of the nodes through the (folded) wiring. Folding keeps every
        //handshake with one reader (values have one use, and a folded unit passes its operand's on)
        Set<String> read = new HashSet<>(k.readyHigh);
        for (Instance inst : k.instances) {
            if (inst.folded)
                continue;
            Node node = inst.node;
            int channelIndex = 0;
            for (Port p : inst.module.ports) {
                if (!p.isInput || p.isClockOrReset())
                    continue;
                String value = inst.operands.get(p.name);

                if (p.channelWidth() < 0) { //plain signal: must come from the kernel ports
                    Source src = values.get(value);
                    if (src == null)
                        throw new IllegalArgumentException(node.name + "." + p.name + ": undefined value " + value);
                    if (!src.kernelInput)
                        throw new IllegalArgumentException(node.name + "." + p.name + ": plain signal between units is not supported");
                    mapPort(src.port, node.name + "_" + p.name + "_Port");
                    continue;
                }

                FoldedUnits.Wiring w = k.wiring(value);
                Source src = w.handshake == null ? null : values.get(w.handshake);
                if (w.handshake != null && src == null)
                    throw new IllegalArgumentException(node.name + "." + p.name + ": undefined value " + w.handshake);
                if (w.handshake != null && !read.add(w.handshake))
                    throw new IllegalArgumentException(node.name + "." + p.name + ": the handshake of " + w.handshake + " has two readers");

                //straight: the whole channel, bit for bit (a truncation keeps bits in place but is narrower)
                boolean straight = w.handshake != null && w.isIdentity(w.handshake) && w.bits.length == k.width(w.handshake);
                if (src != null && src.kernelInput) {
                    if (straight)
                        mapChannelPort(src.port, node.name, "din_", "valid_in_", "ready_out_", channelIndex, p.channelWidth());
                    else { //a constant triggered by a kernel port
                        mapChannelPort(src.port, node.name, null, "valid_in_", "ready_out_", channelIndex, 0);
                        node.inputs.get(channelIndex).connectToWiring(null, w.bits, false);
                    }
                } else if (src == null)
                    node.inputs.get(channelIndex).connectToWiring(null, w.bits, true);
                else if (straight) {
                    node.connectInput(channelIndex, src.node, src.channelIndex);
                    src.node.connectOutput(src.channelIndex, node, channelIndex);
                } else {
                    Output out = src.node.outputs.get(src.channelIndex);
                    Input in = node.inputs.get(channelIndex);
                    in.connectToWiring(out, w.bits, false);
                    out.connectToWiringInput(in, w.bits);
                }
                channelIndex++;
            }
        }
        for (String value : k.readyHigh) {
            Source src = values.get(value);
            src.node.outputs.get(src.channelIndex).tieReadyHigh();
        }

        //Kernel results
        if (output == null)
            throw new IllegalArgumentException("kernel without hw.output");
        String outValues = output.substring("hw.output".length(), output.lastIndexOf(" : ")).trim();
        List<Port> kernelOuts = new ArrayList<>();
        for (Port p : kernelPorts)
            if (!p.isInput)
                kernelOuts.add(p);
        String[] outs = outValues.isEmpty() ? new String[0] : outValues.split(",\\s*");
        for (int i = 0; i < outs.length; i++) {
            String value = outs[i].trim();
            Port p = kernelOuts.get(i);
            if (p.channelWidth() >= 0) {
                FoldedUnits.Wiring w = k.wiring(value);
                if (w.handshake == null || !w.isIdentity(w.handshake) || w.bits.length != k.width(w.handshake))
                    throw new IllegalArgumentException("kernel result " + p.name + " is folded wiring (" + w + "), not a unit's output");
                value = w.handshake;
            }
            Source src = values.get(value);
            if (src.kernelInput)
                throw new IllegalArgumentException("kernel input " + src.port + " passed straight to output " + p.name);
            if (src.channelIndex < 0)
                mapPort(p.name, src.node.name + "_" + src.port + "_Port");
            else
                mapChannelPort(p.name, src.node.name, "dout_", "valid_out_", "ready_in_", src.channelIndex, p.channelWidth());
        }

        if (!folds.isEmpty())
            System.out.println("Folded into wiring (no blocks): " + folds);
        System.out.println("Kernel " + kernelName + ": " + nodes.size() + " units, " + new HashSet<>(variantNames(nodes)).size() + " variants");
        return nodes;
    }

    //The kernel's instances, and the wiring of every channel value once units are folded
    static class Kernel {
        List<Instance> instances = new ArrayList<>();
        Map<String, Port> kernelInputs = new LinkedHashMap<>();
        Map<String, Map.Entry<Instance, Port>> producer = new HashMap<>(); //value -> instance and output port
        Map<String, FoldedUnits.Wiring> wirings = new HashMap<>();
        Set<String> readyHigh = new LinkedHashSet<>(); //values read by a folded sink
        Set<Instance> deciding = new HashSet<>();

        //Folds the instance if it can be (FoldedUnits, or a wire-only unit, see WireUnits)
        boolean decide(Instance inst) {
            if (inst.folded != null)
                return inst.folded;
            if (!deciding.add(inst))
                throw new IllegalArgumentException("cycle of folded units at " + inst.name);

            ExternModule m = inst.module;
            Map<String, FoldedUnits.Wiring> folded = null;
            if (FoldedUnits.isCandidate(m.unitName)) {
                Map<String, FoldedUnits.Wiring> in = new HashMap<>();
                Map<String, Integer> outWidths = new HashMap<>();
                for (Port p : m.ports) {
                    if (p.isClockOrReset())
                        continue;
                    if (p.channelWidth() < 0)
                        throw new IllegalArgumentException(inst.name + "." + p.name + ": " + m.unitName + " with a plain signal");
                    if (p.isInput)
                        in.put(p.name, wiring(inst.operands.get(p.name)));
                    else
                        outWidths.put(p.name, p.channelWidth());
                }
                folded = FoldedUnits.fold(m.unitName, m.parameters, in, outWidths, kernelInputs::containsKey);
                if (folded != null && m.unitName.equals("handshake.sink")) {
                    String h = in.get("ins").handshake;
                    if (h != null)
                        readyHigh.add(h);
                }
            } else {
                //Wire-only unit (no cells, see WireUnits): its outputs are wired to its inputs
                int[] wire = WireUnits.channelMap(m.variantName);
                if (wire != null) {
                    List<FoldedUnits.Wiring> ins = new ArrayList<>();
                    List<String> outNames = new ArrayList<>();
                    for (Port p : m.ports) {
                        if (p.isClockOrReset())
                            continue;
                        if (p.channelWidth() < 0)
                            throw new IllegalArgumentException(inst.name + "." + p.name + ": wire-only unit with a plain signal");
                        if (p.isInput)
                            ins.add(wiring(inst.operands.get(p.name)));
                        else
                            outNames.add(p.name);
                    }
                    folded = new HashMap<>();
                    for (int o = 0; o < outNames.size(); o++)
                        folded.put(outNames.get(o), ins.get(wire[o]));
                }
            }

            deciding.remove(inst);
            inst.folded = folded != null;
            if (folded != null) {
                int r = 0;
                for (Port p : m.ports)
                    if (!p.isInput)
                        wirings.put(inst.results[r++], folded.get(p.name));
            }
            return inst.folded;
        }

        //Data width of a value of a real unit or a kernel port
        int width(String value) {
            Map.Entry<Instance, Port> def = producer.get(value);
            Port port = def != null ? def.getValue() : kernelInputs.get(value);
            return Math.max(port.channelWidth(), 0);
        }

        //The wiring of a channel value: what it was folded to, or the value itself
        FoldedUnits.Wiring wiring(String value) {
            FoldedUnits.Wiring w = wirings.get(value);
            if (w != null)
                return w;
            Map.Entry<Instance, Port> def = producer.get(value);
            Port port = def != null ? def.getValue() : kernelInputs.get(value);
            if (port == null)
                throw new IllegalArgumentException("undefined value " + value);
            if (def != null && decide(def.getKey()))
                return wirings.get(value);
            return FoldedUnits.Wiring.identity(value, Math.max(port.channelWidth(), 0));
        }
    }

    static void mapPort(String kernelPort, String designPort) {
        portMap.computeIfAbsent(kernelPort, k -> new ArrayList<>()).add(designPort);
    }

    static void mapChannelPort(String kernelPort, String node, String data, String valid, String ready, int index, int width) {
        if (width > 0 && data != null)
            mapPort(kernelPort, node + "_" + data + index);
        mapPort(kernelPort, node + "_" + valid + index);
        mapPort(kernelPort, node + "_" + ready + index);
    }

    static List<String> variantNames(Map<String, Node> nodes) {
        List<String> names = new ArrayList<>();
        for (Node n : nodes.values())
            names.add(n.dcpName);
        return names;
    }

    /*
     * Library variant name: unit name without "handshake.", then each parameter as _KEY_value.
     * The name is also the variant's VHDL entity, so it is a basic VHDL identifier: no "__", no
     * leading or trailing '_' (parameter keys are upper case, which keeps the name readable).
     * Types print as i32/f32/ctrl, numbers without their type, strings without quotes; SMV_* parameters
 * (formal verification only) are left out.
     * Over maxVariantNameLength (e.g. the LSQ's per-instance configuration) the parameters
     * are replaced by a CRC32 of their text.
     */
    public static String variantName(String unitName, String parameters) {
        String base = unitName.startsWith("handshake.") ? unitName.substring("handshake.".length()) : unitName;
        StringBuilder name = new StringBuilder(base);
        for (String item : splitTopLevel(parameters)) {
            item = item.trim();
            if (item.isEmpty())
                continue;
            int eq = item.indexOf(" = ");
            if (eq == -1)
                throw new IllegalArgumentException("unexpected parameter '" + item + "' of " + unitName);
            //SMV_*: names for the formal-verification (SMV) back end; they don't change the RTL
            if (item.substring(0, eq).startsWith("SMV_"))
                continue;
            name.append("_").append(item.substring(0, eq)).append('_').append(parameterValue(item.substring(eq + 3)));
        }
        String full = name.toString().replaceAll("_+", "_").replaceAll("_$", "");
        if (full.length() <= maxVariantNameLength)
            return full;

        CRC32 crc = new CRC32();
        crc.update(parameters.getBytes());
        return base + "_h" + String.format("%08x", crc.getValue());
    }

    static String parameterValue(String v) {
        v = v.trim();
        if (v.equals("!handshake.control<>"))
            return "ctrl";
        if (v.startsWith("!handshake.channel<"))
            v = v.substring("!handshake.channel<".length(), v.length() - 1);
        else if (v.startsWith("\""))
            v = v.substring(1, v.length() - 1);
        else if (v.matches("-?[0-9]+ : [a-z]+[0-9]+"))
            v = v.substring(0, v.indexOf(' '));
        else if (v.startsWith("#handshake<timing {")) //#handshake<timing {D: 0, V: 0, R: 1}>
            v = v.substring(v.indexOf('{') + 1, v.indexOf('}')).replaceAll("[:,\\s]", "");
        return v.replace("-", "m").replaceAll("[^A-Za-z0-9]+", "_");
    }

    //Splits at commas that are not inside <>, (), [], {} or a string
    static List<String> splitTopLevel(String s) {
        List<String> items = new ArrayList<>();
        int depth = 0, begin = 0;
        boolean inString = false;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '"' && (i == 0 || s.charAt(i - 1) != '\\'))
                inString = !inString;
            else if (inString)
                continue;
            else if (c == '<' || c == '(' || c == '[' || c == '{')
                depth++;
            else if (c == '>' || c == ')' || c == ']' || c == '}')
                depth--;
            else if (c == ',' && depth == 0) {
                items.add(s.substring(begin, i));
                begin = i + 1;
            }
        }
        items.add(s.substring(begin));
        return items;
    }

    static int matchingParen(String s, int open) {
        return matching(s, open, '(', ')');
    }

    static int matchingBrace(String s, int open) {
        return matching(s, open, '{', '}');
    }

    static int matching(String s, int open, char o, char c) {
        int depth = 0;
        for (int i = open; i < s.length(); i++) {
            if (s.charAt(i) == o)
                depth++;
            else if (s.charAt(i) == c && --depth == 0)
                return i;
        }
        throw new IllegalArgumentException("unbalanced " + o + " in: " + s);
    }

    /*
     * Writes <out>_variants.tsv (one line per library variant: name, count, extern symbol,
     * hw.name, parameters, ports), <out>_externs.tsv (every extern module used -> its variant)
     * and <out>_ports.tsv (kernel port -> design ports).
     */
    public static void writeTables(Map<String, Node> nodes, String outPrefix) throws IOException {
        Map<String, Integer> counts = new TreeMap<>();
        for (String v : variantNames(nodes))
            counts.merge(v, 1, Integer::sum);

        Map<String, ExternModule> byVariant = new TreeMap<>();
        for (ExternModule m : externs.values())
            if (counts.containsKey(m.variantName))
                byVariant.putIfAbsent(m.variantName, m);

        try (PrintWriter w = new PrintWriter(outPrefix + "_variants.tsv")) {
            w.println("# variant\tinstances\textern\thw.name\tparameters\tports");
            for (ExternModule m : byVariant.values()) {
                StringBuilder ports = new StringBuilder();
                for (Port p : m.ports)
                    ports.append(ports.length() == 0 ? "" : ", ").append(p.isInput ? "in " : "out ").append(p.name).append(" : ").append(p.type);
                w.println(m.variantName + "\t" + counts.get(m.variantName) + "\t" + m.symbol + "\t" + m.unitName + "\t" + m.parameters + "\t" + ports);
            }
        }

        try (PrintWriter w = new PrintWriter(outPrefix + "_externs.tsv")) {
            w.println("# extern\tvariant");
            for (ExternModule m : externs.values())
                if (counts.containsKey(m.variantName))
                    w.println(m.symbol + "\t" + m.variantName);
        }

        try (PrintWriter w = new PrintWriter(outPrefix + "_ports.tsv")) {
            w.println("# kernel port\tdirection\ttype\tdesign ports");
            for (Port p : kernelPorts) {
                if (p.isClockOrReset())
                    continue;
                w.println(p.name + "\t" + (p.isInput ? "in" : "out") + "\t" + p.type + "\t" + String.join(" ", portMap.getOrDefault(p.name, List.of())));
            }
        }
    }
}
