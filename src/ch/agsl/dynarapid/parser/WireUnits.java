/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.parser;

import com.xilinx.rapidwright.edif.EDIFCell;
import com.xilinx.rapidwright.edif.EDIFCellInst;
import com.xilinx.rapidwright.edif.EDIFHierCellInst;
import com.xilinx.rapidwright.edif.EDIFHierNet;
import com.xilinx.rapidwright.edif.EDIFNet;
import com.xilinx.rapidwright.edif.EDIFNetlist;
import com.xilinx.rapidwright.edif.EDIFPort;
import com.xilinx.rapidwright.edif.EDIFPortInst;
import com.xilinx.rapidwright.edif.EDIFTools;

import java.io.File;
import java.util.*;

/*
 * Wire-only units: library variants whose synthesized netlist has no cells, so every output
 * channel is one input channel passed straight through (e.g. new Dynamatic's handshake.store,
 * which only forwards address and data to the memory controller). They cannot have a pblock
 * (Vivado: "The design is empty"), so the parser leaves them out of the node graph and connects
 * the unit driving each input straight to the unit reading the matching output.
 *
 * The channel mapping comes from the variant's synthesized EDIF (vhdlSynthDCPs/<part>/<v>_synth.edf),
 * in the library wrapper's port names: output channel k (dataOutArray_k, validArray_k,
 * nReadyArray_k) must be input channel j (dataInArray_j bit for bit, pValidArray_j, readyArray_j),
 * and the mapping must be one to one. A cell-free netlist that is not such a pass-through (a
 * constant output, swapped bits, a fan-out) is an error, since the unit can neither be placed nor
 * bypassed.
 */
public class WireUnits {

    //variant -> output channel -> input channel; absent value (null) = not a wire unit
    static final Map<String, int[]> cache = new HashMap<>();

    //Output -> input channel map of a wire-only variant, or null for a variant with logic (or no
    //synthesized netlist yet, or no library location set up)
    public static int[] channelMap(String variant) {
        if (cache.containsKey(variant))
            return cache.get(variant);
        int[] map = null;
        if (LocationParser.vhdlSynthDCPs != null) {
            File edf = new File(LocationParser.vhdlSynthDCPs + variant + "_synth.edf");
            if (edf.exists())
                map = fromNetlist(variant, EDIFTools.readEdifFile(edf.getPath()));
        }
        cache.put(variant, map);
        return map;
    }

    static boolean hasCells(EDIFNetlist netlist) {
        for (EDIFCellInst c : netlist.getAllLeafCellInstances()) {
            String t = c.getCellType().getName();
            if (!t.equals("GND") && !t.equals("VCC"))
                return true;
        }
        return false;
    }

    static int[] fromNetlist(String variant, EDIFNetlist netlist) {
        if (hasCells(netlist))
            return null;

        //top-level port bits grouped by the physical net they sit on
        EDIFCell top = netlist.getTopCell();
        EDIFHierCellInst topInst = netlist.getTopHierCellInst();
        Map<String, Set<String>> netOf = new HashMap<>(); //port bit -> all port bits on its net
        Map<EDIFHierNet, Set<String>> groups = new HashMap<>();
        for (EDIFNet net : top.getNets()) {
            EDIFHierNet parent = netlist.getParentNet(new EDIFHierNet(topInst, net));
            Set<String> g = groups.computeIfAbsent(parent == null ? new EDIFHierNet(topInst, net) : parent, k -> new TreeSet<>());
            for (EDIFPortInst p : net.getPortInsts())
                if (p.isTopLevelPort())
                    g.add(p.getName());
        }
        for (Set<String> g : groups.values())
            for (String bit : g)
                netOf.put(bit, g);

        int nOut = countChannels(top, "validArray_"), nIn = countChannels(top, "pValidArray_");
        if (nIn != nOut)
            throw new IllegalArgumentException(variant + ": no logic but " + nIn + " input and " + nOut + " output channels");
        int[] map = new int[nOut];
        boolean[] used = new boolean[nIn];
        for (int k = 0; k < nOut; k++) {
            int j = onlyInput(variant, netOf, "validArray_" + k, "pValidArray_");
            if (used[j])
                throw new IllegalArgumentException(variant + ": input channel " + j + " drives two outputs");
            used[j] = true;
            map[k] = j;
            if (!netOf.getOrDefault("readyArray_" + j, Set.of()).contains("nReadyArray_" + k))
                throw new IllegalArgumentException(variant + ": readyArray_" + j + " is not nReadyArray_" + k);
            int w = width(top, "dataOutArray_" + k);
            if (w != width(top, "dataInArray_" + j))
                throw new IllegalArgumentException(variant + ": channel " + j + " -> " + k + " changes width");
            for (int b = 0; b < w; b++) {
                String o = bitName(top, "dataOutArray_" + k, b), i = bitName(top, "dataInArray_" + j, b);
                if (!netOf.getOrDefault(o, Set.of()).contains(i))
                    throw new IllegalArgumentException(variant + ": " + o + " is not " + i);
            }
        }
        System.out.println("Wire-only unit " + variant + ": output channels from inputs " + Arrays.toString(map));
        return map;
    }

    static int countChannels(EDIFCell top, String prefix) {
        int n = 0;
        while (port(top, prefix + n) != null)
            n++;
        return n;
    }

    static EDIFPort port(EDIFCell top, String name) {
        for (EDIFPort p : top.getPorts())
            if (p.getBusName().equals(name) || p.getName().equals(name))
                return p;
        return null;
    }

    //width of a top-level data port, 0 if absent (control channel)
    static int width(EDIFCell top, String name) {
        EDIFPort p = port(top, name);
        return p == null ? 0 : p.getWidth();
    }

    //name of one bit of a top-level port as EDIFPortInst.getName() prints it
    static String bitName(EDIFCell top, String name, int b) {
        return port(top, name).isBus() ? name + "[" + b + "]" : name;
    }

    static int onlyInput(String variant, Map<String, Set<String>> netOf, String bit, String inPrefix) {
        int found = -1;
        for (String other : netOf.getOrDefault(bit, Set.of()))
            if (other.startsWith(inPrefix)) {
                if (found != -1)
                    throw new IllegalArgumentException(variant + ": " + bit + " joins two inputs");
                found = Integer.parseInt(other.substring(inPrefix.length()));
            }
        if (found == -1)
            throw new IllegalArgumentException(variant + ": " + bit + " is not driven by an input channel");
        return found;
    }
}
