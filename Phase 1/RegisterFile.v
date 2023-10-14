module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);

input clk, rst, WriteReg;
input [3:0] SrcReg1, SrcReg2, DstReg;
input [15:0] DstData;
inout [15:0] SrcData1, SrcData2;

wire [15:0] read_1, read_2, write_sel;
wire [15:0] src1_data;
wire [15:0] src2_data;


ReadDecoder_4_16 rd1(.RegId(SrcReg1), .Wordline(read_1));
ReadDecoder_4_16 rd2(.RegId(SrcReg2), .Wordline(read_2));
WriteDecoder_4_16 rd3(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(write_sel));

Register reg1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(0), .ReadEnable1(read_1[0]), .ReadEnable2(read_2[0]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[1]), .ReadEnable1(read_1[1]), .ReadEnable2(read_2[1]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[2]), .ReadEnable1(read_1[2]), .ReadEnable2(read_2[2]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[3]), .ReadEnable1(read_1[3]), .ReadEnable2(read_2[3]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[4]), .ReadEnable1(read_1[4]), .ReadEnable2(read_2[4]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[5]), .ReadEnable1(read_1[5]), .ReadEnable2(read_2[5]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[6]), .ReadEnable1(read_1[6]), .ReadEnable2(read_2[6]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[7]), .ReadEnable1(read_1[7]), .ReadEnable2(read_2[7]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[8]), .ReadEnable1(read_1[8]), .ReadEnable2(read_2[8]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[9]), .ReadEnable1(read_1[9]), .ReadEnable2(read_2[9]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[10]), .ReadEnable1(read_1[10]), .ReadEnable2(read_2[10]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[11]), .ReadEnable1(read_1[11]), .ReadEnable2(read_2[11]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[12]), .ReadEnable1(read_1[12]), .ReadEnable2(read_2[12]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[13]), .ReadEnable1(read_1[13]), .ReadEnable2(read_2[13]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[14]), .ReadEnable1(read_1[14]), .ReadEnable2(read_2[14]), .Bitline1(src1_data), .Bitline2(src2_data));
Register reg15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(write_sel[15]), .ReadEnable1(read_1[15]), .ReadEnable2(read_2[15]), .Bitline1(src1_data), .Bitline2(src2_data));

assign SrcData1 = (SrcReg1 == 4'b0000) ? 16'b0000_0000_0000_0000 : src1_data;
assign SrcData2 = (SrcReg2 == 4'b0000) ? 16'b0000_0000_0000_0000 : src2_data;

endmodule
