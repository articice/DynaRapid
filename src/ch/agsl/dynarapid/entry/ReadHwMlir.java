/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/

package ch.agsl.dynarapid.entry;

import ch.agsl.dynarapid.modules.*;
import ch.agsl.dynarapid.parser.*;

import java.util.*;

//Reads a new-Dynamatic hw.mlir and writes the library variants it needs and its port map:
//  ReadHwMlir <hw.mlir> <output prefix>   ->  <prefix>_variants.tsv, <prefix>_ports.tsv
public class ReadHwMlir {
    public static void main(String args[]) throws Exception
    {
        if(args.length != 2)
        {
            System.out.println("usage: ReadHwMlir <hw.mlir> <output prefix>");
            System.exit(2);
        }

        Map<String, Node> nodes = HwMlirParser.parser(args[0]);
        if(nodes == null)
            System.exit(1);

        int connected = 0, open = 0;
        for(Node n : nodes.values())
        {
            for(Input in : n.inputs)
                if(in.validArray == null) open++; else connected++;
            for(Output out : n.outputs)
                if(out.pValidArray == null) open++;
        }
        System.out.println("channels: " + connected + " connected, " + open + " open ends (kernel ports)");

        HwMlirParser.writeTables(nodes, args[1]);
        System.out.println("wrote " + args[1] + "_variants.tsv and " + args[1] + "_ports.tsv");
    }
}
