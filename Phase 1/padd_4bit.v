module padd_4bit (Sum, A, B);

input [3:0] A, B; //Input values
output [3:0] Sum; //sum output
wire Ovfl; //To indicate overflow
wire povfl,novfl;
wire [3:0] temp_sum;

wire [3:0] C;
assign C[0] = 1'b0;
full_adder_1bit FA0 (.cout(C[1]),.sum(temp_sum[0]),.a(A[0]), .b(B[0]),.cin(C[0])); //Example of using the one bit full adder(which you must also design)
full_adder_1bit FA1 (.cout(C[2]),.sum(temp_sum[1]),.a(A[1]), .b(B[1]),.cin(C[1]));
full_adder_1bit FA2 (.cout(C[3]),.sum(temp_sum[2]),.a(A[2]), .b(B[2]),.cin(C[2]));
full_adder_1bit FA3 (.cout(),.sum(temp_sum[3]),.a(A[3]), .b(B[3]),.cin(C[3]));
assign povfl = (~A[3]) & (~B[3]) & (temp_sum[3]); //A and B positive, Sum negative
assign novfl = (A[3] & B[3] & (~temp_sum[3]));	//A and B negative, sum positive
assign Ovfl = povfl|novfl; 
assign Sum = povfl ? 4'h7 : 
			 novfl ? 4'h8 : temp_sum;
endmodule
