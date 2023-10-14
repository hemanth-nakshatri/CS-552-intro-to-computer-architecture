module WriteDecoder_4_16(Wordline, RegId, WriteReg);
  input [3:0] RegId;
  input WriteReg;
  output [15:0] Wordline;
  assign Wordline = (WriteReg && (RegId == 0)) ? 16'b0000000000000001 :
                    (WriteReg && (RegId == 1)) ? 16'b0000000000000010 :
                    (WriteReg && (RegId == 2)) ? 16'b0000000000000100 :
                    (WriteReg && (RegId == 3)) ? 16'b0000000000001000 :
                    (WriteReg && (RegId == 4)) ? 16'b0000000000010000 :
                    (WriteReg && (RegId == 5)) ? 16'b0000000000100000 :
                    (WriteReg && (RegId == 6)) ? 16'b0000000001000000 :
                    (WriteReg && (RegId == 7)) ? 16'b0000000010000000 :
                    (WriteReg && (RegId == 8)) ? 16'b0000000100000000 :
                    (WriteReg && (RegId == 9)) ? 16'b0000001000000000 :
                    (WriteReg && (RegId == 10)) ? 16'b0000010000000000 :
                    (WriteReg && (RegId == 11)) ? 16'b0000100000000000 :
                    (WriteReg && (RegId == 12)) ? 16'b0001000000000000 :
                    (WriteReg && (RegId == 13)) ? 16'b0010000000000000 :
                    (WriteReg && (RegId == 14)) ? 16'b0100000000000000 :
                    (WriteReg && (RegId == 15)) ? 16'b1000000000000000 : 16'b0000000000000000;
endmodule

