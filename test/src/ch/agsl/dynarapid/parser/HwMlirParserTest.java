/*
* DynaRapid
*
* This file is part of DynaRapid project
* Copyright: See COPYING file that comes with this distribution
*/
package ch.agsl.dynarapid.parser;

import static org.junit.jupiter.api.Assertions.*;

import ch.agsl.dynarapid.modules.*;
import java.util.*;
import org.junit.jupiter.api.Test;

//The node graph HwMlirParser builds from the fixtures in test/resources/hwmlir, with units folded
public class HwMlirParserTest {

    static Map<String, Node> parse(String fixture) {
        String path = System.getProperty("dynarapid.test.resources", "test/resources") + "/hwmlir/" + fixture;
        Map<String, Node> nodes = HwMlirParser.parser(path);
        assertNotNull(nodes, "could not parse " + path);
        return nodes;
    }

    //Driver of each data bit of an input: "<node>.<output>[<bit>]", "0" or "1"
    static List<String> bits(Input in) {
        List<String> bits = new ArrayList<>();
        for (int i = 0; i < in.bitSize; i++) {
            Output o = in.dataOutArray[i];
            if (o == Output.GND)
                bits.add("0");
            else if (o == Output.VCC)
                bits.add("1");
            else
                bits.add(o.node.name + "." + o.index + "[" + (in.dataOutBit == null ? i : in.dataOutBit[i]) + "]");
        }
        return bits;
    }

    @Test
    public void foldedUnitsAreNotNodes() {
        assertEquals(Set.of("fork0", "not0", "not1", "andi0", "addi0"), parse("fold.mlir").keySet());
    }

    @Test
    public void shiftByASourcedConstantIsWiring() {
        Input lhs = parse("fold.mlir").get("andi0").inputs.get(0);
        assertEquals(List.of("0", "0", "0", "not0.0[0]", "not0.0[1]", "not0.0[2]", "not0.0[3]", "not0.0[4]"), bits(lhs));
        assertEquals("not0", lhs.validArray.node.name);
        assertEquals("not0", lhs.nReadyArray.node.name);
    }

    @Test
    public void bitsShiftedOutGoNowhere() {
        Output out = parse("fold.mlir").get("not0").outputs.get(0);
        for (int b = 0; b < 5; b++)
            assertEquals("andi0", out.dataInArray[b].node.name);
        for (int b = 5; b < 8; b++)
            assertSame(Input.dangling, out.dataInArray[b], "bit " + b);
    }

    @Test
    public void controlTriggeredConstantTiesDataAndKeepsItsTrigger() {
        Input rhs = parse("fold.mlir").get("andi0").inputs.get(1);
        assertEquals(List.of("1", "1", "1", "1", "0", "0", "0", "0"), bits(rhs));
        assertEquals("fork0", rhs.validArray.node.name);
        assertEquals(0, rhs.validArray.index);
        assertSame(rhs, rhs.nReadyArray.readyArray);
        assertFalse(rhs.readyUnused);
    }

    @Test
    public void castChainIsWiring() {
        Input lhs = parse("fold.mlir").get("addi0").inputs.get(0);
        //extsi i4 -> i8, trunci -> i6, extui -> i8
        assertEquals(List.of("not1.0[0]", "not1.0[1]", "not1.0[2]", "not1.0[3]", "not1.0[3]", "not1.0[3]", "0", "0"), bits(lhs));
        assertEquals("not1", lhs.validArray.node.name);
    }

    @Test
    public void sinkTiesReadyHigh() {
        Output o = parse("fold.mlir").get("fork0").outputs.get(2);
        assertTrue(o.readyHigh);
        assertSame(Input.dangling, o.pValidArray);
        assertFalse(parse("fold.mlir").get("fork0").outputs.get(1).readyHigh);
    }

    @Test
    public void kernelPortsMapToRealUnits() {
        parse("fold.mlir");
        assertEquals(List.of("not0_din_0", "not0_valid_in_0", "not0_ready_out_0"), HwMlirParser.portMap.get("x"));
        assertEquals(List.of("fork0_valid_out_1", "fork0_ready_in_1"), HwMlirParser.portMap.get("end"));
        assertEquals(List.of("addi0_dout_0", "addi0_valid_out_0", "addi0_ready_in_0"), HwMlirParser.portMap.get("out0"));
    }

    @Test
    public void constantTriggeredByAKernelPort() {
        Map<String, Node> nodes = parse("kernel_trigger.mlir");
        assertEquals(Set.of("not0", "shli0"), nodes.keySet());
        Input in = nodes.get("not0").inputs.get(0);
        assertEquals(List.of("0", "1", "1", "0"), bits(in));
        assertNull(in.validArray); //kernel port
        assertFalse(in.readyUnused);
        assertEquals(List.of("not0_valid_in_0", "not0_ready_out_0"), HwMlirParser.portMap.get("start"));
    }

    @Test
    public void sourcedConstantIntoARealUnitIsAlwaysValid() {
        Input rhs = parse("kernel_trigger.mlir").get("shli0").inputs.get(1);
        assertEquals(List.of("1", "0", "0", "0"), bits(rhs));
        assertSame(Output.VCC, rhs.validArray);
        assertNull(rhs.nReadyArray);
        assertTrue(rhs.readyUnused);
    }

    @Test
    public void truncationIsWiredBitByBit() {
        //a straight connection of the 3-bit input to the 8-bit output would pair EDIF bus members,
        //i.e. input bit 0 with output bit 5
        Map<String, Node> nodes = parse("trunc.mlir");
        assertEquals(Set.of("not0", "not1"), nodes.keySet());
        Input in = nodes.get("not1").inputs.get(0);
        assertArrayEquals(new int[] {0, 1, 2}, in.dataOutBit);
        assertEquals(List.of("not0.0[0]", "not0.0[1]", "not0.0[2]"), bits(in));
        Output out = nodes.get("not0").outputs.get(0);
        for (int b = 3; b < 8; b++)
            assertSame(Input.dangling, out.dataInArray[b], "bit " + b);
    }
}
