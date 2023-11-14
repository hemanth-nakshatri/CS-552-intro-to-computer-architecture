module Shifter (Shift_Out, Shift_In, Shift_Val, opcode);
input [15:0] Shift_In;   // Input data
input [3:0] Shift_Val;   // Shift amount
input [1:0] opcode; // indicates shifting type     
output [15:0] Shift_Out; // Shifted output 
wire [15:0] l_shift0, l_shift1, l_shift2;
wire [15:0] r_shift0, r_shift1, r_shift2;
wire [15:0] r_rotate0, r_rotate1, r_rotate2;

wire [1:0] Shift_ones, Shift_threes, Shift_nines;

binary_to_base3 b23(.binary(Shift_Val), .Shift_1(Shift_1), .Shift_3(Shift_3), .Shift_9(Shift_9));

assign r_rotate0 = (Shift_1== 0) ? Shift_In : (Shift_1 == 1) ? {Shift_In[0], Shift_In[15:1]} : {Shift_In[1:0], Shift_In[15:2]};
assign r_rotate1 = (Shift_3 == 0) ? r_rotate0 : (Shift_3 == 1) ? {r_rotate0[2:0], r_rotate0[15:3]} : {r_rotate0[5:0], r_rotate0[15:6]};
assign r_rotate2 = (Shift_9 == 0) ? r_rotate1 : (Shift_9 == 1) ? {r_rotate1[8:0], r_rotate0[15:9]} : 16'h0000;

assign l_shift0 = (Shift_1 == 0) ? Shift_In : (Shift_1 == 1) ? {Shift_In[15:1], 1'b0} : {Shift_In[15:2], 2'b00};
assign l_shift1 = (Shift_3 == 0) ? l_shift0 : (Shift_3 == 1) ? {l_shift0[15:3], 3'h0} : {l_shift0[15:6], 6'h0};
assign l_shift2 = (Shift_9 == 0) ? l_shift1 : (Shift_9 == 1) ? {l_shift1[15:9], 3'h0} : 16'h0000;

assign r_shift0 = (Shift_1 == 0) ? Shift_In : (Shift_1 == 1) ? {{1{Shift_In[15]}}, Shift_In[15:1]} : {{2{Shift_In[15]}}, Shift_In[15:2]};
assign r_shift1 = (Shift_3 == 0) ? r_shift0 : (Shift_3 == 1) ? {{3{r_shift0[15]}}, r_shift0[15:3]} : {{6{r_shift0[15]}}, r_shift0[15:6]};
assign r_shift2 = (Shift_9 == 0) ? r_shift1 : (Shift_9 == 1) ? {{9{r_shift1[15]}}, r_shift1[15:3]} : 16'h0000;

assign Shift_Out = (opcode[1]) ? r_rotate2 : (opcode[0]) ? r_shift2 : l_shift2; //mux to determine where shift

endmodule