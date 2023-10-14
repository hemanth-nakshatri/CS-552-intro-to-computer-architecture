module PADDSB (A, B, Sum);

input [15:0] A, B;
output [15:0] Sum;

// Call instances of the padd_4bit calculations. Makes it simpler to understand.

PADD_4bit pad1(.A(A[3:0]), .B(B[3:0]), .Sum(Sum[3:0])); 
PADD_4bit pad2(.A(A[7:4]), .B(B[7:4]), .Sum(Sum[7:4])); 
PADD_4bit pad3(.A(A[11:8]), .B(B[11:8]), .Sum(Sum[11:8])); 
PADD_4bit pad4(.A(A[15:12]), .B(B[15:12]), .Sum(Sum[15:12])); 

endmodule
