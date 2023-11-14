module control_pc(
	//branch or no
	input B,
    //flag register input
    input [2:0] flags,
    //condition bits (Table 1)
    input [2:0] ccc,
    //9 bit signed offset
    input [8:0] offset,
    //current pc counter
    input [15:0] pc,
    //target address = PC + 2 + (iiiiiiiii << 1) if branch or pc+2 otherwise
    output [15:0] target_address
);

    wire zero_flag, negative_flag, overflow_flag;
    wire [15:0] pc_plus_2, jumped;

	reg condition;

    assign zero_flag = flags[1];
    assign overflow_flag = flags[0];
    assign negative_flag = flags[2];
	
	wire [15:0] sign_ext = {{7{offset[8]}},offset[8:0]};
	wire [15:0] lshift;
	assign lshift = sign_ext << 1;

	
	ADD_SUB ntaken_add(.a(pc), .b(16'h0002), .sum(pc_plus_2), .ovfl(), .sub(1'b0));
	ADD_SUB taken_add(.a(pc_plus_2), .b(lshift), .sum(jumped), .ovfl(), .sub(1'b0));

    always @(*) begin
        // Determine the target address based on the opcode and condition
        case (ccc)
            3'b000: condition = ~(zero_flag) ? 1'b1 : 1'b0 ;
            3'b001: condition = (zero_flag) ? 1'b1 : 1'b0 ;
            3'b010: condition = ~(negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b011: condition = (negative_flag) ? 1'b1 : 1'b0 ;
            3'b100: condition = (zero_flag | ~(negative_flag | zero_flag)) ? 1'b1 : 1'b0 ;
            3'b101: condition = (negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b110: condition = (overflow_flag) ? 1'b1 : 1'b0 ;
            3'b111: condition = 1'b1;
            default: condition = 1'b0;
        endcase

        // Assign target_address based on condition
        
    end
  assign target_address = B ? (condition ? jumped : pc_plus_2) : pc_plus_2;
        
        
endmodule
