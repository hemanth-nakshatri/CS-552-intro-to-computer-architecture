module ADD(Sum, Ovfl, A, B, sub);

input [15:0] A, B;
input sub;
output [15:0] Sum;
output Ovfl;

wire [15:0] Cout;
wire [15:0] B_neg;
wire [15:0] temp_sum;

assign B_neg = sub ? ~B : B;

full_adder_1bit FA1(.Sum(temp_sum[0]), .Cout(Cout[0]), .A(A[0]), .B(B[0]), .Cin(sub));
full_adder_1bit FA2(.Sum(temp_sum[1]), .Cout(Cout[1]), .A(A[1]), .B(B[1]), .Cin(Cout[0]));
full_adder_1bit FA3(.Sum(temp_sum[2]), .Cout(Cout[2]), .A(A[2]), .B(B[2]), .Cin(Cout[1]));
full_adder_1bit FA4(.Sum(temp_sum[3]), .Cout(Cout[3]), .A(A[3]), .B(B[3]), .Cin(Cout[2]));
full_adder_1bit FA5(.Sum(temp_sum[4]), .Cout(Cout[4]), .A(A[4]), .B(B[4]), .Cin(Cout[3]));
full_adder_1bit FA6(.Sum(temp_sum[5]), .Cout(Cout[5]), .A(A[5]), .B(B[5]), .Cin(Cout[4]));
full_adder_1bit FA7(.Sum(temp_sum[6]), .Cout(Cout[6]), .A(A[6]), .B(B[6]), .Cin(Cout[5]));
full_adder_1bit FA8(.Sum(temp_sum[7]), .Cout(Cout[7]), .A(A[7]), .B(B[7]), .Cin(Cout[6]));
full_adder_1bit FA9(.Sum(temp_sum[8]), .Cout(Cout[8]), .A(A[8]), .B(B[8]), .Cin(Cout[7]));
full_adder_1bit FA10(.Sum(temp_sum[9]), .Cout(Cout[9]), .A(A[9]), .B(B[9]), .Cin(Cout[8]));
full_adder_1bit FA11(.Sum(temp_sum[10]), .Cout(Cout[10]), .A(A[10]), .B(B[10]), .Cin(Cout[9]));
full_adder_1bit FA12(.Sum(temp_sum[11]), .Cout(Cout[11]), .A(A[11]), .B(B[11]), .Cin(Cout[10]));
full_adder_1bit FA13(.Sum(temp_sum[12]), .Cout(Cout[12]), .A(A[12]), .B(B[12]), .Cin(Cout[11]));
full_adder_1bit FA14(.Sum(temp_sum[13]), .Cout(Cout[13]), .A(A[13]), .B(B[13]), .Cin(Cout[12]));
full_adder_1bit FA15(.Sum(temp_sum[14]), .Cout(Cout[14]), .A(A[14]), .B(B[14]), .Cin(Cout[13]));
full_adder_1bit FA16(.Sum(temp_sum[15]), .Cout(Cout[15]), .A(A[15]), .B(B[15]), .Cin(Cout[14]));

assign Ovfl = Cout[15] ^ Cout[14];

assign Sum = (Ovfl == 0) ? temp_sum : (sub == 0) ? 16'h7FFF : 16'h8000;

endmodule
