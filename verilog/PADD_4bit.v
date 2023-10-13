module PADD_4bit (A, B, Sum);

input [3:0] A, B;
output [3:0] Sum;

// check overflow flah to saturate values or not
wire ovfl, pos_ovfl, neg_ovfl; // check positive or negative overflow; overflow happens only if both operands have same sign

wire [3:0] temp_sum;
//wire [3:0] carry;

addsub_4bit FA1(.a(A), .b(B), .cin(0), .sum(temp_sum), .cout(), .ovfl(), .gen(), .prop());

assign pos_ovfl = (~A[3]) & (~B[3]) & (temp_sum[3]); // A, B are positive.... But Sum is negative
assign neg_ovfl = (A[3]) & (B[3]) & (~temp_sum[3]); // A, B are negative.... But Sum is positive

assign ovfl = pos_ovfl | neg_ovfl;

assign Sum = (ovfl == 0) ? temp_sum : pos_ovfl ? 4'h7 : 4'h8;

endmodule
