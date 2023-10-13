module RED(A,B,Sum);

input [15:0] A, B;
output [15:0] Sum;

wire [8:0] ac, bd;
wire carry_ac1, carry_ac2, carry_bd1, carry_bd2, carry_sum_1, carry_sum_2, carry_sum3;
wire [3:0] temp_sum;

addsub_4bit FA1(.a(A[11:8]), .b(B[11:8]), .cin(0), .sum(ac[3:0]), .cout(carry_ac1), .ovfl(), .gen(), .prop());
addsub_4bit FA2(.a(A[15:12]), .b(B[15:12]), .cin(carry_ac1), .sum(ac[7:4]), .cout(carry_ac2), .ovfl(), .gen(), .prop());

assign ac[8] = carry_ac2;

addsub_4bit FA3(.a(A[3:0]), .b(B[3:0]), .cin(0), .sum(bd[3:0]), .cout(carry_bd1), .ovfl(), .gen(), .prop());
addsub_4bit FA4(.a(A[7:4]), .b(B[7:4]), .cin(carry_bd1), .sum(bd[7:4]), .cout(carry_bd2), .ovfl(), .gen(), .prop());

assign bd[8] = carry_bd2;

// Now add the two results by sign extending the MSB of both to 12 bits.
addsub_4bit FA5(.a(ac[3:0]), .b(bd[3:0]), .cin(0), .sum(Sum[3:0]), .cout(carry_sum_1), .ovfl(), .gen(), .prop());
addsub_4bit FA6(.a(ac[7:4]), .b(bd[7:4]), .cin(carry_sum_1), .sum(Sum[7:4]), .cout(carry_sum_2), .ovfl(), .gen(), .prop());
addsub_4bit FA7(.a({4{ac[8]}}), .b({4{bd[8]}}), .cin(carry_sum_2), .sum(Sum[11:8]), .cout(carry_sum_3), .ovfl(), .gen(), .prop());

// assign Sum[8] = temp_sum[0];
assign Sum[15:12] = {4{Sum[11]}};

endmodule
