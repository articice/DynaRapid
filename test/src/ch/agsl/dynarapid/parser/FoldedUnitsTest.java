/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.parser;

import static ch.agsl.dynarapid.parser.FoldedUnits.ONE;
import static ch.agsl.dynarapid.parser.FoldedUnits.ZERO;
import static org.junit.jupiter.api.Assertions.*;

import ch.agsl.dynarapid.parser.FoldedUnits.Wiring;
import java.util.*;
import org.junit.jupiter.api.Test;

//The fold rules on their own: every expected wiring follows the unit's RTL (see FoldedUnits)
public class FoldedUnitsTest {

    static final Wiring X = Wiring.identity("%x", 8);

    //always valid with data value, as source -> constant gives
    static Wiring always(String value) {
        return new Wiring(null, FoldedUnits.literal(value, value.length()));
    }

    static Map<String, Wiring> fold(String unit, String parameters, Map<String, Wiring> in, String out, int width) {
        return FoldedUnits.fold(unit, parameters, in, Map.of(out, width), v -> v.equals("%kernelPort"));
    }

    static Wiring binary(String unit, Wiring lhs, Wiring rhs) {
        Map<String, Wiring> r = fold(unit, "", Map.of("lhs", lhs, "rhs", rhs), "result", 8);
        return r == null ? null : r.get("result");
    }

    @Test
    public void sourceIsAlwaysValid() {
        Wiring w = fold("handshake.source", "", Map.of(), "outs", 0).get("outs");
        assertNull(w.handshake);
        assertEquals(0, w.bits.length);
    }

    @Test
    public void constantTakesItsTriggersHandshake() {
        Wiring w = fold("handshake.constant", "DATA_WIDTH = 5 : ui32, VALUE = \"00110\"",
                Map.of("ctrl", Wiring.identity("%fork0.outs_3", 0)), "outs", 5).get("outs");
        assertEquals("%fork0.outs_3", w.handshake);
        assertArrayEquals(new int[] {ZERO, ONE, ONE, ZERO, ZERO}, w.bits); //LSB first
    }

    @Test
    public void constantMayBeTriggeredByAKernelPort() {
        Wiring w = fold("handshake.constant", "VALUE = \"1\"", Map.of("ctrl", Wiring.identity("%kernelPort", 0)), "outs", 1).get("outs");
        assertEquals("%kernelPort", w.handshake);
    }

    @Test
    public void constantValueMustMatchItsWidth() {
        assertThrows(IllegalArgumentException.class, () -> fold("handshake.constant", "VALUE = \"011\"",
                Map.of("ctrl", Wiring.identity("%c", 0)), "outs", 4));
    }

    @Test
    public void sinkFoldsWithoutOutputs() {
        assertEquals(Map.of(), fold("handshake.sink", "", Map.of("ins", X), "unused", 0));
    }

    @Test
    public void casts() {
        Wiring y = Wiring.identity("%y", 4);
        assertArrayEquals(new int[] {0, 1, 2, 3, ZERO, ZERO}, fold("handshake.extui", "", Map.of("ins", y), "outs", 6).get("outs").bits);
        assertArrayEquals(new int[] {0, 1, 2, 3, 3, 3}, fold("handshake.extsi", "", Map.of("ins", y), "outs", 6).get("outs").bits);
        Wiring t = fold("handshake.trunci", "", Map.of("ins", y), "outs", 2).get("outs");
        assertArrayEquals(new int[] {0, 1}, t.bits);
        assertEquals("%y", t.handshake);
        //a cast of a constant stays constant
        Wiring c = new Wiring("%t", new int[] {ONE, ZERO});
        assertArrayEquals(new int[] {ONE, ZERO, ZERO}, fold("handshake.extui", "", Map.of("ins", c), "outs", 3).get("outs").bits);
    }

    @Test
    public void unitsReadingAKernelPortStay() {
        Wiring port = Wiring.identity("%kernelPort", 8);
        assertNull(fold("handshake.extui", "", Map.of("ins", port), "outs", 9));
        assertNull(fold("handshake.sink", "", Map.of("ins", port), "unused", 0));
        assertNull(binary("handshake.shli", port, always("00000001")));
    }

    @Test
    public void shiftsByAConstant() {
        assertArrayEquals(new int[] {ZERO, ZERO, ZERO, 0, 1, 2, 3, 4}, binary("handshake.shli", X, always("00000011")).bits);
        assertArrayEquals(new int[] {3, 4, 5, 6, 7, ZERO, ZERO, ZERO}, binary("handshake.shrui", X, always("00000011")).bits);
        assertArrayEquals(new int[] {3, 4, 5, 6, 7, 7, 7, 7}, binary("handshake.shrsi", X, always("00000011")).bits);
        assertEquals("%x", binary("handshake.shli", X, always("00000011")).handshake);
    }

    @Test
    public void shiftsOfTheFullWidthAndMore() {
        int[] zeros = new int[8], signs = new int[8];
        Arrays.fill(zeros, ZERO);
        Arrays.fill(signs, 7);
        assertArrayEquals(zeros, binary("handshake.shli", X, always("00001000")).bits);
        assertArrayEquals(zeros, binary("handshake.shrui", X, always("01111111")).bits);
        assertArrayEquals(signs, binary("handshake.shrsi", X, always("00010000")).bits);
    }

    @Test
    public void shiftAmountsWithTheTopBitSetStay() {
        //the VHDL units ignore that bit, the Verilog ones don't
        assertNull(binary("handshake.shli", X, always("10000000")));
        assertNull(binary("handshake.shrsi", X, always("10000001")));
    }

    @Test
    public void shiftOfAConstantStays() {
        //the shift amount is the variable: a barrel shifter
        assertNull(binary("handshake.shli", always("00000011"), X));
    }

    @Test
    public void masksWithAConstant() {
        assertArrayEquals(new int[] {0, ZERO, 2, ZERO, ZERO, ZERO, ZERO, 7}, binary("handshake.andi", X, always("10000101")).bits);
        assertArrayEquals(new int[] {ONE, 1, ONE, 3, 4, 5, 6, ONE}, binary("handshake.ori", always("10000101"), X).bits);
    }

    @Test
    public void opsOfTwoConstants() {
        Wiring w = binary("handshake.andi", always("11110000"), always("10101010"));
        assertNull(w.handshake);
        assertArrayEquals(FoldedUnits.literal("10100000", 8), w.bits);
    }

    @Test
    public void constantBehindAControlTokenStays() {
        //the op's join waits for that token: it isn't wiring
        Wiring c = new Wiring("%fork0.outs_1", FoldedUnits.literal("00000011", 8));
        assertNull(binary("handshake.shli", X, c));
        assertNull(binary("handshake.andi", c, X));
    }
}
