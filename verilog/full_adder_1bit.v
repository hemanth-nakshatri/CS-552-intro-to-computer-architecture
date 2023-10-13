
module full_adder_1bit (Sum, Cout, A, B, Cin);
	// Make a single bit full adder and cascade it to get 4 bit adders. (Current plan)
  input A, B, Cin;
  output Sum, Cout;

  assign Sum = A ^ B ^ Cin;
  assign Cout = (A & B) | (B & Cin) | (A & Cin);
endmodule