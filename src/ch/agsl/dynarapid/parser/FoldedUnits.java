/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.parser;

import java.util.*;

/*
 * Units folded into the wiring between their neighbours when reading hw.mlir, as synthesis would do
 * across unit boundaries in a whole-design flow. DynaRapid implements each unit on its own, so a
 * constant would otherwise be a block (with no cells: "The design is empty"), and a shift by a
 * constant a barrel shifter whose shift amount is only known at the pins.
 *
 * A folded channel is a Wiring: the valid/ready of one channel of a real unit (or of a kernel
 * port), or always valid with its ready unused (a source), plus each data bit as a bit of that same
 * channel or a constant. What a unit folds to follows its RTL (data/vhdl and data/verilog of
 * dynamatic-next, which agree on it):
 * - source: always valid.
 * - constant: the valid/ready of its ctrl channel (ctrl_valid -> outs_valid, outs_ready ->
 *   ctrl_ready), data VALUE.
 * - sink: ins_ready = 1 (Folds.readyHigh); the channel's valid and data go nowhere.
 * - extui/extsi/trunci: valid/ready passed through, data bits selected (zero/sign fill). trunci's
 *   ready is a plain wire like the extensions' since dynamatic-next warp-next 2026-10-26.
 * - shli/shrui/shrsi by, and andi/ori with, an operand that is always valid with constant data: the
 *   join of the two operands is then the other operand's valid/ready, and the data bits are that
 *   operand's bits or constants. The shift amount must have its top bit clear: the VHDL units ignore
 *   it and the Verilog ones don't (shift_left(lhs, rhs(N-2 downto 0)) vs lhs << rhs); below that both
 *   give zero (sign) fill for shifts of the full width and more.
 * An operand driven by a constant behind a control channel is not folded into the op: the op still
 * waits for that control token (its join is real), so the unit stays and only its constant input
 * bits become tie-offs. Units reading a kernel port stay too (except a constant triggered by one),
 * so kernel ports keep mapping to whole channels of real units.
 */
public class FoldedUnits {

    public static final int ZERO = -1, ONE = -2;

    public static class Wiring {
        //value (SSA name in hw.mlir) whose valid/ready this channel uses; null: always valid
        public final String handshake;
        //per data bit, LSB first: a bit index of the handshake value's data, ZERO or ONE
        public final int[] bits;

        public Wiring(String handshake, int[] bits) {
            this.handshake = handshake;
            this.bits = bits;
            if (handshake == null)
                for (int b : bits)
                    if (b >= 0)
                        throw new IllegalArgumentException("always-valid channel with non-constant data");
        }

        public static Wiring identity(String value, int width) {
            int[] bits = new int[width];
            for (int i = 0; i < width; i++)
                bits[i] = i;
            return new Wiring(value, bits);
        }

        public boolean isIdentity(String value) {
            if (!value.equals(handshake))
                return false;
            for (int i = 0; i < bits.length; i++)
                if (bits[i] != i)
                    return false;
            return true;
        }

        //always valid, constant data: what the other operand of an op can be folded with
        public boolean isAlwaysConstant() {
            return handshake == null;
        }

        public boolean allConstant() {
            for (int b : bits)
                if (b >= 0)
                    return false;
            return true;
        }

        @Override
        public String toString() {
            StringBuilder s = new StringBuilder(handshake == null ? "always" : handshake).append(" [");
            for (int i = bits.length - 1; i >= 0; i--)
                s.append(bits[i] == ZERO ? "0" : bits[i] == ONE ? "1" : "b" + bits[i]).append(i > 0 ? " " : "");
            return s.append("]").toString();
        }
    }

    public static final Set<String> unitNames = Set.of("handshake.source", "handshake.constant", "handshake.sink",
            "handshake.extui", "handshake.extsi", "handshake.trunci",
            "handshake.shli", "handshake.shrui", "handshake.shrsi", "handshake.andi", "handshake.ori");

    public static boolean isCandidate(String unitName) {
        return unitNames.contains(unitName);
    }

    /*
     * The wiring of each output of a unit (by port name), or null if the unit isn't folded.
     * in: wiring of each channel input (by port name); outWidths: data width of each output;
     * parameters: the extern module's hw.parameters; kernelInput: whether a value is a kernel port.
     * A folded sink has no outputs: it returns an empty map, and the caller ties the ready of
     * in.get("ins").handshake high.
     */
    public static Map<String, Wiring> fold(String unitName, String parameters, Map<String, Wiring> in,
                                           Map<String, Integer> outWidths, java.util.function.Predicate<String> kernelInput) {
        //only a constant may read a kernel port (its data doesn't come from it)
        if (!unitName.equals("handshake.constant"))
            for (Wiring w : in.values())
                if (w.handshake != null && kernelInput.test(w.handshake))
                    return null;

        switch (unitName) {
        case "handshake.source":
            return Map.of("outs", new Wiring(null, new int[0]));
        case "handshake.constant": {
            Wiring ctrl = in.get("ctrl");
            if (ctrl.bits.length != 0)
                throw new IllegalArgumentException("constant triggered by a data channel");
            return Map.of("outs", new Wiring(ctrl.handshake, literal(parameterString(parameters, "VALUE"), outWidths.get("outs"))));
        }
        case "handshake.sink":
            return Map.of();
        case "handshake.extui":
        case "handshake.extsi":
        case "handshake.trunci": {
            Wiring x = in.get("ins");
            int w = outWidths.get("outs"), wi = x.bits.length;
            int[] bits = new int[w];
            for (int i = 0; i < w; i++)
                bits[i] = i < wi ? x.bits[i] : unitName.equals("handshake.extsi") ? x.bits[wi - 1] : ZERO;
            return Map.of("outs", new Wiring(x.handshake, bits));
        }
        default:
            return foldBinary(unitName, in.get("lhs"), in.get("rhs"), outWidths.get("result"));
        }
    }

    static Map<String, Wiring> foldBinary(String unitName, Wiring lhs, Wiring rhs, int w) {
        if (lhs.bits.length != w || rhs.bits.length != w)
            throw new IllegalArgumentException(unitName + ": operand widths differ from the result's");
        boolean shift = unitName.startsWith("handshake.sh");
        Wiring x, c;
        if (rhs.isAlwaysConstant()) {
            x = lhs;
            c = rhs;
        } else if (!shift && lhs.isAlwaysConstant()) {
            x = rhs;
            c = lhs;
        } else
            return null;

        int[] bits = new int[w];
        if (shift) {
            if (c.bits[w - 1] == ONE)
                return null; //VHDL and Verilog units disagree (see above)
            long s = 0; //at least w if a bit from 32 up is set
            for (int i = 0; i < w - 1; i++)
                if (c.bits[i] == ONE)
                    s = i >= 32 ? 1L << 40 : s | 1L << i;
            for (int i = 0; i < w; i++) {
                switch (unitName) {
                case "handshake.shli":
                    bits[i] = i >= s ? x.bits[(int) (i - s)] : ZERO;
                    break;
                case "handshake.shrui":
                    bits[i] = i + s < w ? x.bits[(int) (i + s)] : ZERO;
                    break;
                default: //shrsi
                    bits[i] = i + s < w ? x.bits[(int) (i + s)] : x.bits[w - 1];
                }
            }
        } else
            for (int i = 0; i < w; i++)
                bits[i] = unitName.equals("handshake.andi") ? (c.bits[i] == ONE ? x.bits[i] : ZERO)
                                                            : (c.bits[i] == ONE ? ONE : x.bits[i]);
        return Map.of("result", new Wiring(x.handshake, bits));
    }

    //Bits of a constant's VALUE (MSB first, as the RTL generator takes it), LSB first
    static int[] literal(String value, int width) {
        if (value.length() != width || !value.matches("[01]+"))
            throw new IllegalArgumentException("constant VALUE \"" + value + "\" is not " + width + " bits");
        int[] bits = new int[width];
        for (int i = 0; i < width; i++)
            bits[i] = value.charAt(width - 1 - i) == '1' ? ONE : ZERO;
        return bits;
    }

    //A string parameter of hw.parameters, e.g. VALUE = "00001"
    static String parameterString(String parameters, String key) {
        for (String item : HwMlirParser.splitTopLevel(parameters)) {
            item = item.trim();
            if (item.startsWith(key + " = \"") && item.endsWith("\""))
                return item.substring(key.length() + 4, item.length() - 1);
        }
        throw new IllegalArgumentException("no string parameter " + key + " in {" + parameters + "}");
    }
}
