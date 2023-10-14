module BitCell(Bitline1, Bitline2, clk, rst, D, WriteEnable, ReadEnable1, ReadEnable2);
  input clk;
  input rst;
  input D;
  input WriteEnable;
  input ReadEnable1;
  input ReadEnable2;

  inout Bitline1;
  inout Bitline2;

  wire BitValue;

  dff dff1(.q(BitValue), .d(D), .wen(WriteEnable), .clk(clk), .rst(rst));

  assign Bitline1 = (ReadEnable1) ? BitValue : 1'bZ;
  assign Bitline2 = (ReadEnable2) ? BitValue : 1'bZ;

endmodule

