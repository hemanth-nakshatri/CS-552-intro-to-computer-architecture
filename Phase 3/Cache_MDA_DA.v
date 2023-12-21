
//16 bit blocks
module MDA_DA_Cache(clk, rst, Data_Tag, Shift_out, data_addr, write_tag_array, Mem_write, DataIn_DA, write_data_array, miss_data_cache, DataOut_DA);
input clk;
input rst;
output reg miss_data_cache; 
input [15:0] data_addr; //Address for Tag and Set bits
input write_tag_array; 
input Mem_write;
input [5:0] Data_Tag; //LRU, valid, tag
input [63:0] Shift_out; 




reg hit;
wire [63:0] BlockEnable_0; // for Set0 and Set1 of MetaData Array
wire [63:0] BlockEnable_1;
wire [15:0] DataOut; 
reg Write_en; 
reg offset; //which block is hit
reg [15:0] DataIn;
reg Lru_en;  //when hit, write LRU bit of metadata array







//Data array
input [15:0] DataIn_DA;
input write_data_array;
wire Write_en_DA;
wire [63:0] BlockEnable_0_DA;
wire [63:0] BlockEnable_1_DA;
wire [7:0] WordEnable_DA;
output [15:0] DataOut_DA;

MetaDataArray MDA1(.clk(clk), .rst(~rst), .DataIn(DataIn), .Write(Write_en), .Lru_en(Lru_en), .BlockEnable_0(BlockEnable_0), .BlockEnable_1(BlockEnable_1), .DataOut(DataOut));
DataArray DA1(.clk(clk), .rst(~rst), .DataIn(DataIn_DA), .Write(Write_en_DA), .BlockEnable_0(BlockEnable_0_DA), .BlockEnable_1(BlockEnable_1_DA), .offset(offset), .WordEnable(WordEnable_DA), .DataOut(DataOut_DA));



//Blockenables for DA.
assign BlockEnable_0_DA = offset ? 64'h0000000000000000 : Shift_out;
assign BlockEnable_1_DA = !offset ? 64'h0000000000000000 : Shift_out;

//Block enables for MDA - different blocks in MDA file.
assign BlockEnable_0 = Shift_out;
assign BlockEnable_1 = Shift_out;


//One hot enable to choose DA block
word_decoder WD1(.addr(data_addr[3:1]), .word_enable(WordEnable_DA));
assign Write_en_DA = hit ? Mem_write : write_data_array;

always @ (rst, data_addr, write_tag_array, write_data_array, Mem_write, BlockEnable_1_DA, BlockEnable_0_DA, Shift_out) begin 
miss_data_cache = 1'b0;
offset = 1'b0;
Lru_en = 1'b0;
Write_en = 1'b0;
hit = 1'b0;
 case(DataOut[14] && (DataOut[13:8] == Data_Tag))
   1'b1:  begin hit = 1'b1;
          DataIn = {1'b0, DataOut[14:8], 1'b1, DataOut[6:0]};
          Lru_en = 1'b1;
	  offset = 1'b1; //Hit in Block 1
          end
   1'b0:  begin
          case(DataOut[6] && (DataOut[5:0] == Data_Tag))
            1'b1: begin 
		hit = 1'b1;
            	DataIn = {1'b1, DataOut[14:8], 1'b0, DataOut[6:0]};
           	Lru_en = 1'b1;
		offset = 1'b0; //Hit in Block 0
                
            end
            1'b0: begin
            	miss_data_cache = 1'b1;
            	Write_en = write_tag_array;
            		case(DataOut[14])  // valid?
              			1'b0: begin
					DataIn = {1'b0, 1'b1, Data_Tag, 1'b1, DataOut[6:0]};
					offset = 1'b1;
					end
             		 	1'b1: begin
                		     case(DataOut[15])	// valid 1 for block 1?
                			     1'b1: 
						begin
						DataIn = {1'b0, 1'b1, Data_Tag, 1'b1, DataOut[6:0]};		// if lru evict
						offset = 1'b1;
						
						end
                			     1'b0: 
						begin
						DataIn = {1'b1, DataOut[14:8], 1'b0, 1'b1, Data_Tag};	// else evict other block
						offset = 1'b0;
						end
                    			endcase
                   			end
                endcase
              end
            endcase
          end
        endcase 
end //for always

endmodule
