module general_test_bench;
wire [15:0] sum; 
// wire ovfl;
reg [15:0] a;
reg [3:0] b;
reg [1:0] opcode;
// reg sub;
Shifter DUT(opcode, sum, a,b);

initial begin
    $monitor("A=%b B=%b Sum=%b Opcode=%b", a, b, sum, opcode);
    $randomize; // Initialize random number generator. Seed can be set for reproducibility as well.
    repeat (100) begin
      a = $random;
      b = $random;
      opcode = $random;
      //sub = $random;
      #10; // Simulate for 10 time units
    end

  end
endmodule
