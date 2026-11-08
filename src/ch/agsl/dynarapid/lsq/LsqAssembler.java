/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.lsq;

import ch.agsl.dynarapid.GenerateDesign;
import ch.agsl.dynarapid.map.MapElement;
import ch.agsl.dynarapid.modules.*;
import ch.agsl.dynarapid.modules.Node;
import ch.agsl.dynarapid.parser.*;

import com.xilinx.rapidwright.design.*;
import com.xilinx.rapidwright.device.*;
import com.xilinx.rapidwright.edif.*;

import java.nio.file.*;
import java.util.*;

/*
 * An LSQ assembled from library sub-units (warp docs/plans/lsq-subunits.md). The kernel graph
 * keeps the LSQ as one node (Node.lsq); this class gives that node a composite shape, so the
 * placer places the LSQ like any unit, then turns it into its sub-units and connects them:
 *
 * - floorplan (graph generation): the sub-units' shapes (the tallest of each) packed around the
 *   core, a fixed gap apart, at a core place near the design center; the composite shape is their
 *   bounding box, valid wherever every sub-unit's shape is (one pass, no search over sizes);
 * - expand (before module loading): one node per sub-unit, placed at its offset in the composite;
 * - stitch: the nets between sub-units and between the LSQ and the kernel, from the net map of
 *   scripts/lsq_subunits.py (<extern>.req.json in the directory given by -Ddynarapid.lsqDir);
 * - patchTables (after flattening): the group allocator's table LUTs get this kernel's INITs.
 */
public class LsqAssembler {
    public static final String DIR_PROPERTY = "dynarapid.lsqDir";
    //Map cells between sub-units (rows and columns), for the nets between them
    public static final int GAP = Integer.getInteger("dynarapid.lsqGap", 1);
    //Order in which sub-units are packed around the core: the widest nets to the core first
    static final String[] ORDER = {"ldd", "std", "stb", "lda", "sta", "ga"};
    //Core places tried for the template, nearest the design center first
    static final int TEMPLATE_TRIES = 64;

    public static String centerSiteName = null; //GenerateDesign's -center, if a site
    public static int[] window = null; //GenerateDesign's window: top row, bottom row, left column, right column
    static final Map<String, LsqAssembler> assemblies = new LinkedHashMap<>();
    //Parsed sub-units by name, shared by every role and LSQ that uses one: two Shapes of one DCP
    //would load it as two Modules, which RapidWright refuses
    static final Map<String, Component> parsed = new HashMap<>();

    final Node lsq;
    final LsqRequirement req;
    final HwMlirParser.ExternModule extern;
    final Map<String, Component> comps = new LinkedHashMap<>();
    final Map<String, Shape> shapes = new LinkedHashMap<>();
    final Map<String, int[]> escapes = new LinkedHashMap<>();
    final Map<String, int[]> offsets = new LinkedHashMap<>(); //role -> {row, col} from the composite's top-left
    final Map<String, Node> sub = new LinkedHashMap<>();
    final List<String> inChannels = new ArrayList<>(), outChannels = new ArrayList<>();
    final List<HwMlirParser.Port> plain = new ArrayList<>();

    LsqAssembler(Node lsq, LsqRequirement req, HwMlirParser.ExternModule extern) {
        this.lsq = lsq;
        this.req = req;
        this.extern = extern;
        for (HwMlirParser.Port p : extern.ports) {
            if (p.isClockOrReset())
                continue;
            if (p.channelWidth() < 0)
                plain.add(p);
            else
                (p.isInput ? inChannels : outChannels).add(p.name);
        }
    }

    public static boolean any() {
        return !assemblies.isEmpty();
    }

    public static Collection<LsqAssembler> all() {
        return assemblies.values();
    }

    public static LsqAssembler of(Node n) {
        return assemblies.get(n.name);
    }

    // ---- floorplan ----

    static class Rect {
        final int i, j, rows, cols;

        Rect(int i, int j, int rows, int cols) {
            this.i = i;
            this.j = j;
            this.rows = rows;
            this.cols = cols;
        }

        boolean overlaps(Rect o, int gap) {
            return i < o.i + o.rows + gap && o.i < i + rows + gap && j < o.j + o.cols + gap && o.j < j + cols + gap;
        }

        //The rectangle its routes use: e = {up, down, left, right} in map cells (see escape)
        Rect grown(int[] e) {
            return new Rect(i - e[0], j - e[2], rows + e[0] + e[1], cols + e[2] + e[3]);
        }

        int distance(Rect o) {
            int di = Math.max(0, Math.max(o.i - (i + rows), i - (o.i + o.rows)));
            int dj = Math.max(0, Math.max(o.j - (j + cols), j - (o.j + o.cols)));
            return di + dj;
        }
    }

    static int[] parseLoc(String loc) {
        int u = loc.indexOf('_');
        return new int[] {Integer.parseInt(loc.substring(1, u)), Integer.parseInt(loc.substring(u + 2))};
    }

    static String loc(int i, int j) {
        return "R" + i + "_C" + j;
    }

    static int[] centerCoordinates(Device device) {
        String site = centerSiteName != null ? centerSiteName : GenerateDesign.defaultCenterSite();
        String coord = MapElement.findInMap(device.getSite(site).getTile().getName());
        return new int[] {Integer.parseInt(coord.substring(0, coord.indexOf(':'))), Integer.parseInt(coord.substring(coord.indexOf(':') + 1))};
    }

    //The composite component of an LSQ node, or null (with the reason printed)
    public static Component floorplan(Node lsq, Device device) {
        try {
            String dir = System.getProperty(DIR_PROPERTY);
            if (dir == null)
                throw new IllegalStateException("LSQ " + lsq.name + ": no -D" + DIR_PROPERTY + " with its sub-unit split");
            HwMlirParser.ExternModule m = HwMlirParser.lsqs.get(lsq.name);
            LsqRequirement req = LsqRequirement.read(Paths.get(dir, m.symbol + ".req.json"));
            LsqAssembler a = new LsqAssembler(lsq, req, m);
            Component c = a.plan(device);
            assemblies.put(lsq.name, a);
            return c;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR: LSQ " + lsq.name + ": " + e.getMessage());
            return null;
        }
    }

    Component plan(Device device) {
        Map<String, Set<String>> valid = new LinkedHashMap<>();
        for (Map.Entry<String, String> e : req.subunits.entrySet()) {
            Component c = parsed.computeIfAbsent(e.getValue(), n -> new DatabaseParser().parser(n, device));
            if (c == null || c.shapeList.isEmpty())
                throw new IllegalStateException("sub-unit " + e.getValue() + " is not in the library");
            Shape best = null;
            for (Shape s : c.shapeList)
                if (best == null || s.currRow > best.currRow || (s.currRow == best.currRow && s.currCol < best.currCol))
                    best = s;
            comps.put(e.getKey(), c);
            shapes.put(e.getKey(), best);
            escapes.put(e.getKey(), escape(best));
            valid.put(e.getKey(), best.validTopLeftAnchorLocations);
        }

        //The template: every sub-unit at its nearest valid place around the core, at a core place
        //near the design center
        Shape core = shapes.get("core");
        int[] center = centerCoordinates(device);
        List<int[]> corePlaces = new ArrayList<>();
        for (String l : valid.get("core"))
            corePlaces.add(parseLoc(l));
        corePlaces.sort(Comparator.<int[]>comparingInt(p -> Math.abs(p[0] + core.currRow / 2 - center[0]) + Math.abs(p[1] + core.currCol / 2 - center[1]))
                .thenComparingInt(p -> p[0]).thenComparingInt(p -> p[1]));

        Map<String, Rect> placed = null;
        for (int t = 0; t < Math.min(TEMPLATE_TRIES, corePlaces.size()) && placed == null; t++)
            placed = packAround(corePlaces.get(t), valid);
        if (placed == null)
            throw new IllegalStateException("no template: the sub-units' valid places don't fit around the core");

        //The composite covers the sub-units' routes too, so kernel units keep clear of them
        int i0 = Integer.MAX_VALUE, j0 = Integer.MAX_VALUE, i1 = Integer.MIN_VALUE, j1 = Integer.MIN_VALUE;
        for (Map.Entry<String, Rect> pe : placed.entrySet()) {
            Rect r = pe.getValue().grown(escapes.get(pe.getKey()));
            i0 = Math.min(i0, r.i);
            j0 = Math.min(j0, r.j);
            i1 = Math.max(i1, r.i + r.rows);
            j1 = Math.max(j1, r.j + r.cols);
        }
        for (Map.Entry<String, Rect> e : placed.entrySet())
            offsets.put(e.getKey(), new int[] {e.getValue().i - i0, e.getValue().j - j0});

        //The composite is valid wherever every sub-unit's shape is, at its offset
        int[] co = offsets.get("core");
        HashSet<String> compositeValid = new HashSet<>();
        Map<String, Site> sites = new HashMap<>();
        for (String l : valid.get("core")) {
            int[] p = parseLoc(l);
            int ti = p[0] - co[0], tj = p[1] - co[1];
            boolean ok = true;
            for (Map.Entry<String, int[]> e : offsets.entrySet())
                if (!valid.get(e.getKey()).contains(loc(ti + e.getValue()[0], tj + e.getValue()[1]))) {
                    ok = false;
                    break;
                }
            if (ok) {
                compositeValid.add(loc(ti, tj));
                sites.put(loc(ti, tj), core.validSiteMap.get(l));
            }
        }

        int clel = 0, clem = 0, dsp = 0, bram = 0;
        for (Component c : comps.values()) {
            clel += c.dcp.clel;
            clem += c.dcp.clem;
            dsp += c.dcp.dsp;
            bram += c.dcp.bram;
        }
        Component composite = new Component(lsq.dcpName, clel, clem, dsp, bram, 1);
        Shape s = new Shape(composite, i0, j0, i1 - i0, j1 - j0, lsq.dcpName + "_assembled", 0.0, 0, 0,
                core.side, core.siteIndex, core.rwAnchorSiteName, core.rwAnchorTileName, compositeValid);
        s.validSiteMap = sites;
        composite.shapeList.add(s);

        System.out.println("LSQ " + lsq.name + " (" + req.key + "): " + req.subunits.size() + " sub-units in "
                + (i1 - i0) + " x " + (j1 - j0) + " map cells, " + compositeValid.size() + " valid places"
                + span(compositeValid));
        for (Map.Entry<String, int[]> e : offsets.entrySet())
            System.out.println("  " + e.getKey() + " " + req.subunits.get(e.getKey()) + " " + shapes.get(e.getKey()).currRow + "x"
                    + shapes.get(e.getKey()).currCol + " at +" + e.getValue()[0] + ",+" + e.getValue()[1]);
        return composite;
    }

    //How far a library shape's routes reach past its cells, {up, down, left, right} in tiles (one
    //map cell each): Vivado's CONTAIN_ROUTING still lets a few rows of routing out of the pblock,
    //so sub-units placed closer than this would share wires. Measured once from the routed
    //checkpoint and kept next to it (<shape>_placedRouted.escape).
    static int[] escape(Shape s) {
        Path dir = LocationParser.libraryPath(s.component.dcpName);
        Path f = dir.resolve(s.pblockName + "_placedRouted.escape");
        try {
            if (Files.exists(f)) {
                String[] w = Files.readString(f).trim().split("\\s+");
                return new int[] {Integer.parseInt(w[0]), Integer.parseInt(w[1]), Integer.parseInt(w[2]), Integer.parseInt(w[3])};
            }
            Design d = Design.readCheckpoint(dir.resolve(s.pblockName + "_placedRouted.dcp").toString());
            int[] c = {Integer.MAX_VALUE, -1, Integer.MAX_VALUE, -1}, r = {Integer.MAX_VALUE, -1, Integer.MAX_VALUE, -1};
            for (SiteInst si : d.getSiteInsts())
                if (!si.getCells().isEmpty())
                    grow(c, si.getTile());
            for (Net n : d.getNets())
                if (!n.isClockNet() && !n.isStaticNet())
                    for (PIP p : n.getPIPs()) {
                        grow(r, p.getStartNode().getTile());
                        grow(r, p.getEndNode().getTile());
                    }
            //tile rows grow downward, like map rows
            int[] e = {Math.max(0, c[2] - r[2]), Math.max(0, r[3] - c[3]), Math.max(0, c[0] - r[0]), Math.max(0, r[1] - c[1])};
            Files.writeString(f, e[0] + " " + e[1] + " " + e[2] + " " + e[3] + "\n");
            return e;
        } catch (java.io.IOException x) {
            throw new IllegalStateException("escape of " + s.pblockName + ": " + x);
        }
    }

    static void grow(int[] e, Tile t) {
        e[0] = Math.min(e[0], t.getTileXCoordinate());
        e[1] = Math.max(e[1], t.getTileXCoordinate());
        e[2] = Math.min(e[2], t.getTileYCoordinate());
        e[3] = Math.max(e[3], t.getTileYCoordinate());
    }

    //Every sub-unit at its valid place nearest the core (placed at p), its routes GAP apart from the
    //others' (escape); null if one doesn't fit
    Map<String, Rect> packAround(int[] p, Map<String, Set<String>> valid) {
        Map<String, Rect> placed = new LinkedHashMap<>();
        Shape core = shapes.get("core");
        Rect coreRect = new Rect(p[0], p[1], core.currRow, core.currCol);
        placed.put("core", coreRect);
        Map<String, Rect> routes = new LinkedHashMap<>();
        routes.put("core", coreRect.grown(escapes.get("core")));
        //A wide core's column pattern matches at one place only, so the composite moves up and down
        //but not sideways: every sub-unit (with its routes) must sit inside the window's columns, and
        //the composite is kept short, so that several LSQs stack in one column of the window
        //(netecho: three in region 0). Then distance to the core.
        int r0 = routes.get("core").i, r1 = r0 + routes.get("core").rows;
        int left = window != null ? window[2] : Integer.MIN_VALUE, right = window != null ? window[3] : Integer.MAX_VALUE;
        for (String tag : ORDER) {
            Shape s = shapes.get(tag);
            if (s == null)
                continue;
            Rect best = null;
            int bestScore = Integer.MAX_VALUE;
            for (String l : valid.get(tag)) {
                int[] q = parseLoc(l);
                Rect r = new Rect(q[0], q[1], s.currRow, s.currCol);
                Rect rr = r.grown(escapes.get(tag));
                if (rr.j < left || rr.j + rr.cols - 1 > right)
                    continue;
                int taller = Math.max(0, r0 - rr.i) + Math.max(0, rr.i + rr.rows - r1);
                int score = taller * 1000000 + r.distance(coreRect) * 1000 + Math.abs(q[0] - p[0]);
                if (score >= bestScore)
                    continue;
                boolean free = true;
                for (Rect o : routes.values())
                    if (rr.overlaps(o, GAP)) {
                        free = false;
                        break;
                    }
                if (free) {
                    best = r;
                    bestScore = score;
                }
            }
            if (best == null)
                return null;
            placed.put(tag, best);
            Rect g = best.grown(escapes.get(tag));
            routes.put(tag, g);
            r0 = Math.min(r0, g.i);
            r1 = Math.max(r1, g.i + g.rows);
        }
        return placed;
    }

    // ---- expansion into sub-unit nodes ----

    //The sub-unit nodes of every placed LSQ, at their offsets in its composite
    public static List<Node> expand() {
        List<Node> out = new ArrayList<>();
        for (LsqAssembler a : assemblies.values()) {
            int[] tl = parseLoc(a.lsq.topLeftAnchorLoc);
            for (Map.Entry<String, int[]> e : a.offsets.entrySet()) {
                String tag = e.getKey();
                String l = loc(tl[0] + e.getValue()[0], tl[1] + e.getValue()[1]);
                Shape s = a.shapes.get(tag);
                if (!s.validTopLeftAnchorLocations.contains(l))
                    throw new IllegalStateException("LSQ " + a.lsq.name + ": " + tag + " can't be placed at " + l);
                Node n = new Node(a.lsq.name + "_" + tag, "lsq." + tag, a.req.subunits.get(tag), List.of(), List.of(),
                        a.lsq.name + " " + tag + " (" + a.req.subunits.get(tag) + ")");
                n.updateComponent(a.comps.get(tag));
                n.updatePlacementData(s, l);
                a.sub.put(tag, n);
                out.add(n);
            }
        }
        return out;
    }

    // ---- stitching ----

    ModuleInst inst(String role) {
        return sub.get(role).moduleInst;
    }

    static int width(ModuleInst mi, String port) {
        EDIFPort p = mi.getCellInst().getPort(port);
        if (p == null)
            throw new IllegalStateException(mi.getName() + " has no port " + port);
        return p.getWidth();
    }

    //Bus index of bit i of a sub-unit port (-1 for a single-bit port)
    static int bit(ModuleInst mi, String port, int i) {
        EDIFPort p = mi.getCellInst().getPort(port);
        return p != null && p.isBus() ? i : -1;
    }

    static void topPort(EDIFCell top, String name, int width, EDIFDirection dir) {
        if (top.getPort(name) == null)
            top.createPort(width > 1 ? name + "[" + (width - 1) + ":0]" : name, dir, width);
    }

    //Drives the sinks of an LSQ input port from bit `outBit` of a kernel unit's output port (or a
    //constant, or a top-level port bit when outInst is null)
    void driveSinks(String lsqPort, int i, ModuleInst outInst, String outPort, int outBit, Boolean constant, String topName, int topBit) {
        for (LsqRequirement.End e : req.sinks(lsqPort)) {
            ModuleInst si = inst(e.block);
            int b = bit(si, e.port, i);
            if (constant != null)
                Input.tieToStatic(si, e.port, b, constant);
            else if (outInst != null)
                Input.connectBit(outInst, outPort, outBit, si, e.port, b);
            else
                si.connect(e.port, b, null, topName, topBit);
        }
    }

    //Connects the driver of an LSQ output port to bit `inBit` of a kernel unit's input port (or to
    //a top-level port bit when inInst is null)
    void fromDriver(String lsqPort, int i, ModuleInst inInst, String inPort, int inBit, String topName, int topBit) {
        LsqRequirement.Net n = req.driver(lsqPort);
        if (n == null)
            throw new IllegalStateException("LSQ " + lsq.name + ": nothing drives " + lsqPort);
        if (n.constant != null) {
            if (inInst != null)
                Input.tieToStatic(inInst, inPort, inBit, n.constant.equals("1"));
            else
                throw new IllegalStateException("LSQ " + lsq.name + ": constant " + lsqPort + " to a top-level port");
            return;
        }
        ModuleInst di = inst(n.from.block);
        int b = bit(di, n.from.port, i);
        if (inInst != null)
            Input.connectBit(di, n.from.port, b, inInst, inPort, inBit);
        else
            di.connect(n.from.port, b, null, topName, topBit);
    }

    //Index of bit i of a kernel unit's output in its port, as Input.stitchToOutput computes it
    static int kernelOutBit(Input in, int i) {
        Output out = in.dataOutArray[i];
        int b = in.dataOutBit != null ? in.dataOutBit[i] : i;
        if (out.bitSize == 1)
            return -1;
        if (in.dataOutBit == null && out.bitSize <= i)
            return 0;
        return b;
    }

    //The LSQ's own peripherals: nets between sub-units, its inputs, its outputs with no reader, its
    //plain ports. Inputs of kernel units that read the LSQ are stitched by stitchKernelInput.
    public void stitch() {
        EDIFCell top = lsq.design.getNetlist().getTopCell();
        for (LsqRequirement.Net n : req.internal()) {
            ModuleInst di = inst(n.from.block);
            int w = width(di, n.from.port);
            for (LsqRequirement.End e : n.to) {
                if (e.isLsq())
                    continue;
                ModuleInst si = inst(e.block);
                for (int i = 0; i < w; i++)
                    Input.connectBit(di, n.from.port, bit(di, n.from.port, i), si, e.port, bit(si, e.port, i));
            }
        }

        for (int k = 0; k < lsq.inputs.size(); k++) {
            Input in = lsq.inputs.get(k);
            String h = "io_" + inChannels.get(k);
            for (int i = 0; i < in.bitSize && in.bitSize > 0 && !in.bitSizeWasZero; i++) {
                Output src = in.dataOutArray[i];
                if (src == Output.GND || src == Output.VCC)
                    driveSinks(h + "_bits", i, null, null, -1, src == Output.VCC, null, -1);
                else if (src == null) {
                    String name = lsq.name + "_din_" + k;
                    topPort(top, name, in.bitSize, EDIFDirection.INPUT);
                    driveSinks(h + "_bits", i, null, null, -1, null, name, in.bitSize > 1 ? i : -1);
                } else
                    driveSinks(h + "_bits", i, src.node.moduleInst, ModulePorts.DataOut + src.index, kernelOutBit(in, i), null, null, -1);
            }
            if (in.validArray == Output.VCC)
                driveSinks(h + "_valid", 0, null, null, -1, true, null, -1);
            else if (in.validArray == null) {
                String name = lsq.name + "_valid_in_" + k;
                topPort(top, name, 1, EDIFDirection.INPUT);
                driveSinks(h + "_valid", 0, null, null, -1, null, name, -1);
            } else
                driveSinks(h + "_valid", 0, in.validArray.node.moduleInst, ModulePorts.ValidOut + in.validArray.index, -1, null, null, -1);
            if (in.nReadyArray != null)
                fromDriver(h + "_ready", 0, in.nReadyArray.node.moduleInst, ModulePorts.ReadyIn + in.nReadyArray.index, -1, null, -1);
            else if (!in.readyUnused) {
                String name = lsq.name + "_ready_out_" + k;
                topPort(top, name, 1, EDIFDirection.OUTPUT);
                fromDriver(h + "_ready", 0, null, null, -1, name, -1);
            }
        }

        for (int k = 0; k < lsq.outputs.size(); k++) {
            Output out = lsq.outputs.get(k);
            String h = "io_" + outChannels.get(k);
            if (out.readyHigh) {
                driveSinks(h + "_ready", 0, null, null, -1, true, null, -1);
                continue;
            }
            if (out.pValidArray != null)
                continue; //a kernel unit reads it: stitchKernelInput
            if (out.bitSize > 0 && !out.bitSizeWasZero) {
                String name = lsq.name + "_dout_" + k;
                topPort(top, name, out.bitSize, EDIFDirection.OUTPUT);
                for (int i = 0; i < out.bitSize; i++)
                    fromDriver(h + "_bits", i, null, null, -1, name, out.bitSize > 1 ? i : -1);
            }
            String v = lsq.name + "_valid_out_" + k;
            topPort(top, v, 1, EDIFDirection.OUTPUT);
            fromDriver(h + "_valid", 0, null, null, -1, v, -1);
            String r = lsq.name + "_ready_in_" + k;
            topPort(top, r, 1, EDIFDirection.INPUT);
            driveSinks(h + "_ready", 0, null, null, -1, null, r, -1);
        }

        for (HwMlirParser.Port p : plain) {
            int w = Integer.parseInt(p.type.substring(1));
            String name = lsq.name + "_" + p.name + "_Port";
            String h = "io_" + p.name;
            topPort(top, name, w, p.isInput ? EDIFDirection.INPUT : EDIFDirection.OUTPUT);
            for (int i = 0; i < w; i++) {
                if (p.isInput)
                    driveSinks(h, i, null, null, -1, null, name, w > 1 ? i : -1);
                else
                    fromDriver(h, i, null, null, -1, name, w > 1 ? i : -1);
            }
        }
    }

    //A kernel unit's input that reads an LSQ output
    public static void stitchKernelInput(Input in) {
        Output src = in.validArray;
        LsqAssembler a = of(src.node);
        String h = "io_" + a.outChannels.get(src.index);
        ModuleInst ki = in.node.moduleInst;
        for (int i = 0; i < in.bitSize && !in.bitSizeWasZero; i++) {
            Output d = in.dataOutArray[i];
            int kb = in.bitSize > 1 ? i : -1;
            if (d == Output.GND || d == Output.VCC)
                Input.tieToStatic(ki, ModulePorts.DataIn + in.index, kb, d == Output.VCC);
            else if (d != null)
                a.fromDriver(h + "_bits", in.dataOutBit != null ? in.dataOutBit[i] : i, ki, ModulePorts.DataIn + in.index, kb, null, -1);
        }
        a.fromDriver(h + "_valid", 0, ki, ModulePorts.ValidIn + in.index, -1, null, -1);
        if (in.nReadyArray != null)
            for (LsqRequirement.End e : a.req.sinks(h + "_ready")) {
                ModuleInst si = a.inst(e.block);
                Input.connectBit(ki, ModulePorts.ReadyOut + in.index, -1, si, e.port, bit(si, e.port, 0));
            }
    }

    //Whether an input of a kernel unit reads an LSQ
    public static boolean readsLsq(Input in) {
        return in.validArray != null && in.validArray.node != null && in.validArray.node.lsq;
    }

    // ---- the group allocator's tables ----

    //After flattening: each table LUT of a group allocator gets this kernel's INIT
    public static void patchTables(Design design) {
        EDIFNetlist netlist = design.getNetlist();
        for (LsqAssembler a : assemblies.values()) {
            Node ga = a.sub.get("ga");
            if (ga == null)
                continue;
            Map<String, EDIFHierCellInst> cells = new HashMap<>();
            for (EDIFHierCellInst c : netlist.getAllLeafDescendants(ga.name)) {
                String n = c.getFullHierarchicalInstName();
                cells.put(n.substring(n.lastIndexOf('/') + 1), c);
            }
            int patched = 0;
            for (Map.Entry<String, String> e : a.req.gaInits.entrySet()) {
                EDIFHierCellInst c = cells.get(e.getKey());
                if (c == null)
                    throw new IllegalStateException("LSQ " + a.lsq.name + ": table LUT " + e.getKey() + " not in " + ga.name);
                c.getInst().addProperty("INIT", "64'h" + e.getValue());
                patched++;
            }
            System.out.println("LSQ " + a.lsq.name + ": " + patched + " table LUTs patched");
        }
    }

    //Sites of every LSQ sub-unit: their nets are routed first
    public static Set<String> siteNames() {
        Set<String> out = new HashSet<>();
        for (LsqAssembler a : assemblies.values())
            for (Node n : a.sub.values())
                for (SiteInst si : n.moduleInst.getSiteInsts())
                    out.add(si.getSiteName());
        return out;
    }

    //" (top-left anchors in rows a-b, columns c-d)", for placement failures
    static String span(java.util.Collection<String> locs)
    {
        int a = Integer.MAX_VALUE, b = -1, c = Integer.MAX_VALUE, d = -1;
        for (String l : locs) {
            int[] p = parseLoc(l);
            a = Math.min(a, p[0]); b = Math.max(b, p[0]);
            c = Math.min(c, p[1]); d = Math.max(d, p[1]);
        }
        return locs.isEmpty() ? "" : " (top-left anchors in rows " + a + "-" + b + ", columns " + c + "-" + d + ")";
    }
}
