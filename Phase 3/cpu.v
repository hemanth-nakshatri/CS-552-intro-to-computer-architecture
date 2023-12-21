module cpu(clk, rst_n, hlt, pc);
//IO ports
input clk;
input rst_n;
output hlt;
output [15:0] pc;

//all initializations
wire [3:0] imm_4bit;
wire [7:0] imm_8bit;
wire [8:0] imm_9bit;
wire [15:0]br_offset;
wire [15:0]pc_in;
wire [15:0] Dmem_out;
wire [3:0] DstReg;
wire [3:0] SrcReg1;
wire [3:0] SrcReg2;
wire br_true; // true then B/BR will be taken
wire [2:0] flags_in;
wire MemtoReg;
wire Inst_enable;
wire [15:0] Inst;
wire [2:0] br_cond;
wire [15:0] SrcData1;
wire [15:0] SrcData2;
wire [15:0] DstData;
wire [15:0] src_imm_sel;
wire [15:0] SrcData1_pre;
wire Inst_wr; //write for immm - tied off to 1'b0 
wire [15:0] Inst_data_in; //Tied off to 16'b0 
wire [3:0] opcode;
wire pc_overflow; 
wire br_overflow; 
wire [15:0] ALUOut;
wire Z, N, V, flag_wen;
wire write_tag_array;
wire [15:0]branch_pc;
wire [15:0]next_pc;
wire pc_wen;
wire MemRead;
wire MemWrite;
wire RegWrite;


//Phase_2 wires

wire [15:0]LLB_LHB;
wire [15:0] SrcData1_raw;
wire [15:0] SrcData2_raw;
wire [3:0] ID_EX_RdAddr;
wire [15:0]EX_MEM_ALUIn;
wire [15:0] ID_EX_sign_extend;
wire [15:0] sign_extend;
wire [15:0] ID_EX_SrcData2;
wire [3:0] ID_EX_RtAddr;
wire [3:0] ID_EX_RsAddr;
wire [15:0] EX_MEM_ALUOut;
wire [15:0] EX_MEM_MemData;
wire [1:0] fwd_1, fwd_2;
wire ID_EX_flag_br_checker, EX_MEM_flag_br_checker , MEM_WB_flag_br_checker;
wire ID_EX_hlt, EX_MEM_hlt, MEM_WB_hlt;
wire [2:0]EX_MEM_flags, MEM_WB_flags;
wire [15:0]ID_EX_SrcData1;
wire hlt_pre;
wire [15:0]ALUIn1, ALUIn2;
wire [15:0]data_in;
wire fwd_mux_mem;
wire stall;
wire [15:0] IF_ID_Inst; 
wire ID_EX_RegWrite;
wire EX_MEM_RegWrite; 
wire IF_Flush; 
wire ID_Flush;
wire [15:0] IF_ID_next_pc;
wire ID_EX_MemRead;
wire ID_EX_MemtoReg;
wire ID_EX_MemWrite;
wire MEM_WB_MemtoReg;
wire [3:0] ID_EX_opcode;
wire [3:0] ID_EX_imm_4bit;
wire MEM_WB_RegWrite;
wire [15:0] MEM_WB_ALUOut;
wire flag_br_checker;
wire [15:0]ID_EX_next_pc;
wire [15:0] MEM_WB_DmemOut;
wire [3:0] MEM_WB_RdAddr;
wire [3:0] EX_MEM_RdAddr;
wire IF_ID_hlt;
wire stall_data_miss;
wire stall_inst_miss;
wire miss_inst_cache;

//Phase 3 wires
wire fsm_busy; //Use for stall
wire [15:0]MemData;
wire [63:0] Shift_Out_Data;
wire memory_data_valid;

wire [15:0] miss_address;
wire [15:0] MCM_Data_Out;
wire [15:0] DataIn_DA;
wire [15:0] memory_address; //This is the miss address from cache controller used by data array
wire [15:0] main_memory_address;
wire [15:0] Inst_cache;
wire write_data_array;
wire miss_detected;
wire miss_data_cache;
wire write_tag_array_DM, write_tag_array_IM, write_data_array_IM, write_data_array_DM;
wire miss_data_cache_pre;
wire [15:0] data_addr, inst_addr;
wire [63:0] Shift_Out_Inst;


//Opcode assignment
assign opcode = IF_ID_Inst[15:12];

//checking reset
assign Inst_enable = (~rst_n) ? 1'b0 : 1'b1;

//hlt instruction
assign hlt_pre = (Inst[15:12] == 4'b1111) ? 1'b1 : 1'b0;
assign hlt = MEM_WB_hlt;

//PC register
assign pc_wen = (~rst_n || (hlt_pre & !IF_Flush) || stall || (stall_data_miss) || (stall_inst_miss) || write_tag_array) ? 1'b0 : 1'b1; //arbitration signal 
dflipflop_16bit program_counter(.q(pc), .d(pc_in), .wen(pc_wen), .clk(clk), .rst(~rst_n)); // 16 bit current pc value reg

//Imem
assign Inst_wr = 1'b0;
assign Inst_data_in = 16'b0;

//imm fields
assign imm_4bit = IF_ID_Inst[3:0]; 
assign imm_8bit = IF_ID_Inst[7:0]; 
assign imm_9bit = IF_ID_Inst[8:0]; 
assign br_cond = IF_ID_Inst[11:9]; //3-bit branch condition, flag checking

// RegFile Inputs
assign SrcReg1 = IF_ID_Inst[7:4]; //Always source register SrcReg1 -- ALU Src1
assign SrcReg2 = ((opcode == 4'b1000) | (opcode == 4'b1001) | opcode == 4'b1011 | opcode == 4'b1010) ? IF_ID_Inst[11:8] : IF_ID_Inst[3:0]; //Inst[11:8] is source register (from which value is to be stored in memory) for sw instruction, and source for LLB, LHB instructions
assign DstReg = IF_ID_Inst[11:8]; //Always destination register
assign RegWrite = (((opcode[3] == 1'b0) || (opcode == 4'b1000) || (opcode == 4'b1010) || (opcode == 4'b1011) || (opcode == 4'b1110)) && IF_ID_next_pc != 16'b0)  ? 1'b1 : 1'b0;

//Regfile
RegisterFile Regfile(.clk(clk), .rst(~rst_n), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(MEM_WB_RdAddr), .WriteReg(MEM_WB_RegWrite), .DstData(DstData), .SrcData1(SrcData1_raw), .SrcData2(SrcData2_raw));
assign SrcData1_pre = ((SrcReg1 == MEM_WB_RdAddr) && (MEM_WB_RegWrite) && (MEM_WB_RdAddr != 4'b0)) ? DstData : SrcData1_raw; 
assign SrcData2 = ((SrcReg2 == MEM_WB_RdAddr) && (MEM_WB_RegWrite) && (MEM_WB_RdAddr != 4'b0)) ? DstData : SrcData2_raw;  

//Writing Flag Registers
assign flags_in = {Z, V, N};
assign flag_wen = (ID_EX_opcode[3:1] == 3'b000) || (ID_EX_opcode == 4'b0010) || (ID_EX_opcode == 4'b0100) || (ID_EX_opcode == 4'b0101) || (ID_EX_opcode == 4'b0110);

//Enforcing LSB of address is 1'b0 for LW/SW
assign SrcData1 = (opcode[3]) ? (SrcData1_pre & 16'hFFFE) : SrcData1_pre; 
// SrcData2 or Imm (only for LW/SW)  per opcode
assign src_imm_sel = (ID_EX_opcode[3] & ID_EX_opcode != 4'b1111) ?  ID_EX_sign_extend : ID_EX_SrcData2; //ALU Src2


//ALU - for ADD, SUB, RED, ROR, PADDSB, SLL, SRA, XOR, LW, SW.
assign ALUIn1 = (fwd_1 == 2'b00 || fwd_1 == 2'b11) ? ID_EX_SrcData1 : ((fwd_1 == 2'b10) ? EX_MEM_ALUOut : DstData);
assign ALUIn2 = ID_EX_opcode[3:1] == 3'b100 ? src_imm_sel : (fwd_2 == 2'b00 || fwd_2 == 2'b11) ? src_imm_sel : (fwd_2 == 2'b10) ? EX_MEM_ALUOut : DstData;
ALU ALU_LW_SW(.Inst(ID_EX_opcode), .ALUIn1(ALUIn1), .ALUIn2(ALUIn2), .Shift_Val(ID_EX_imm_4bit), .ALUOut(ALUOut), .Z(Z), .V(V), .N(N));


assign MemWrite = (opcode == 4'b1001) ? 1'b1 : 1'b0; //SW
assign MemRead = (opcode == 4'b1000) ? 1'b1 : 1'b0; //LW
assign MemtoReg =  (opcode == 4'b1000) ? 1'b1 : 1'b0; //LW, similar to MemRead



//PC_Next adder
Adder_16bit PC_add (.A(pc), .B(16'h0002), .cin(1'b0), .Sum(next_pc), .Ovfl(pc_overflow));

//Branch adder
assign br_offset = {{6{imm_9bit[8]}}, imm_9bit, 1'b0};
Adder_16bit Br_add (.A(IF_ID_next_pc), .B(br_offset), .cin(1'b0), .Sum(branch_pc), .Ovfl(br_overflow));

//Dmem
assign MemData =  (fwd_2 == 2'b01) ? DstData : ID_EX_SrcData2;
assign data_in = (fwd_mux_mem) ? DstData : EX_MEM_MemData ;

//Branch or not: opcode and br_true.
assign pc_in = (opcode[3:1] == 3'b110) ? (opcode[0] ? (br_true ? SrcData1 : next_pc) : (br_true ? branch_pc : next_pc)) : next_pc;


assign EX_MEM_ALUIn =  (ID_EX_opcode == 4'b1110) ? ID_EX_next_pc : //PCS
			(ID_EX_opcode[3:1] == 3'b101) ? LLB_LHB : ALUOut;
//LW, SW, LLB, LHB, B, BR, PCS, HLT Instructions
assign DstData =  MEM_WB_MemtoReg ? MEM_WB_DmemOut : //LW
                  MEM_WB_ALUOut; //ALU Instructions - ADD, SUB, XOR, RED, PADDSB, SLL, ROR, SRA. X for SW, B, BR, HLT since RegWrite == 0.
				  
//None for SW, B, BR, HLT - no need to write, RegWrite == 1'b0
assign LLB_LHB = (fwd_2 == 2'b00 || fwd_2 == 2'b11) ? 
			(ID_EX_opcode[0] ? (ID_EX_SrcData2 & 16'h00FF) | ID_EX_sign_extend : (ID_EX_SrcData2 & 16'hFF00) | ID_EX_sign_extend) : 
		 fwd_2 == 2'b10 ? (ID_EX_opcode[0] ? (EX_MEM_ALUOut & 16'h00FF) | ID_EX_sign_extend : (EX_MEM_ALUOut & 16'hFF00) | ID_EX_sign_extend) : 
			(ID_EX_opcode[0] ? (MEM_WB_ALUOut & 16'h00FF) | ID_EX_sign_extend : (MEM_WB_ALUOut & 16'hFF00) | ID_EX_sign_extend);




//    HDU Instantiation
HDU HDU_01 (.IF_ID_Inst(IF_ID_Inst), .ID_EX_MemRead(ID_EX_MemRead), .ID_EX_RegWrite(ID_EX_RegWrite), .EX_MEM_RegWrite(EX_MEM_RegWrite), .EX_MEM_RdAddr(EX_MEM_RdAddr), .br_true(br_true), .MemWrite(MemWrite), .ID_EX_flag_br_checker(ID_EX_flag_br_checker), .EX_MEM_flag_br_checker(EX_MEM_flag_br_checker), .MEM_WB_flag_br_checker(MEM_WB_flag_br_checker), .ID_EX_RtAddr(ID_EX_RtAddr), .stall(stall), .IF_Flush(IF_Flush), .ID_Flush(ID_Flush), .flag_br_checker(flag_br_checker));
//B, BR check condition
branch_control BR1(.br_cond(br_cond), .F(MEM_WB_flags), .br_true(br_true));

//   Pipeline Instantiation    
IF_ID Inst1(.clk(clk), .rst_n(rst_n), .Inst(Inst), .pc(next_pc), .IF_Flush(IF_Flush), .stall(stall), .stall_data_miss(stall_data_miss), .IF_ID_Inst(IF_ID_Inst), .IF_ID_next_pc(IF_ID_next_pc), .hlt(hlt_pre), .IF_ID_hlt(IF_ID_hlt));


EX_MEM Inst3(.clk(clk), .rst_n(rst_n), .stall_data_miss(stall_data_miss), .ID_EX_RegWrite(ID_EX_RegWrite), .ID_EX_MemRead(ID_EX_MemRead), .ID_EX_MemWrite(ID_EX_MemWrite), .ID_EX_MemtoReg(ID_EX_MemtoReg), .ALUOut(EX_MEM_ALUIn), .ID_EX_RdAddr(ID_EX_RdAddr), .MemData(MemData), .ID_EX_flag_br_checker(ID_EX_flag_br_checker), .flag_wen(flag_wen), .flags_in(flags_in), .ID_EX_hlt(ID_EX_hlt),
.EX_MEM_RegWrite(EX_MEM_RegWrite), .EX_MEM_MemRead(EX_MEM_MemRead), .EX_MEM_MemWrite(EX_MEM_MemWrite), .EX_MEM_MemtoReg(EX_MEM_MemtoReg), .EX_MEM_MemData(EX_MEM_MemData), .EX_MEM_RdAddr(EX_MEM_RdAddr), .EX_MEM_ALUOut(EX_MEM_ALUOut), .EX_MEM_flag_br_checker(EX_MEM_flag_br_checker), .EX_MEM_flags(EX_MEM_flags), .EX_MEM_hlt(EX_MEM_hlt));

ID_EX Inst2(.clk(clk), .rst_n(rst_n), .stall_data_miss(stall_data_miss), .opcode(opcode), .SrcData1(SrcData1), .SrcData2(SrcData2), .imm_4bit(imm_4bit), .sign_extend(sign_extend), .SrcReg1(SrcReg1), .SrcReg2(SrcReg2), .DstReg(DstReg), .ID_Flush(ID_Flush), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .IF_ID_next_pc(IF_ID_next_pc), .flag_br_checker(flag_br_checker), .IF_ID_hlt(IF_ID_hlt) , 
.ID_EX_RegWrite(ID_EX_RegWrite), .ID_EX_MemRead(ID_EX_MemRead), .ID_EX_MemWrite(ID_EX_MemWrite), .ID_EX_MemtoReg(ID_EX_MemtoReg), .ID_EX_RegVal1(ID_EX_SrcData1), .ID_EX_RegVal2(ID_EX_SrcData2), .ID_EX_sign_extend(ID_EX_sign_extend), .ID_EX_RsAddr(ID_EX_RsAddr), .ID_EX_RtAddr(ID_EX_RtAddr), .ID_EX_RdAddr(ID_EX_RdAddr), .ID_EX_imm_4bit(ID_EX_imm_4bit), .ID_EX_opcode(ID_EX_opcode), .ID_EX_next_pc(ID_EX_next_pc), .ID_EX_flag_br_checker(ID_EX_flag_br_checker), .ID_EX_hlt(ID_EX_hlt));

MEM_WB Inst4(.clk(clk), .rst_n(rst_n), .stall_data_miss(stall_data_miss), .EX_MEM_RegWrite(EX_MEM_RegWrite), .EX_MEM_MemtoReg(EX_MEM_MemtoReg), .EX_MEM_ALUOut(EX_MEM_ALUOut), .Dmem_out(Dmem_out), .EX_MEM_RdAddr(EX_MEM_RdAddr), .EX_MEM_flags(EX_MEM_flags), .EX_MEM_hlt(EX_MEM_hlt), .EX_MEM_flag_br_checker(EX_MEM_flag_br_checker),
.MEM_WB_RegWrite(MEM_WB_RegWrite), .MEM_WB_MemtoReg(MEM_WB_MemtoReg), .MEM_WB_ALUOut(MEM_WB_ALUOut), .MEM_WB_DmemOut(MEM_WB_DmemOut), .MEM_WB_RdAddr(MEM_WB_RdAddr), .MEM_WB_flags(MEM_WB_flags), .MEM_WB_hlt(MEM_WB_hlt), .MEM_WB_flag_br_checker(MEM_WB_flag_br_checker));

assign sign_extend = (opcode[3:1] == 3'b101) ? (opcode[0] ? {imm_8bit, {8{1'b0}}} : {{8{1'b0}}, imm_8bit}) : ((opcode[3:1] == 3'b100) ?  {{11{imm_4bit[3]}}, imm_4bit, 1'b0} : ID_EX_SrcData2);

///forwarding_unit
forwarding_unit forward(.ID_EX_Rs(ID_EX_RsAddr), .ID_EX_Rt(ID_EX_RtAddr), .MEM_WB_Rd(MEM_WB_RdAddr), .EX_MEM_Rd(EX_MEM_RdAddr),
                        .EX_MEM_RegWrite(EX_MEM_RegWrite), .EX_MEM_MemWrite(EX_MEM_MemWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite), .fwd_1(fwd_1), .fwd_2(fwd_2), .fwd_mux_mem(fwd_mux_mem));

///////////////////////  Phase III  ////////////////////////////////////////////////////////////////////////


assign miss_address = (miss_data_cache ? EX_MEM_ALUOut : miss_inst_cache ? pc : 16'h0000);
assign miss_detected = (miss_data_cache || miss_inst_cache) ? 1'b1 : 1'b0;
assign data_addr = !write_data_array_DM ? EX_MEM_ALUOut : memory_address;
assign inst_addr = (!write_data_array_IM) ? pc : memory_address;
assign DataIn_DA = (!miss_data_cache && EX_MEM_MemWrite) ? data_in : (miss_data_cache ? MCM_Data_Out : 16'h0000);

assign stall_inst_miss = fsm_busy & miss_inst_cache & !miss_data_cache;
assign stall_data_miss = (fsm_busy & miss_data_cache_pre) ? 1'b1 : 1'b0; 
assign Inst = ((fsm_busy || write_tag_array) & miss_inst_cache & !miss_data_cache) ? 16'h0000 : Inst_cache; //arbitration signal
assign miss_data_cache = (Inst != 16'h0000) ? (EX_MEM_MemRead | EX_MEM_MemWrite) ? miss_data_cache_pre : 1'b0 : 1'b0;

// Arbitration  
assign write_tag_array_DM = (miss_data_cache) ? write_tag_array : 1'b0;		
assign write_data_array_IM = (miss_data_cache) ? 1'b0 : write_data_array; 
assign write_tag_array_IM = (miss_data_cache) ? 1'b0 : write_tag_array;	
assign write_data_array_DM = (miss_data_cache) ? write_data_array : 1'b0;	
      


////  Multicycle memory  
memory4c MCM(.data_out(MCM_Data_Out), .data_in(data_in), .addr(main_memory_address), .enable(EX_MEM_MemRead || EX_MEM_MemWrite || (Inst_enable && miss_detected && !write_tag_array)), .wr(EX_MEM_MemWrite && !miss_data_cache), .clk(clk), .rst(~rst_n), .data_valid(memory_data_valid));

////   Inst Cache Block 
MDA_DA_Cache Inst_MDA_DA(.clk(clk), .rst(rst_n), .Data_Tag(pc[15:10]), .Shift_out(Shift_Out_Inst), .write_tag_array(write_tag_array_IM), .Mem_write(1'b0), .DataIn_DA(MCM_Data_Out), .write_data_array(write_data_array_IM), .miss_data_cache(miss_inst_cache), .data_addr(inst_addr), .DataOut_DA(Inst_cache));
Shifter_64bit shifter1(.address_in(pc), .Shift_Out(Shift_Out_Inst)); //blockenable shifter for data_cache unit

////   Data Cache Block 
MDA_DA_Cache Data_MDA_DA(.clk(clk), .rst(rst_n), .Data_Tag(EX_MEM_ALUOut[15:10]), .Shift_out(Shift_Out_Data), .write_tag_array(write_tag_array_DM), .Mem_write(EX_MEM_MemWrite), .DataIn_DA(DataIn_DA), .write_data_array(write_data_array_DM), .miss_data_cache(miss_data_cache_pre), .data_addr(data_addr), .DataOut_DA(Dmem_out));
Shifter_64bit shifter0(.address_in(EX_MEM_ALUOut), .Shift_Out(Shift_Out_Data)); //blockenable shifter for data_cache unit


//// Cache Miss Handler 
cache_fill_FSM CMC0(.clk(clk), .rst_n(rst_n), .miss_detected(miss_detected) , .miss_address(miss_address), .fsm_busy(fsm_busy), .write_data_array(write_data_array), .Write_addr(data_addr),
		.write_tag_array(write_tag_array), .main_memory_address(main_memory_address), .memory_address(memory_address), .memory_data_valid(memory_data_valid));



endmodule
