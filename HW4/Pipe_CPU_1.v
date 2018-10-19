//吳禹璇 0516022

`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
//pc
wire [31:0] pc;
wire [31:0] pc_back;
wire [31:0] pc_next_1;
wire [31:0] pc_branch_1;
//im
wire [31:0] instr_1;

/**** ID stage ****/
//pc
wire [31:0] pc_next_2;
wire [31:0] pc_branch_2;
//im
wire [31:0] instr_2;
//reg
wire [31:0] read_data1_2;
wire [31:0] read_data2_2;
//sign ex
wire [31:0] imm_2;

//control signal
wire [2:0] ALU_op_2;
wire       ALUSrc_2;
wire       reg_dst_2;
wire       reg_write_2;
wire       branch_2;
wire       MemRead_2;
wire       MemWrite_2;
wire       MemToReg_2;

/**** EX stage ****/
//pc
wire [31:0] pc_next_3;
wire [31:0] pc_branch_3;
//im
wire [31:0] instr_3;
//reg
wire [31:0] read_data1_3;
wire [31:0] read_data2_3;
wire [4:0] write_reg_3;
//sign ex
wire [31:0] imm_3;
//alu
wire [31:0] Mux_ALUSrc_o;
wire [31:0] result_3;
wire zero_3;
//alu_ctrl
wire [3:0] ALU_control;
//shift
wire [31:0] imm_sl2;

//control signal
wire [2:0] ALU_op_3;
wire       ALUSrc_3;
wire       reg_dst_3;
wire       reg_write_3;
wire       branch_3;
wire       MemRead_3;
wire       MemWrite_3;
wire       MemToReg_3;

/**** MEM stage ****/
//pc
wire [31:0] pc_branch_4;
//reg
wire [31:0] read_data2_4;
wire [4:0] write_reg_4;
//alu
wire [31:0] result_4;
wire zero_4;
//data mem
wire [31:0] dm_4;

//control signal
wire       reg_write_4;
wire       branch_4;
wire       MemRead_4;
wire       MemWrite_4;
wire       MemToReg_4;

/**** WB stage ****/
//reg
wire [4:0] write_reg_5;
//alu
wire [31:0] result_5;
//data mem
wire [31:0] dm_5;
wire [31:0] Mux_DM_o;

//control signal
wire       reg_write_5;
wire       MemToReg_5;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
        .data0_i(pc_next_1),
        .data1_i(pc_branch_4),
        .select_i(branch_4 & zero_4),
        .data_o(pc_back)
        );

ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_back),
        .pc_out_o(pc)
        );

Instruction_Memory IM(
        .addr_i(pc),
        .instr_o(instr_1)    
        );
			
Adder Add_pc(
        .src1_i(32'd4),     
        .src2_i(pc),     
        .sum_o(pc_next_1)
        );

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({pc_next_1, instr_1}),
        .data_o({pc_next_2, instr_2})
        );

//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(instr_2[25:21]) ,  
        .RTaddr_i(instr_2[20:16]) ,  
        .RDaddr_i(write_reg_5) ,  
        .RDdata_i(Mux_DM_o)  , 
        .RegWrite_i(reg_write_5),
        .RSdata_o(read_data1_2) ,  
        .RTdata_o(read_data2_2)   
        );

Decoder Control(
        .instr_op_i(instr_2[31:26]), 
        .RegWrite_o(reg_write_2), 
        .ALU_op_o(ALU_op_2),   
        .ALUSrc_o(ALUSrc_2),
        .RegDst_o(reg_dst_2),   
        .Branch_o(branch_2),
        .MemRead_o(MemRead_2),
        .MemWrite_o(MemWrite_2),
        .MemToReg_o(MemToReg_2)
        );

Sign_Extend Sign_Extend(
        .data_i(instr_2[15:0]),
        .data_o(imm_2)
        );	

Pipe_Reg #(.size(148)) ID_EX(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({reg_write_2, MemToReg_2, branch_2, MemRead_2, MemWrite_2, reg_dst_2, ALU_op_2, ALUSrc_2, pc_next_2, read_data1_2, read_data2_2, imm_2, instr_2[20:16], instr_2[15:11]}),
        .data_o({reg_write_3, MemToReg_3, branch_3, MemRead_3, MemWrite_3, reg_dst_3, ALU_op_3, ALUSrc_3, pc_next_3, read_data1_3, read_data2_3, imm_3, instr_3[20:16], instr_3[15:11]})
        );

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
        .data_i(imm_3),
        .data_o(imm_sl2)
        );

ALU ALU(
        .src1_i(read_data1_3),
        .src2_i(Mux_ALUSrc_o),
        .ctrl_i(ALU_control),
        .result_o(result_3),
        .zero_o(zero_3)
        );
		
ALU_Ctrl ALU_Control(
        .funct_i(imm_3[5:0]),   
        .ALUOp_i(ALU_op_3),   
        .ALUCtrl_o(ALU_control) 
        );

MUX_2to1 #(.size(32)) Mux1(
        .data0_i(read_data2_3),
        .data1_i(imm_3),
        .select_i(ALUSrc_3),
        .data_o(Mux_ALUSrc_o)
        );
		
MUX_2to1 #(.size(5)) Mux2(
        .data0_i(instr_3[20:16]),
        .data1_i(instr_3[15:11]),
        .select_i(reg_dst_3),
        .data_o(write_reg_3)
        );

Adder Add_pc_branch(
        .src1_i(imm_sl2),     
        .src2_i(pc_next_3),     
        .sum_o(pc_branch_3)      
        );

Pipe_Reg #(.size(107)) EX_MEM(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({reg_write_3, MemToReg_3, branch_3, MemRead_3, MemWrite_3, pc_branch_3, zero_3, result_3, read_data2_3, write_reg_3}),
        .data_o({reg_write_4, MemToReg_4, branch_4, MemRead_4, MemWrite_4, pc_branch_4, zero_4, result_4, read_data2_4, write_reg_4})
        );


//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(result_4),
        .data_i(read_data2_4),
        .MemRead_i(MemRead_4),
        .MemWrite_i(MemWrite_4),
        .data_o(dm_4)
        );

Pipe_Reg #(.size(71)) MEM_WB(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({reg_write_4, MemToReg_4, dm_4, result_4, write_reg_4}),
        .data_o({reg_write_5, MemToReg_5, dm_5, result_5, write_reg_5})
        );

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
        .data0_i(result_5),
        .data1_i(dm_5),
        .select_i(MemToReg_5),
        .data_o(Mux_DM_o)
        );

/****************************************
signal assignment
****************************************/

endmodule

