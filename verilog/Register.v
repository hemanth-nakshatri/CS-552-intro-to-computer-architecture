module Register(
    inout [15:0] Bitline1,
    inout [15:0] Bitline2,    
    input clk,
    input rst,
    input [15:0] D,
    input WriteReg,
    input ReadEnable1,
    input ReadEnable2
);
    wire [15:0] Wordline;
    
    BitCell bc_instance [15:0] (.Bitline1(Bitline1), .Bitline2(Bitline2), .clk(clk), .rst(rst), .D(D), .WriteEnable(WriteReg), .ReadEnable1(ReadEnable1), .ReadEnable2(ReadEnable2));
    
endmodule

