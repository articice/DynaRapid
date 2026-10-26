// A truncation keeps the low bits in place but reads fewer: the reader's input is narrower than the
// unit output it comes from, so it is wired bit by bit, not as a whole channel (see HwMlirParserTest)
module {
  hw.module @trunc(in %x : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out out0 : !handshake.channel<i3>) {
    %not0.outs = hw.instance "not0" @handshake_not_0(ins: %x: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i8>)
    %trunci0.outs = hw.instance "trunci0" @handshake_trunci_0(ins: %not0.outs: !handshake.channel<i8>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i3>)
    %not1.outs = hw.instance "not1" @handshake_not_1(ins: %trunci0.outs: !handshake.channel<i3>, clk: %clk: i1, rst: %rst: i1) -> (outs: !handshake.channel<i3>)
    hw.output %not1.outs : !handshake.channel<i3>
  }
  hw.module.extern @handshake_not_0(in %ins : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i8>) attributes {hw.name = "handshake.not", hw.parameters = {DATA_TYPE = !handshake.channel<i8>}}
  hw.module.extern @handshake_not_1(in %ins : !handshake.channel<i3>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i3>) attributes {hw.name = "handshake.not", hw.parameters = {DATA_TYPE = !handshake.channel<i3>}}
  hw.module.extern @handshake_trunci_0(in %ins : !handshake.channel<i8>, in %clk : i1, in %rst : i1, out outs : !handshake.channel<i3>) attributes {hw.name = "handshake.trunci", hw.parameters = {INPUT_TYPE = !handshake.channel<i8>, OUTPUT_TYPE = !handshake.channel<i3>}}
}
