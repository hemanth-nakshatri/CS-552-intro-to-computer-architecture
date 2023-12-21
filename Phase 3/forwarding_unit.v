module forwarding_unit(ID_EX_Rs, ID_EX_Rt, MEM_WB_Rd, EX_MEM_Rd,
                        EX_MEM_RegWrite, EX_MEM_MemWrite, MEM_WB_RegWrite, fwd_1, fwd_2, fwd_mux_mem);

input [3:0]ID_EX_Rs, ID_EX_Rt, MEM_WB_Rd, EX_MEM_Rd;
input EX_MEM_RegWrite, EX_MEM_MemWrite, MEM_WB_RegWrite;
output [1:0]fwd_1, fwd_2;
output fwd_mux_mem;


//EX to EX
assign fwd_1 = ((EX_MEM_RegWrite) && (|EX_MEM_Rd != 1'b0) && (EX_MEM_Rd == ID_EX_Rs)) ? 2'b10 :
			((MEM_WB_RegWrite) && (|MEM_WB_Rd != 1'b0) && (MEM_WB_Rd == ID_EX_Rs)) ? 2'b01 : 2'b00;


assign fwd_2 = ((EX_MEM_RegWrite) && (|EX_MEM_Rd != 1'b0) && (EX_MEM_Rd == ID_EX_Rt)) ? 2'b10 :
			((MEM_WB_RegWrite) && |MEM_WB_Rd != 1'b0 && (MEM_WB_Rd == ID_EX_Rt)) ? 2'b01 : 2'b00;

// MEM to MEM 
assign fwd_mux_mem = (EX_MEM_MemWrite && MEM_WB_RegWrite && (|MEM_WB_Rd != 1'b0) && (MEM_WB_Rd == EX_MEM_Rd)) ? 1: 0;

endmodule
