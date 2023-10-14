module ADD_SUB (a,b,sub,sum,ovfl);

input [15:0] a, b;
input sub;
output [15:0] sum;
output ovfl;

wire [4:0] c;
wire [15:0] b_neg;	// Negate if sub = 1
wire [3:0] g; 	// Generate
wire [3:0] p;	// Propagate
wire [15:0] temp_sum;

assign b_neg = (sub == 0) ? b : ~b;

// Carry-in = sub; Calculate carry 
assign c[0] = sub;
assign c[1] = g[0] | (p[0] & c[0]);
assign c[2] = g[1] | (p[1] & c[1]);
assign c[3] = g[2] | (p[2] & c[2]);
assign c[4] = g[3] | (p[3] & c[3]);

addsub_4bit FA1(.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .sum(temp_sum[3:0]), .cout(), .ovfl(), .gen(g[0]), .prop(p[0]));
addsub_4bit FA2(.a(a[7:4]), .b(b[7:4]), .cin(c[1]), .sum(temp_sum[7:4]), .cout(), .ovfl(), .gen(g[1]), .prop(p[1]));
addsub_4bit FA3(.a(a[11:8]), .b(b[11:8]), .cin(c[2]), .sum(temp_sum[11:8]), .cout(), .ovfl(), .gen(g[2]), .prop(p[2]));
addsub_4bit FA4(.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .sum(temp_sum[15:12]), .cout(), .ovfl(), .gen(g[3]), .prop(p[3]));

assign ovfl = (b_neg[15] ~^ a[15]) & (temp_sum[15] != a[15]);

// Check overflow and assign saturated values if there is overflow
assign sum = (ovfl == 0) ? temp_sum : (c[4] ? 16'h8000 : 16'h7fff);

endmodule
