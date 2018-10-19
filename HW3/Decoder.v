//吳禹璇 0516022

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
    RegWrite_o,
    ALU_op_o,
    ALUSrc_o,
    RegDst_o,
    Branch_o,
    BranchType_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
    MemToReg_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [2-1:0] RegDst_o;
output         Branch_o;
output [2-1:0] BranchType_o;
output         Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [2-1:0] MemToReg_o;

//Internal Signals
reg         RegWrite_o;
reg [3-1:0] ALU_op_o;
reg         ALUSrc_o;
reg [2-1:0] RegDst_o;
reg         Branch_o;
reg [2-1:0] BranchType_o;
reg         Jump_o;
reg         MemRead_o;
reg         MemWrite_o;
reg [2-1:0] MemToReg_o;

//Main Function
always@(*) begin
    case(instr_op_i)
    	6'b000000: begin //R-type
		RegDst_o = 2'b01;
		ALUSrc_o = 0;	
		MemToReg_o = 2'b00;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;	
		BranchType_o = 0;
		ALU_op_o = 3'b100;
		RegWrite_o = 1;
		Jump_o = 0;
	end
	6'b001000: begin //addi
		RegDst_o = 2'b00;
		ALUSrc_o = 1;
		MemToReg_o = 2'b00;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 1;
		Jump_o = 0;
	end
	6'b001010: begin //slti
		RegDst_o = 2'b00;
		ALUSrc_o = 1;
		MemToReg_o = 2'b00;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = 3'b010;
		RegWrite_o = 1;
		Jump_o = 0;
	end
	6'b000100: begin //beq
		RegDst_o = RegDst_o; 
		ALUSrc_o = 0;
		MemToReg_o = MemToReg_o;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 1;
		BranchType_o = 0;
		ALU_op_o = 3'b001;
		RegWrite_o = 0;
		Jump_o = 0;
	end
	6'b100011: begin //lw
		RegDst_o = 2'b00;
		ALUSrc_o = 1;
		MemToReg_o = 2'b01;
		MemRead_o = 1;
		MemWrite_o = 0;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 1;
		Jump_o = 0;
	end
	6'b101011: begin //sw
		RegDst_o = RegDst_o;
		ALUSrc_o = 1;
		MemToReg_o = MemToReg_o;
		MemRead_o = 0;
		MemWrite_o = 1;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 0;
		Jump_o = 0;
	end
	6'b000010: begin //jump
		RegDst_o = RegDst_o;
		ALUSrc_o = 0;
		MemToReg_o = MemToReg_o;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = ALU_op_o;
		RegWrite_o = 0;
		Jump_o = 1;
	end
	6'b000011: begin //jal
		RegDst_o = 2'b10;
		ALUSrc_o = 0;
		MemToReg_o = 2'b11;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		BranchType_o = 0;
		ALU_op_o = ALU_op_o;
		RegWrite_o = 1;
		Jump_o = 1;
	end
   endcase
end 

endmodule
                    