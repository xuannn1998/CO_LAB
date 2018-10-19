//吳禹璇 0516022

//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
	);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

//pc
wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] pc_back;
wire [31:0] pc_branch;
//instruction mem
wire [31:0] instr;
//reg file
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [4:0] write_reg1;
//shift left
wire [31:0] imm;
wire [31:0] imm_sl2;

wire [31:0] Mux_ALUSrc_w;
wire [31:0] result;

wire [3:0] ALU_control;
wire [2:0] ALU_op;

wire reg_dst;
wire reg_write;
wire branch;
wire ALUSrc;
wire zero;
wire sign_ext;


//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i (rst_i),     
	.pc_in_i(pc_back) ,   
	.pc_out_o(pc) 
	);
	
Adder Adder1(
        .src1_i(32'd4),     
	.src2_i(pc),     
	.sum_o(pc_next)    
	);
	
Instr_Memory IM(
        .pc_addr_i(pc),  
	.instr_o(instr)   
	);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(reg_dst),
        .data_o(write_reg1)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_reg1) ,  
        .RDdata_i(result)  , 
        .RegWrite_i(reg_write),
        .RSdata_o(read_data1) ,  
        .RTdata_o(read_data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]),
        .RegWrite_o(reg_write),
        .ALU_op_o(ALU_op),
        .ALUSrc_o(ALUSrc),
        .RegDst_o(reg_dst),
        .Branch_o(branch),
        .SignExt_o(sign_ext)   //extra control signal(is not on the diagram)
	);

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_control) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(imm),
        .select_i(sign_ext)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data2),
        .data1_i(imm),
        .select_i(ALUSrc),
        .data_o(Mux_ALUSrc_w)
        );	
		
ALU alu(
        .src1_i(read_data1),
	.src2_i(Mux_ALUSrc_w),
        .ctrl_i(ALU_control),
	.result_o(result),
	.zero_o(zero)
	);
		
Adder Adder2(
        .src1_i(imm_sl2),     
	.src2_i(pc_next),     
	.sum_o(pc_branch)      
	);
		
Shift_Left_Two_32 Shifter(
        .data_i(imm),
        .data_o(imm_sl2)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next),
        .data1_i(pc_branch),
        .select_i(branch & zero),
        .data_o(pc_back)
        );	

endmodule
