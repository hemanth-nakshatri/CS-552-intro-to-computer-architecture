module BR(
	//flag register input
	input [3:0] flags,
	//condition bits (Table 1)
    input [2:0] ccc,
	//32 bit rs register containing address for jump
    input [31:0] rs,
	//current pc value
	input [15:0] pc,
	//target address = rs if branch
    output reg [31:0] target_address
	
	
);
    logic zero_flag, negative_flag, overflow_flag;
	logic condition;
	assign zero_flag = flags[2];
	assign overflow_flag = flags[1];
	assign negative_flag = flags[0];
    
    always @(*) begin
	
        // Determine the target address based on the opcode and condition
        case (ccc)
            3'b000: condition = ~(zero_flag) ? 1'b1 : 1'b0 ;
            3'b001: condition = (zero_flag) ? 1'b1 : 1'b0 ;
            3'b010: condition = ~(negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b011: condition = (negative_flag) ? 1'b1 : 1'b0 ;
            3'b100: condition = ~(overflow_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b101: condition = (negative_flag | zero_flag) ? 1'b1 : 1'b0 ;
            3'b110: condition = (overflow_flag) ? 1'b1 : 1'b0 ;
            3'b111: condition = 1'b1;
            default: condition = 1'b0;
        endcase
            
        target_address = (condition) ? rs : pc;
    end
endmodule