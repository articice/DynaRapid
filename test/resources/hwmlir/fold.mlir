// Every fold of parser/FoldedUnits in one kernel (see HwMlirParserTest):
//   x -> not0 -> shli by a sourced 3 (folded) -> andi with 15 behind fork0 (stays: its join is real) -+
//   y -> not1 -> extsi i8 -> trunci i6 -> extui i8 (folded) --------------------------------------> addi0 -> out0
//   start -> fork0: #0 triggers the 15, #1 -> end, #2 -> sink0 (folded: ready tied high)
//   source1 -> constant2 -> sink1 (all folded, nothing left)
module {
  hw.module @fold(in %x : !handshake.channel<i8>, in %y : !handshake.channel<i4>, in %start : !handshake.control<>, in %clk : i1, in %rst : i1, out out0 : !handshake.channel<i8>, out end : !handshake.control<>) {
    %fork0.outs_0, %fork0.outs_1, %fork0.outs_2 = hw.instance "fork0" @handshake_fork_0(ins: %start: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs_0: !handshake.control<>, outs_1: !handshake.control<>, outs_2: !handshake.control<>)
    %not0.outs = hw.instance "not0" @handshake_not_0(ins: %x: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %source0.outs = hw.instance "source0" @handshake_source_0(clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.control<>)
    %constant0.outs = hw.instance "constant0" @handshake_constant_0(ctrl: %source0.outs: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %shli0.result = hw.instance "shli0" @handshake_shli_0(lhs: %not0.outs: !handshake.channel<i8>, rhs: %constant0.outs: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (result: !handshake.channel<i8>)
    %constant1.outs = hw.instance "constant1" @handshake_constant_1(ctrl: %fork0.outs_0: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %andi0.result = hw.instance "andi0" @handshake_andi_0(lhs: %shli0.result: !handshake.channel<i8>, rhs: %constant1.outs: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (result: !handshake.channel<i8>)
    %addi0.result = hw.instance "addi0" @handshake_addi_0(lhs: %extui0.outs: !handshake.channel<i8>, rhs: %andi0.result: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (result: !handshake.channel<i8>)
    %extui0.outs = hw.instance "extui0" @handshake_extui_0(ins: %trunci0.outs: !handshake.channel<i6>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %trunci0.outs = hw.instance "trunci0" @handshake_trunci_0(ins: %extsi0.outs: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i6>)
    %extsi0.outs = hw.instance "extsi0" @handshake_extsi_0(ins: %not1.outs: !handshake.channel<i4>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %not1.outs = hw.instance "not1" @handshake_not_1(ins: %y: !handshake.channel<i4>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i4>)
    hw.instance "sink0" @handshake_sink_0(ins: %fork0.outs_2: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> ()
    %source1.outs = hw.instance "source1" @handshake_source_0(clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.control<>)
    %constant2.outs = hw.instance "constant2" @handshake_constant_2(ctrl: %source1.outs: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    hw.instance "sink1" @handshake_sink_1(ins: %constant2.outs: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> ()
    hw.output %addi0.result, %fork0.outs_1 : !handshake.channel<i8>, !handshake.control<>
  }
  hw.module.extern @handshake_fork_0(in %ins : !handshake.control<>, in %clk : i1, in %rst : i1, out outs_0 : !handshake.control<>, out outs_1 : !handshake.control<>, out outs_2 : !handshake.control<>) attributes {hw.name = "handshake.fork", hw.parameters = {SIZE = 3 : ui32, DATA_TYPE = !handshake.control<>}}
  hw.module.extern @handshake_not_0(in %ins : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.not", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_not_1(in %ins : !handshake.channel<i4>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i4>) attributes {hw.name = "handshake.not", hw.parameters = {DATA_TYPE = !handshake.channel<i4>}}
  hw.module.extern @handshake_source_0(in %clk : i1, in %rst : i1, out outs : !handshake.control<>) attributes {hw.name = "handshake.source", hw.parameters = {}}
  hw.module.extern @handshake_constant_0(in %ctrl : !handshake.control<>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.constant", hw.parameters = {DATA_WIDTH = 8 : ui32, VALUE = "00000011"}}
  hw.module.extern @handshake_constant_1(in %ctrl : !handshake.control<>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.constant", hw.parameters = {DATA_WIDTH = 8 : ui32, VALUE = "00001111"}}
  hw.module.extern @handshake_constant_2(in %ctrl : !handshake.control<>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.constant", hw.parameters = {DATA_WIDTH = 8 : ui32, VALUE = "10101010"}}
  hw.module.extern @handshake_shli_0(in %lhs : !handshake.channel<i8>, in %rhs : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out result : !handshake.channel<i8>) attributes {hw.name = "handshake.shli", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_andi_0(in %lhs : !handshake.channel<i8>, in %rhs : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out result : !handshake.channel<i8>) attributes {hw.name = "handshake.andi", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_addi_0(in %lhs : !handshake.channel<i8>, in %rhs : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out result : !handshake.channel<i8>) attributes {hw.name = "handshake.addi", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_extui_0(in %ins : !handshake.channel<i6>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.extui", hw.parameters = {INPUT_TYPE = !handshake.channel<i6>, OUTPUT_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_trunci_0(in %ins : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i6>) attributes {hw.name = "handshake.trunci", hw.parameters = {INPUT_TYPE = !handshake.channel<i8>, OUTPUT_TYPE = !handshake.channel<i6>}}
  hw.module.extern @handshake_extsi_0(in %ins : !handshake.channel<i4>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.extsi", hw.parameters = {INPUT_TYPE = !handshake.channel<i4>, OUTPUT_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_sink_0(in %ins : !handshake.control<>, in %clk : i1, in %rst : i1) attributes {hw.name = "handshake.sink", hw.parameters = {DATA_TYPE = !handshake.control<>}}
  hw.module.extern @handshake_sink_1(in %ins : !handshake.channel<i8>, in %clk : i1, in %rst : i1) attributes {hw.name = "handshake.sink", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
}
