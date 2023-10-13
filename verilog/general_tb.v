module general_testbench;
wire [15:0] sum; 
wire ovfl;
reg [15:0] a, b;
reg sub;

ADD DUT(.Sum(sum), .Ovfl(ovfl), .A(a), .B(b), .sub(sub));

initial begin
    $monitor("A=%b B=%b Sub=%b Sum=%b Overflow=%b", a, b, sub, sum, ovfl);
    $randomize; // Initialize random number generator. Seed can be set for reproducibility as well.
    repeat (100) begin
      a = $random;
      b = $random;
      sub = $random;
      #10; // Simulate for 10 time units
    end

  end
endmodule