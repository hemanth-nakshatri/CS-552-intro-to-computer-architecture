module CPU_control(opcode, halt, RegDst, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite, Lower, Higher, BEn, Br, PCS);

input [15:12] opcode;
output halt, RegDst, ALUSrc, MemRead, MemWrite, MemtoReg, RegWrite, Lower, Higher, BEn, Br, PCS;

reg reg_hlt, reg_RegDst, reg_ALUSrc, reg_MemRead, reg_Memwrite, reg_MemtoReg, reg_RegWrite, reg_Lower, reg_Higher, reg_BEn, reg_Br, reg_PCS;
always @(*) begin
  casex (opcode)
  4'b00??: begin        //ADD, SUB, XOR, RED
    assign reg_hlt = 0;
    assign reg_RegDst = 1;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b0111: begin        //PADDSB
    assign reg_hlt = 0;
    assign reg_RegDst = 1;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b01??: begin        //SLL. SRA. ROR
    assign reg_hlt = 0;
    assign reg_RegDst = 1;
    assign reg_ALUSrc = 1;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1000: begin        //LW
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 1;
    assign reg_MemRead = 1;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 1;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1001: begin        //SW
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 1;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 1;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 0;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1010: begin        //LLB
    assign reg_hlt = 0;
    assign reg_RegDst = 1;
    assign reg_ALUSrc = 1;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 1;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1011: begin        //LHB
    assign reg_hlt = 0;
    assign reg_RegDst = 1;
    assign reg_ALUSrc = 1;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 1;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1100: begin        //B
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 0;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 1;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  4'b1101: begin        //BR
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 0;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 1;
    assign reg_Br = 1;
    assign reg_PCS = 0;
  end
  4'b1110: begin        //PCS
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 1;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 1;
  end
  4'b1111: begin        //HLT
    assign reg_hlt = 1;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 0;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
    default: begin       
    assign reg_hlt = 0;
    assign reg_RegDst = 0;
    assign reg_ALUSrc = 0;
    assign reg_MemRead = 0;
    assign reg_Memwrite = 0;
    assign reg_MemtoReg = 0;
    assign reg_RegWrite = 0;
    assign reg_Lower = 0;
    assign reg_Higher = 0;
    assign reg_BEn = 0;
    assign reg_Br = 0;
    assign reg_PCS = 0;
  end
  endcase
end

assign halt = reg_hlt;
assign RegDst = reg_RegDst;
assign ALUSrc = reg_ALUSrc;
assign MemRead = reg_MemRead;
assign MemWrite = reg_Memwrite;
assign MemtoReg = reg_MemtoReg;
assign RegWrite = reg_RegWrite;
assign Lower = reg_Lower;
assign Higher = reg_Higher;
assign BEn = reg_BEn;
assign Br = reg_Br;
assign PCS = reg_PCS;

endmodule