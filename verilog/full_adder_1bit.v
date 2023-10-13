module full_adder_1bit(cout, sum, a, b, cin) ;

input a, b, cin;

output sum, cout;

assign sum = a ^ b ^ cin;
assign cout = (a & b) | (sum ^ cin);

endmodule