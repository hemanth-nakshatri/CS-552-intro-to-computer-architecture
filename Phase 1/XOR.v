module XOR(A,B,Sum);

input [15:0] A, B;
output [15:0] Sum;

assign Sum = A ^ B;

endmodule
