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

/**** ID stage ****/

//control signal


/**** EX stage ****/

//control signal


/**** MEM stage ****/

//control signal


/**** WB stage ****/

//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(Add_pc.sum_o),
    .data1_i(EX_MEM.data_o[101:70]),
    .select_i(EX_MEM.data_o[104:104] & Mux_BranchType_MEM.data_o),
    .data_o()
);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),  
	.PCWrite_i(Hazard_ID.PCWrite_o),	
	.pc_in_i(Mux0.data_o) ,
	.pc_out_o() 
);

Instruction_Memory IM(
	.addr_i(PC.pc_out_o),
    .instr_o()
);
			
Adder Add_pc(
	.src1_i(32'd4),     
	.src2_i(PC.pc_out_o),     
	.sum_o()
);

		
Pipe_Reg_IF_ID #(.size(64)) IF_ID(     
	.clk_i(clk_i),
    .rst_i(rst_i),
    .ifid_Stall_i(Hazard_ID.ifid_Stall_o),
	.if_Flush_i(Hazard_ID.if_Flush_o),
    .data_i({Add_pc.sum_o, IM.instr_o}),
    .data_o()
);

//Instantiate the components in ID stage
Hazard Hazard_ID(
	.PCSrc_i(EX_MEM.data_o[104:104] & Mux_BranchType_MEM.data_o),
	.ifid_RsRt_i(IF_ID.data_o[25:16]),	
	.idex_Rt_i(ID_EX.data_o[9:5]),
	.idex_memRead_i(ID_EX.data_o[144]),
	.PCWrite_o(),
	.ifid_Stall_o(),
	.if_Flush_o(),
	.id_Flush_o(),
	.ex_Flush_o()
);

Reg_File RF(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(IF_ID.data_o[25:21]),
    .RTaddr_i(IF_ID.data_o[20:16]),
    .RDaddr_i(MEM_WB.data_o[4:0]),
    .RDdata_i(Mux3.data_o),
    .RegWrite_i(MEM_WB.data_o[70]),
    .RSdata_o(),
    .RTdata_o()
);

Decoder Control(
	.instr_op_i(IF_ID.data_o[31:26]), 
	.RegWrite_o(), 
	.ALU_op_o(), 
	.ALUSrc_o(),   
	.RegDst_o(),	
	.BranchType_o(),	
	.Branch_o(),	
	.MemRead_o(), 	
	.MemWrite_o(), 	
	.MemtoReg_o()	
);

MUX_2to1 #(.size(12)) Mux_ID(
	.data0_i({Control.RegWrite_o, Control.MemtoReg_o, Control.BranchType_o,Control.Branch_o, Control.MemRead_o, Control.MemWrite_o, Control.RegDst_o, Control.ALU_op_o, Control.ALUSrc_o}),
    .data1_i(12'd0),
    .select_i(Hazard_ID.id_Flush_o),
    .data_o()
);

Sign_Extend Sign_Extend(
	.data_i(IF_ID.data_o[15:0]),
    .data_o()
);	

Pipe_Reg #(.size(155)) ID_EX(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({IF_ID.data_o[25:21], Mux_ID.data_o, IF_ID.data_o[63:32], RF.RSdata_o,  RF.RTdata_o, Sign_Extend.data_o, IF_ID.data_o[20:16], IF_ID.data_o[15:11]}),	
    .data_o()
);

//Instantiate the components in EX stage	   

Shift_Left_Two_32 Shifter(
	.data_i(ID_EX.data_o[41:10]),
    .data_o()
);

ALU ALU(
	.src1_i(Mux_ForwardA.data_o),
	.src2_i(Mux1.data_o),
	.ctrl_i(ALU_Control.ALUCtrl_o),
	.result_o(),
	.zero_o()
);
		
ALU_Control ALU_Control(
	.funct_i(ID_EX.data_o[15:10]),   
    .ALUOp_i(ID_EX.data_o[141:139]),   
    .ALUCtrl_o() 
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(Mux_ForwardB.data_o),
    .data1_i(ID_EX.data_o[41:10]),
    .select_i(ID_EX.data_o[138:138]),
    .data_o()
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(ID_EX.data_o[9:5]),
    .data1_i(ID_EX.data_o[4:0]),
    .select_i(ID_EX.data_o[142:142]),
    .data_o()
);

MUX_2to1 #(.size(2)) Mux_EXFlush1(
	.data0_i(ID_EX.data_o[149:148]),
    .data1_i(2'd0),
    .select_i(Hazard_ID.ex_Flush_o),
    .data_o()
);

MUX_2to1 #(.size(5)) Mux_EXFlush2(
	.data0_i(ID_EX.data_o[147:143]),
    .data1_i(5'd0),
    .select_i(Hazard_ID.ex_Flush_o),
    .data_o()
);

MUX_4to1 #(.size(32)) Mux_ForwardA(
	.data0_i(ID_EX.data_o[105:74]),
    .data1_i(EX_MEM.data_o[68:37]),
	.data2_i(Mux3.data_o),
	.data3_i(Mux3.data_o),
    .select_i(Forward_EX.ForwardA),
    .data_o()
);

MUX_4to1 #(.size(32)) Mux_ForwardB(
	.data0_i(ID_EX.data_o[73:42]),
    .data1_i(EX_MEM.data_o[68:37]),
	.data2_i(Mux3.data_o),
	.data3_i(Mux3.data_o),
    .select_i(Forward_EX.ForwardB),
    .data_o()
);

Adder Add_pc_branch(
    .src1_i(ID_EX.data_o[137:106]),     
	.src2_i(Shifter.data_o),     
	.sum_o()
);

Forwarding Forward_EX(
	.idex_Rs(ID_EX.data_o[154:150]),
	.idex_Rt(ID_EX.data_o[9:5]),
	.exmem_Rd(EX_MEM.data_o[4:0]),
	.exmem_RegWrite(EX_MEM.data_o[108:108]),
	.memwb_Rd(MEM_WB.data_o[4:0]),
	.memwb_RegWrite(MEM_WB.data_o[70:70]),
	.ForwardA(),
	.ForwardB()
);

Pipe_Reg #(.size(109)) EX_MEM(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({Mux_EXFlush1.data_o, Mux_EXFlush2.data_o, Add_pc_branch.sum_o, ALU.zero_o, ALU.result_o, Mux_ForwardB.data_o, Mux2.data_o}),
    .data_o()
);

//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i),
    .addr_i(EX_MEM.data_o[68:37]),
    .data_i(EX_MEM.data_o[36:5]),
    .MemRead_i(EX_MEM.data_o[103:103]),
    .MemWrite_i(EX_MEM.data_o[102:102]),
    .data_o()
);

MUX_4to1 #(.size(1)) Mux_BranchType_MEM(
	.data0_i(EX_MEM.data_o[69]),	//beq
    .data1_i(EX_MEM.data_o[69] == 1'b0 && EX_MEM.data_o[68:37] == 32'd0),	//bgt
	.data2_i(EX_MEM.data_o[68:37] == 32'd0),	//bge
	.data3_i(~EX_MEM.data_o[69]),	//bne
    .select_i(EX_MEM.data_o[106:105]),
    .data_o()
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({EX_MEM.data_o[108:107], DM.data_o, EX_MEM.data_o[68:37], EX_MEM.data_o[4:0]}),
    .data_o()
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(MEM_WB.data_o[68:37]),
    .data1_i(MEM_WB.data_o[36:5]),
    .select_i(MEM_WB.data_o[69:69]),
    .data_o()
);

/****************************************
signal assignment
****************************************/

endmodule

