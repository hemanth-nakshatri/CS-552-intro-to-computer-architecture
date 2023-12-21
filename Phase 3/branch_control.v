module branch_control (br_cond, F, br_true);


input [2:0] F;
input [2:0] br_cond;
output reg br_true;


always @* begin
case(br_cond)
3'b000: begin
 br_true = (F[2] == 0) ? 1'b1 : 1'b0;
 end
3'b001: begin
 br_true = (F[2] == 1) ? 1'b1 : 1'b0; 
 end
3'b010: begin
 br_true = ((F[2] == 0) & (F[0] ==0)) ? 1'b1 : 1'b0; 
 end
3'b011: begin
 br_true = (F[0] == 1) ? 1'b1 : 1'b0; 
 end
3'b100: begin
 br_true = ((F[2] == 1) | ((F[2] == 0) & (F[0] ==0)))? 1'b1 : 1'b0; 
 end
3'b101: begin
 br_true = ((F[0] == 1) | (F[2] == 1)) ? 1'b1 : 1'b0; 
 end
3'b110: begin
 br_true = (F[1] == 1) ? 1'b1 : 1'b0; 
 end
3'b111: begin
 br_true = 1'b1; 
 end
default: br_true = 1'b0;
endcase
end

endmodule
