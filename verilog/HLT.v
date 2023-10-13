module HLT(
    input [3:0] opcode,
	output stop
);
    
	assign stop =(opcode == 3'b111) ? 1 : 0;
        
            
               
            
endmodule
