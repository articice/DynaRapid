/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
* For any questions, please contact Andrea Guerrieri <andrea.guerrieri@ieee.org> (C) 2024
*/

package ch.agsl.dynarapid.entry;

import ch.agsl.dynarapid.GenerateDesign;
import ch.agsl.dynarapid.parser.LocationParser;
import ch.agsl.dynarapid.strings.StringUtils;

import com.xilinx.rapidwright.design.Design;
import com.xilinx.rapidwright.design.DesignTools;
import com.xilinx.rapidwright.edif.EDIFTools;
import ch.agsl.dynarapid.modules.EncryptedCores;
import com.xilinx.rapidwright.rwroute.PartialRouter;
import com.xilinx.rapidwright.rwroute.RWRoute;

import java.nio.file.Path;

/** 
 * This routes the designs simply either fully or partially based on the arguments passed
 */
public class GenerateRouted {

    //This routes the design partially with the unconnected inputs being grounded
    // public static boolean routeDesignPartially(Design design, Map<String, Node> nodes, String finalLocation)
    // {
    //     StringUtils.printIntro("Started partial routing using RWRouter");
    //     design.getNetlist().resetParentNetMap();
    //     DesignTools.makePhysNetNamesConsistent(design);

    //     DesignTools.createMissingSitePinInsts(design);
    //     for (Map.Entry<String,Node> entry : nodes.entrySet()) 
    //     {
    //         Node node = entry.getValue();
    //         if(node.isUnconnected)
    //         {
    //             ModuleInst inst = node.moduleInst;
    //             inst.tieOffUnconnectedInputs(true);
    //         }
    //     }

    //     boolean softPreserve = true;
    //     design = PartialRouter.routeDesignPartialNonTimingDriven(design, null, softPreserve);
    //     design.writeCheckpoint(finalLocation);
    //     return true;
    // }
    
    //This helps route the design partially and puts the design in the final location
    public static boolean routeDesignPartially(Design design, Path finalLocation)
    {
        StringUtils.printIntro("Started partial routing using RWRouter");
        design.flattenDesign();
        EDIFTools.uniqueifyNetlist(design);
        boolean softPreserve = true;
        com.xilinx.rapidwright.edif.EDIFNetlist unrouted = design.getNetlist();
        design = PartialRouter.routeDesignPartialNonTimingDriven(design, null, softPreserve);
        EncryptedCores.add(design.getNetlist(), unrouted);
        EncryptedCores.writeCheckpoint(design, finalLocation.toString());
        return true;
    }

    // public static boolean routeDesignFully(Design design, Map<String, Node> nodes, String finalLocation)
    // {
    //     StringUtils.printIntro("Started full routing using RWRouter");
    //     design.getNetlist().resetParentNetMap();
    //     DesignTools.makePhysNetNamesConsistent(design);

    //     DesignTools.createMissingSitePinInsts(design);
    //     for (Map.Entry<String,Node> entry : nodes.entrySet()) 
    //     {
    //         Node node = entry.getValue();
    //         if(node.isUnconnected)
    //         {
    //             ModuleInst inst = node.moduleInst;
    //             inst.tieOffUnconnectedInputs(true);
    //         }
    //     }

    //     design = RWRoute.routeDesignFullNonTimingDriven(design);
    //     design.writeCheckpoint(finalLocation);
    //     return true;
    // }

    //Thsi routes the design and puts it in teh given final location
    //NOTE: The final location must have the entire loccation including the name
    public static boolean routeDesignFully(Design design, Path finalLocation)
    {
        StringUtils.printIntro("Started full routing using RWRouter");
        design.getNetlist().resetParentNetMap();
        DesignTools.makePhysNetNamesConsistent(design);
        com.xilinx.rapidwright.edif.EDIFNetlist unrouted = design.getNetlist();
        design = RWRoute.routeDesignFullNonTimingDriven(design);
        EncryptedCores.add(design.getNetlist(), unrouted);
        EncryptedCores.writeCheckpoint(design, finalLocation.toString());
        return true;
    }

    /*
     * A design with LSQs assembled from sub-units (lsq/LsqAssembler): after flattening, the group
     * allocators' tables get the kernel's INITs; then all unrouted signal pins (the LSQs' nets
     * between sub-units and to the kernel, and the kernel's stitched nets) are routed together,
     * timing-driven (-Ddynarapid.lsqTiming=false: not), and what's left (static nets) after them.
     * Together, because RWRoute reserves only the sinks of the nets it routes: an LSQ net routed
     * alone bounced through a kernel buffer's input pin (INT BOUNCE node) and the next pass failed.
     */
    public static boolean routeDesignWithLsqs(Design design, Path finalLocation)
    {
        StringUtils.printIntro("Routing a design with LSQs: signal nets first");
        java.util.Set<String> lsqSites = ch.agsl.dynarapid.lsq.LsqAssembler.siteNames();
        String netlistDump = System.getProperty("dynarapid.lsqNetlistDump");
        if (netlistDump != null)
            design.getNetlist().exportEDIF(netlistDump);
        design.getNetlist().resetParentNetMap();
        design.flattenDesign();
        EDIFTools.uniqueifyNetlist(design);
        ch.agsl.dynarapid.lsq.LsqAssembler.patchTables(design);
        DesignTools.makePhysNetNamesConsistent(design);
        String dump = System.getProperty("dynarapid.lsqDump");
        if (dump != null)
        {
            design.writeCheckpoint(dump);
            System.out.println("LSQ: pre-route checkpoint " + dump);
        }
        com.xilinx.rapidwright.edif.EDIFNetlist unrouted = design.getNetlist();
        //placed modules don't mark their pins routed (PartialRouter would rip up their routes), and
        //stitched nets have no site pins yet
        DesignTools.createMissingSitePinInsts(design);
        DesignTools.updatePinsIsRouted(design);

        java.util.List<com.xilinx.rapidwright.design.SitePinInst> pins = new java.util.ArrayList<>();
        int lsqPins = 0;
        for (com.xilinx.rapidwright.design.SitePinInst p : PartialRouter.getUnroutedPins(design))
        {
            com.xilinx.rapidwright.design.Net n = p.getNet();
            if (n == null || n.isClockNet() || n.isStaticNet())
                continue;
            pins.add(p);
            for (com.xilinx.rapidwright.design.SitePinInst q : n.getPins())
                if (lsqSites.contains(q.getSiteInst().getSiteName())) { lsqPins++; break; }
        }
        System.out.println("Signal nets: " + pins.size() + " unrouted pins (" + lsqPins + " on LSQ nets), routed first");
        boolean timing = !"false".equals(System.getProperty("dynarapid.lsqTiming"));
        design = timing ? PartialRouter.routeDesignPartialTimingDriven(design, pins, false)
                        : PartialRouter.routeDesignPartialNonTimingDriven(design, pins, false);
        design = PartialRouter.routeDesignPartialNonTimingDriven(design, null, false);
        DesignTools.updatePinsIsRouted(design);
        int left = PartialRouter.getUnroutedPins(design).size();
        System.out.println("Unrouted pins left: " + left);
        EncryptedCores.add(design.getNetlist(), unrouted);
        EncryptedCores.writeCheckpoint(design, finalLocation.toString());
        return true;
    }

    public static void main(String args[])
    {
        if((StringUtils.findInArray("-f", args) ==  -1))
        {
            System.out.println("<usage>: java GenerateRouted [-f] [-partial]");
            System.out.println("-f <arg> - Location of the dcp file which needs to be routed");
            System.out.println("-partial - This routes the design partially and if not given this flag then the design routes the design fully");
            return;
        }

        String dcpLoc = args[StringUtils.findInArray("-f", args) + 1];
        Path finalLoc = GenerateDesign.getDefaultOutputDCPPath(StringUtils.getGraphName(dcpLoc));
        Design design = Design.readCheckpoint(dcpLoc);
        boolean status = false;

        if(StringUtils.findInArray("-partial", args) ==  -1)
            status = routeDesignFully(design, finalLoc);

        else    
            status = routeDesignPartially(design, finalLoc);

        if(status)
            System.out.println("Completed Routing Design. You can find design in " + LocationParser.designs + " folder");

        else
            System.out.println("Could not route design");
    }
}
