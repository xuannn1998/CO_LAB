//吳禹璇 0516022

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
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
    SignExt_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         SignExt_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            SignExt_o;

//Parameter

//Main function
always@(*) begin
    case (instr_op_i)
        //R-types: add, sub, and, or, slt
        6'b000000:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, SignExt_o} <= 8'b1_100_0101;
        //addi
        6'b001000:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, SignExt_o} <= 8'b1_000_1001;
        //beq
        6'b000100:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, SignExt_o} <= 8'b0_001_0x11;
        //slti
        6'b001010:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, SignExt_o} <= 8'b1_010_1001;
        default:
            {RegWrite_o, ALU_op_o, ALUSrc_o, RegDst_o, Branch_o, SignExt_o} <= 8'bxxxxxxxx;
    endcase
end


endmodule        
                    