module PCS(
    input [3:0] opcode,
    input [3:0] rd, // Destination register
    input [15:0] pc,
	//for now just displaying output pc
	output [15:0] pcs
);  
        
                // Increment PC by 2 and save it to the specified register
                assign  pcs = pcs + 2;
                // Store the result in the destination register rd			
                
                // reg_file[rd] <= next_pc;
            
endmodule
