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
    MemRead_o,
    MemWrite_o,
    MemToReg_o
    );
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemRead_o;
output         MemWrite_o;
output         MemToReg_o;

//Internal Signals
reg         RegWrite_o;
reg [3-1:0] ALU_op_o;
reg         ALUSrc_o;
reg         RegDst_o;
reg         Branch_o;
reg         MemRead_o;
reg         MemWrite_o;
reg         MemToReg_o;

//Main Function
always@(*) begin
    case(instr_op_i)
    	6'b000000: begin //R-type
		RegDst_o = 1;
		ALUSrc_o = 0;	
		MemToReg_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;	
		ALU_op_o = 3'b100;
		RegWrite_o = 1;
	end
	6'b001000: begin //addi
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemToReg_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 1;
	end
	6'b001010: begin //slti
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemToReg_o = 0;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b010;
		RegWrite_o = 1;
	end
	6'b000100: begin //beq
		RegDst_o = RegDst_o; 
		ALUSrc_o = 0;
		MemToReg_o = MemToReg_o;
		MemRead_o = 0;
		MemWrite_o = 0;
		Branch_o = 1;
		ALU_op_o = 3'b001;
		RegWrite_o = 0;
	end
	6'b100011: begin //lw
		RegDst_o = 0;
		ALUSrc_o = 1;
		MemToReg_o = 1;
		MemRead_o = 1;
		MemWrite_o = 0;
		Branch_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 1;
	end
	6'b101011: begin //sw
		RegDst_o = RegDst_o;
		ALUSrc_o = 1;
		MemToReg_o = MemToReg_o;
		MemRead_o = 0;
		MemWrite_o = 1;
		Branch_o = 0;
		ALU_op_o = 3'b000;
		RegWrite_o = 0;
	end

   endcase
end 

endmodule
                    