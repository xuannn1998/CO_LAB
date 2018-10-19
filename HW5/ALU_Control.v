//吳禹璇 0516022

//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:  Luke
//----------------------------------------------
//Date:  2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Control(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation
always@(funct_i, ALUOp_i)begin
	ALUCtrl_o = ({ALUOp_i,funct_i} == 9'b010_100000 || ALUOp_i == 3'b000 || ALUOp_i == 3'b100 ) ? 4'b0010 : //add addi lw sw
				({ALUOp_i,funct_i} == 9'b010_100010 || ALUOp_i == 3'b001 ) ? 4'b0110 : //sub beq bne
				({ALUOp_i,funct_i} == 9'b010_100100) ? 4'b0000 : //and
				({ALUOp_i,funct_i} == 9'b010_100101) ? 4'b0001 : //or
				({ALUOp_i,funct_i} == 9'b010_101010 || ALUOp_i == 3'b101) ? 4'b0111 : //slt slti bgt bge
				({ALUOp_i,funct_i} == 9'b010_011000) ? 4'b1001 : 4'b1111 ; //mult
end //end always
endmodule     





                    
                    