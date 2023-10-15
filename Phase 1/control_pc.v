module control_pc(
	//branch or no
	input B,
    //flag register input
    input [3:0] flags,
    //condition bits (Table 1)
    input [2:0] ccc,
    //9 bit signed offset
    input signed [8:0] offset,
    //current pc counter
    input [15:0] pc,
    //target address = PC + 2 + (iiiiiiiii << 1) if branch or pc+2 otherwise
    output reg [31:0] target_address
);

    logic zero_flag, negative_flag, overflow_flag;
    logic condition, pc_plus_2, jumped;

    assign zero_flag = flags[2];
    assign overflow_flag = flags[1];
    assign negative_flag = flags[0];
	
	wire [15:0] sign_ext = {{7{offset[8]}},offset[8:0]};
	wire [15:0] lshift;
	assign lshift = sign_ext << 1;

	
	ADDSUB ntaken_add(.a(pc), .b(16'h0002), .sum(pc_plus_2), .ovfl(ovfl_1), .sub(1'b0));
	ADDSUB taken_add(.a(pc_plus_2), .b(lshift), .sum(jumped), .ovfl(ovfl_2), .sub(1'b0));

    always @(*) begin
        // Determine the target address based on the opcode and condition
        case (ccc)
            3'b000: condition <= ~(zero_flag) ? 1'b1 : 1'b0 ;
            3'b001: condition <= (zero_flag) ? 1'b1 : 1'b0 ;
            3'b010: condition <= ~(negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b011: condition <= (negative_flag) ? 1'b1 : 1'b0 ;
            3'b100: condition <= ~(overflow_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b101: condition <= (negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b110: condition <= (overflow_flag) ? 1'b1 : 1'b0 ;
            3'b111: condition <= 1'b1;
            default: condition <= 1'b0;
        endcase

        // Assign target_address based on condition
        target_address = (condition && B) ? jumped : pc_plus_2;
    end
  
        
        
endmodule
