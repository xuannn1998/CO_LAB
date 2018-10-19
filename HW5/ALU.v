//吳禹璇 0516022 

//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:  Luke
//----------------------------------------------
//Date:  2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
wire             zero_o;
//Parameter

assign zero_o = (result_o==0);

//Main function
always@(*)begin
	case(ctrl_i)
		0: result_o <= src1_i & src2_i;	//and
		1: result_o <= src1_i | src2_i;	//or
		2: result_o <= src1_i + src2_i;	//add,addi,lw,sw
		6: result_o <= src1_i - src2_i;	//sub,beq
		7: result_o <= (src1_i - src2_i) >= 32'h8000 ? 1 : 0;	//slt,slti
		9: result_o <= src1_i * src2_i; //mult
		default: result_o <= 0;
	endcase
end

endmodule





                    
                    