/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.modules;

import com.xilinx.rapidwright.edif.EDIFNetlist;
import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/*
 * Encrypted IP cores (e.g. Xilinx floating_point) in library units. write_edif leaves an encrypted
 * cell empty, so RapidWright sees it as a black box; with -security_mode multifile Vivado writes the
 * cell in clear and each encrypted cell as <cell>.edn next to the EDIF. RapidWright keeps the list
 * (EDIFNetlist.getEncryptedCells, every .edn in the EDIF's directory when it reads one), and Vivado
 * must read_edif those files before it can open a DCP RapidWright wrote.
 *
 * Synthesized units share one directory per part, so a unit's .edn go in <unit>_edn/ beside its
 * _synth.dcp (the shared directory has none, and RapidWright finds none there); placed and routed
 * units have a directory per unit, so their .edn sit next to the EDIF.
 */
public class EncryptedCores {

    //Directory of the .edn of the unit synthesized as <x>_synth.dcp
    public static String synthDirectory(String synthDcp) {
        return synthDcp.replaceAll("_synth\\.dcp$", "_edn");
    }

    //.edn files of the unit synthesized as synthDcp (none if it has no encrypted cores)
    public static List<String> ofSynth(String synthDcp) {
        String[] files = new File(synthDirectory(synthDcp)).list((d, n) -> n.toLowerCase().endsWith(".edn"));
        List<String> paths = new ArrayList<>();
        if (files != null) {
            Arrays.sort(files);
            for (String f : files)
                paths.add(synthDirectory(synthDcp) + File.separator + f);
        }
        return paths;
    }

    /*
     * Adds .edn files to a netlist's list, once each. A .edn defines the cell it is named after, so
     * two different files for one cell name (two configurations of a core, from two units) can't be
     * read into one Vivado design: that is an error until such cores get unique names.
     */
    public static void add(EDIFNetlist netlist, List<String> ednFiles) {
        List<String> added = new ArrayList<>();
        for (String edn : ednFiles) {
            String name = new File(edn).getName();
            boolean present = false;
            for (String have : netlist.getEncryptedCells()) {
                if (!new File(have).getName().equals(name))
                    continue;
                if (!sameContents(have, edn))
                    throw new IllegalStateException("encrypted cell " + name + " has two definitions: " + have + " and " + edn);
                present = true;
            }
            if (!present && !added.contains(edn))
                added.add(edn);
        }
        if (!added.isEmpty())
            netlist.addEncryptedCells(added);
    }

    public static void add(EDIFNetlist to, EDIFNetlist from) {
        add(to, from.getEncryptedCells());
    }

    static boolean sameContents(String a, String b) {
        try {
            return a.equals(b) || Arrays.equals(java.nio.file.Files.readAllBytes(new File(a).toPath()),
                                                java.nio.file.Files.readAllBytes(new File(b).toPath()));
        } catch (java.io.IOException e) {
            throw new java.io.UncheckedIOException(e);
        }
    }

    /*
     * Writes a DCP with RapidWright and, if the netlist has encrypted cells, <dcp>_load.tcl next to
     * it: the Tcl that opens it in Vivado (RapidWright writes its own _load.tcl in the working
     * directory, which is removed).
     */
    public static void writeCheckpoint(com.xilinx.rapidwright.design.Design design, String dcp) {
        design.writeCheckpoint(dcp);
        if (!has(design.getNetlist()))
            return;
        String name = new File(dcp).getName().replaceAll("\\.dcp$", "");
        new File(name + "_load.tcl").delete();
        try (java.io.FileWriter w = new java.io.FileWriter(loadTcl(dcp))) {
            w.write(openCheckpoint(new File(dcp).getAbsolutePath(), design.getNetlist(), design.getPartName()));
        } catch (java.io.IOException e) {
            throw new java.io.UncheckedIOException(e);
        }
    }

    public static String loadTcl(String dcp) {
        return dcp.replaceAll("\\.dcp$", "") + "_load.tcl";
    }

    public static boolean has(EDIFNetlist netlist) {
        return netlist.getEncryptedCells() != null && !netlist.getEncryptedCells().isEmpty();
    }

    //Tcl that opens a DCP written by RapidWright for this netlist in Vivado
    public static String openCheckpoint(String dcp, EDIFNetlist netlist, String part) {
        if (!has(netlist))
            return "open_checkpoint " + dcp + "\n";
        StringBuilder s = new StringBuilder();
        for (String edn : netlist.getEncryptedCells())
            s.append("read_edif ").append(edn).append("\n");
        s.append("read_checkpoint ").append(dcp).append("\n");
        s.append("set_property top ").append(netlist.getName()).append(" [current_fileset]\n");
        s.append("link_design -part ").append(part).append("\n");
        return s.toString();
    }

    //Options of write_edif for a design that may hold encrypted cores
    public static String writeEdifOptions(boolean encrypted) {
        return encrypted ? "-security_mode multifile " : "";
    }
}
