//吳禹璇 0516022

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:  Luke
//----------------------------------------------
//Date:  2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	BranchType_o,
	Branch_o,
	MemRead_o, 
	MemWrite_o, 
	MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output      RegWrite_o;
output [3-1:0] ALU_op_o;
output      ALUSrc_o;
output      RegDst_o;
output	[2-1:0]BranchType_o;
output      Branch_o;
output		MemRead_o;
output		MemWrite_o;
output		MemtoReg_o;
 
//Internal Signals
reg         RegWrite_o;
reg    [3-1:0] ALU_op_o;
reg         ALUSrc_o;
reg         RegDst_o;
reg		[2-1:0]BranchType_o;
reg         Branch_o;
reg			MemRead_o;
reg			MemWrite_o;
reg			MemtoReg_o;

//Parameter

//Main function
always@(instr_op_i) begin
	RegDst_o = 	(instr_op_i == 6'b000000) ? 1'b1 : 1'b0;
					
	MemtoReg_o = (instr_op_i == 6'b100011) ? 1'b0 : 1'b1;

	RegWrite_o = (instr_op_i == 6'b101011 || instr_op_i == 6'b000100 || instr_op_i == 6'b000010 || instr_op_i == 6'b000101 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111) ? 1'b0 : 1'b1;
				  		  
	ALU_op_o = (instr_op_i == 6'b000000) ? 3'b010 : //add,sub,and,or,slt,mult
					(instr_op_i == 6'b001000) ? 3'b100 : //addi
					(instr_op_i == 6'b001010 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111) ? 3'b101 : //slti,bge,bgt
					(instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 3'b000 : //lw,sw
					(instr_op_i == 6'b000100 || instr_op_i == 6'b000101) ? 3'b001 : 3'b110;//beq,bne

	ALUSrc_o = (instr_op_i == 6'b001000 ||		//addi
				instr_op_i == 6'b001010 ||		//slti
				instr_op_i == 6'b101011	||		//sw
				instr_op_i == 6'b100011) ? 1'b1 : 1'b0;	//lw
	
	BranchType_o = (instr_op_i == 6'b000101) ?	2'b11 :	//bne
					(instr_op_i == 6'b000001) ? 2'b10 :	//bge
					(instr_op_i == 6'b000111) ? 2'b01 :	2'b00 ;//bgt
						
	Branch_o = (instr_op_i == 6'b000100 ||	//beq
				instr_op_i == 6'b000101 ||	//bne
				instr_op_i == 6'b000001 ||	//bge
				instr_op_i == 6'b000111 ) ? 1'b1 : 1'b0;	//bgt
				
	MemWrite_o = (instr_op_i == 6'b101011) ? 1'b1 : 1'b0;
	
	MemRead_o = (instr_op_i == 6'b100011) ? 1'b1 : 1'b0;
	end 
endmodule



                    
                    