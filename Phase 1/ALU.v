module ALU_16bit(ALU_Out, ALU_In1, ALU_In2, Opcode,Flags, enable);

input [15:0] ALU_In1, ALU_In2;
input [3:0] Opcode;
output [15:0] ALU_Out;
output [2:0] Flags;
output [2:0] enable;

wire [15:0] Sum, Diff, Paddsb, exor, red, shift_out;
wire add_ovfl, sub_ovfl;

ADD_SUB add(.a(ALU_In1), .b(ALU_In2), .sub(0), .sum(Sum), .ovfl(add_ovfl));
ADD_SUB sub(.a(ALU_In1), .b(ALU_In2), .sub(1), .sum(Diff), .ovfl(sub_ovfl));

RED red1(.A(ALU_In1), .B(ALU_In2), .Sum(red));
PADDSB padd(.A(ALU_In1), .B(ALU_In2), .Sum(Paddsb));

XOR exor1(.A(ALU_In1), .B(ALU_In2), .Sum(exor));
Shifter shift(.opcode(Opcode[1:0]), .Shift_Out(shift_out), .Shift_In(ALU_In1), .Shift_Val(ALU_In2));

reg [2:0] enable;

always @* case (Opcode)
4'h0 : begin 
	assign enable = 3'b111;
	end
4'h1 : begin	
	assign enable = 3'b111;
	end
4'h2 : begin
	assign enable = 3'b010;
	end
4'h3 : begin
	assign enable = 3'b010;
	end
4'h4 : begin
	assign enable = 3'b010;
	end
4'h5 : begin
	assign enable = 3'b010;
	end
4'h6 : begin
	assign enable = 3'b010;
	end
4'h7 : begin
	assign enable = 3'b010;
	end
default: assign enable = 3'b000;
endcase

assign ALU_Out = (Opcode == 4'h0) ? Sum:
				 (Opcode == 4'h1) ? Diff:
				 (Opcode == 4'h2) ? exor:
				 (Opcode == 4'h3) ? red:
				 (Opcode == 4'h4) ? shift_out:
				 (Opcode == 4'h5) ? shift_out:
				 (Opcode == 4'h6) ? shift_out: 
				 (Opcode == 4'h7) ? Paddsb : 
				 (Opcode == 4'h8) ? Sum :	// LW
				 (Opcode == 4'h9) ? Sum : 	// SW
				(Opcode == 4'h10) ? Sum :	// LLB
				(Opcode == 4'h11) ? Sum :	// LHB
				(Opcode == 4'h12) ? Sum :	// B
				(Opcode == 4'h13) ? Sum :	// BR
				(Opcode == 4'h14) ? Sum :	// PCS
				(Opcode == 4'h15) ? Sum :	// HLT
				 ALU_In1 | ALU_In2;

assign Flags[0] = ((Opcode == 4'h0)& (add_ovfl == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (sub_ovfl == 1'b1)) ? 1'b1: 1'b0;	// V Flag

assign Flags[2] = ((Opcode == 4'h0)& (Sum[15] == 1'b1)) ? 1'b1:
		   ((Opcode == 4'h1) & (Diff[15] == 1'b1)) ? 1'b1: 1'b0;	// N Flag

assign Flags[1] = (ALU_Out == 16'h0000); 	// Z flag

assign en = enable;

endmodule
