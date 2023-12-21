

module ALU(Inst, ALUIn1, ALUIn2, Shift_Val, ALUOut, Z, V, N);
output reg Z;			// zero flag
output reg [15:0] ALUOut; //ALU output
output reg V, N;		// flags overflow and negative

input [15:0] ALUIn1, ALUIn2;		// Select bw register and immediate for shift
input [3:0] Inst;			//OPCODE
input [3:0] Shift_Val; //Unsigned 4-bit value for shifts - sll, sla, ror

wire overflow;			// overflow			
wire [1:0]shifter_mode;		// rotate , sll or sra	
wire [15:0] sum_out, xor_out, PADDSB_out, RED_out, shifter_out;		
wire cin; 			// carry input for adder/sub 

assign shifter_mode = (Inst[2]) ? Inst[1:0] : 2'b11;
assign cin = (!Inst[3]) ? Inst[0] : 0;



Shifter_16bit shif_rot(.Shift_In(ALUIn1), .Mode_In(shifter_mode), .Shift_Val(Shift_Val), .Shift_Out(shifter_out));
xor_16bit xor_16(.A(ALUIn1),.B(ALUIn2),.OUT(xor_out));
PADDSB PSA(.out_sum(PADDSB_out), .A(ALUIn1), .B(ALUIn2));
RED reduct(.A(ALUIn1),.B(ALUIn2),.OUT(RED_out));
cla_16bit add_sub(.A(ALUIn1), .B(ALUIn2), .cin(cin), .out_sum(sum_out), .Ovfl(overflow));


always @* begin 
casex (Inst[3:0])

	4'b000x  : 	begin 						// ADD and SUB				
			ALUOut = sum_out;
			N = sum_out[15];
			V = overflow;
			Z = (|ALUOut == 0)? 1:0;
		  	end
	4'b0010 : 	begin
			ALUOut = xor_out;				// XOR 
		  	Z = (|ALUOut == 0)? 1:0;
			end 
	4'b0011 : 	begin
			ALUOut = RED_out;				// Reduction
			Z = (|ALUOut == 0)? 1:0;
			end

	4'b0111 : 	begin
			ALUOut = PADDSB_out;				// PADDSB
			Z = (|ALUOut == 0)? 1:0;
			end

	4'b01xx : 	begin
			ALUOut = shifter_out;				// shift & rotate
			Z = (|ALUOut == 0)? 1:0;
			end

	4'b1xxx : 	ALUOut = sum_out;	  			// load and store		
		   
	default : ALUOut = 16'h0001;
endcase 

end

endmodule
