// A constant triggered straight by a kernel port: the port maps to the reader's valid/ready only,
// and the reader's data bits are tie-offs (see HwMlirParserTest). The shift of the kernel port x
// stays a unit: kernel ports map to whole channels of real units.
module {
  hw.module @trigger(in %x : !handshake.channel<i4>, in %start : !handshake.control<>, in %clk : i1, in %rst : i1, out out0 : !handshake.channel<i4>, out out1 : !handshake.channel<i4>) {
    %constant0.outs = hw.instance "constant0" @handshake_constant_0(ctrl: %start: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i4>)
    %not0.outs = hw.instance "not0" @handshake_not_0(ins: %constant0.outs: !handshake.channel<i4>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i4>)
    %source0.outs = hw.instance "source0" @handshake_source_0(clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.control<>)
    %constant1.outs = hw.instance "constant1" @handshake_constant_1(ctrl: %source0.outs: !handshake.control<>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i4>)
    %shli0.result = hw.instance "shli0" @handshake_shli_0(lhs: %x: !handshake.channel<i4>, rhs: %constant1.outs: !handshake.channel<i4>, clk: %clk: i1, rst: %rst: i1) -> (result: !handshake.channel<i4>)
    hw.output %not0.outs, %shli0.result : !handshake.channel<i4>, !handshake.channel<i4>
  }
  hw.module.extern @handshake_constant_0(in %ctrl : !handshake.control<>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i4>) attributes {hw.name = "handshake.constant", hw.parameters = {DATA_WIDTH = 4 : ui32, VALUE = "0110"}}
  hw.module.extern @handshake_constant_1(in %ctrl : !handshake.control<>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i4>) attributes {hw.name = "handshake.constant", hw.parameters = {DATA_WIDTH = 4 : ui32, VALUE = "0001"}}
  hw.module.extern @handshake_not_0(in %ins : !handshake.channel<i4>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i4>) attributes {hw.name = "handshake.not", hw.parameters = {DATA_TYPE = !handshake.channel<i4>}}
  hw.module.extern @handshake_source_0(in %clk : i1, in %rst : i1, out outs : !handshake.control<>) attributes {hw.name = "handshake.source", hw.parameters = {}}
  hw.module.extern @handshake_shli_0(in %lhs : !handshake.channel<i4>, in %rhs : !handshake.channel<i4>, in %clk : i1, in %rst : i1, out result : !handshake.channel<i4>) attributes {hw.name = "handshake.shli", hw.parameters = {DATA_TYPE = !handshake.channel<i4>}}
}
