module addsub_4bit(Sum, Ovfl, A, B, sub);

input [3:0] A, B;
input sub;
output [3:0] Sum;
output Ovfl;

wire [3:0] B_neg;
wire [3:0] Cout;

assign B_neg = sub ? ~B : B;

full_adder_1bit FA1(.Sum(Sum[0]), .Cout(Cout[0]), .A(A[0]), .B(B_neg[0]), .Cin(sub));
full_adder_1bit FA2(.Sum(Sum[1]), .Cout(Cout[1]), .A(A[1]), .B(B_neg[1]), .Cin(Cout[0]));
full_adder_1bit FA3(.Sum(Sum[2]), .Cout(Cout[2]), .A(A[2]), .B(B_neg[2]), .Cin(Cout[1]));
full_adder_1bit FA4(.Sum(Sum[3]), .Cout(Cout[3]), .A(A[3]), .B(B_neg[3]), .Cin(Cout[2]));

assign Ovfl = Cout[3] ^ Cout[2];

endmodule