module binary_to_base3 (
    input [3:0] binary,
    output reg [1:0] Shift_1,
    output reg [1:0] Shift_3,
    output reg [1:0] Shift_9
);

always@(*)  
begin
    case(binary)
        4'b0000: begin Shift_1 = 2'b00; Shift_3 = 2'b00; Shift_9 = 2'b00; end
        4'b0001: begin Shift_1 = 2'b01; Shift_3 = 2'b00; Shift_9 = 2'b00; end
        4'b0010: begin Shift_1 = 2'b10; Shift_3 = 2'b00; Shift_9 = 2'b00; end
        4'b0011: begin Shift_1 = 2'b00; Shift_3 = 2'b01; Shift_9 = 2'b00; end
        4'b0100: begin Shift_1 = 2'b01; Shift_3 = 2'b01; Shift_9 = 2'b00; end
        4'b0101: begin Shift_1 = 2'b10; Shift_3 = 2'b01; Shift_9 = 2'b00; end
        4'b0110: begin Shift_1 = 2'b00; Shift_3 = 2'b10; Shift_9 = 2'b00; end
        4'b0111: begin Shift_1 = 2'b01; Shift_3 = 2'b10; Shift_9 = 2'b00; end
        4'b1000: begin Shift_1 = 2'b10; Shift_3 = 2'b10; Shift_9 = 2'b00; end
        4'b1001: begin Shift_1 = 2'b00; Shift_3 = 2'b00; Shift_9 = 2'b01; end
        4'b1010: begin Shift_1 = 2'b01; Shift_3 = 2'b00; Shift_9 = 2'b01; end
        4'b1011: begin Shift_1 = 2'b10; Shift_3 = 2'b00; Shift_9 = 2'b01; end
        4'b1100: begin Shift_1 = 2'b00; Shift_3 = 2'b01; Shift_9 = 2'b01; end
        4'b1101: begin Shift_1 = 2'b01; Shift_3 = 2'b01; Shift_9 = 2'b01; end
        4'b1110: begin Shift_1 = 2'b10; Shift_3 = 2'b01; Shift_9 = 2'b01; end
        4'b1111: begin Shift_1 = 2'b00; Shift_3 = 2'b10; Shift_9 = 2'b01; end
        default: begin $display("Error"); end
    endcase
end

endmodule
