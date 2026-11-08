package ch.agsl.dynarapid.entry;

import ch.agsl.dynarapid.GenerateDesign;
import ch.agsl.dynarapid.modules.Component;
import ch.agsl.dynarapid.modules.Pblock;
import ch.agsl.dynarapid.parser.LocationParser;
import ch.agsl.dynarapid.strings.StringUtils;

import java.io.File;

/**
 * Tests: one shape's pin exposure exactly as the library build does it (Circular harness, exposed
 * place and route, repair: Pblock stage 1), from a unit's synthesized checkpoint, with every file
 * written under a scratch root (LocationParser.redirectForTest).
 *
 * usage: ExposeShape -part <part> -m <unit> -shape <i> <j> <rows> <cols> -synth <dir> -root <dir>
 *   -synth  directory with <unit>_synth.dcp, <unit>_synth_0_metadata.txt and <unit>.util
 * Prints the final shape's checkpoint on success ("SHAPE <path>"); exit 1 when the shape fails.
 */
public class ExposeShape {

    public static void main(String[] args) {
        int m = StringUtils.findInArray("-m", args), sh = StringUtils.findInArray("-shape", args);
        int sy = StringUtils.findInArray("-synth", args), ro = StringUtils.findInArray("-root", args);
        if (m == -1 || sh == -1 || sy == -1 || ro == -1) {
            System.out.println("usage: ExposeShape -part <part> -m <unit> -shape <i> <j> <rows> <cols> -synth <dir> -root <dir>");
            System.exit(2);
        }
        if (!GenerateDesign.setPartFromArgs(args) || !Start.start())
            System.exit(2);
        String unit = args[m + 1];
        int i = Integer.parseInt(args[sh + 1]), j = Integer.parseInt(args[sh + 2]);
        int r = Integer.parseInt(args[sh + 3]), c = Integer.parseInt(args[sh + 4]);
        LocationParser.redirectForTest(args[ro + 1], args[sy + 1]);
        if (!new File(LocationParser.vhdlSynthDCPs + unit + "_synth.dcp").exists()) {
            System.out.println("ERROR: no " + unit + "_synth.dcp in " + LocationParser.vhdlSynthDCPs);
            System.exit(2);
        }

        Component component = new Component(unit, false);
        Pblock pblock = new Pblock(component, i, j, r, c, 1, false, false);
        if (pblock.currStatus != 7) {
            System.out.println("ERROR: shape " + pblock.pblockName + " failed, status " + pblock.currStatus);
            System.exit(1);
        }
        System.out.println("SHAPE " + LocationParser.libraryPath(unit).resolve(pblock.pblockName + "_placedRouted.dcp"));
    }
}
