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
wire [31:0] j_out;
wire [31:0] jr_out;
//instruction mem
wire [31:0] instr;
//reg file
wire [31:0] read_data1;
wire [31:0] read_data2;
wire [4:0] write_reg;
//shift left
wire [31:0] imm;
wire [31:0] imm_sl2;
//alu
wire [31:0] Mux_ALUSrc_o;
wire [31:0] result;
wire zero;
//alu_ctrl
wire [3:0] ALU_control;
//decoder
wire [2:0] ALU_op;
wire       ALUSrc;
wire [1:0] reg_dst;
wire       reg_write;
wire       branch;
wire [1:0] BranchType;
wire       jump;
wire       MemRead;
wire       MemWrite;
wire [1:0] MemToReg;
//data mem
wire [31:0] dm;
wire [31:0] Mux_DM_o;
wire        sign_ext;

wire jr;
assign jr = (instr[31:26] == 6'b000000 && instr[20:0] == 21'd8) ? 1'b1 : 1'b0;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_back),
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

MUX_4to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
        .data3_i(5'd31),
        .select_i(reg_dst),
        .data_o(write_reg)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(write_reg) ,  
        .RDdata_i(Mux_DM_o)  , 
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
        .BranchType_o(BranchType),
        .Jump_o(jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemToReg_o(MemToReg)
        );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_control) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(imm)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data2),
        .data1_i(imm),
        .select_i(ALUSrc),
        .data_o(Mux_ALUSrc_o)
        );	
		
ALU alu(
        .src1_i(read_data1),
        .src2_i(Mux_ALUSrc_o),
        .ctrl_i(ALU_control),
        .result_o(result),
        .zero_o(zero)
        );

MUX_4to1 #(.size(32)) Mux_Data_Memory(
        .data0_i(result),
        .data1_i(dm),
        .data2_i(pc_next),
        .data3_i(pc_next),
        .select_i(MemToReg),
        .data_o(Mux_DM_o)
        );
	
Data_Memory Data_Memory(
	    .clk_i(clk_i),
            .addr_i(result),
            .data_i(read_data2),
            .MemRead_i(MemRead),
            .MemWrite_i(MemWrite),
            .data_o(dm)
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
        .data_o(j_out)
        );

MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(j_out),
        .data1_i({pc_next[31:28], instr[25:0],2'b00}),
        .select_i(jump),
        .data_o(jr_out)
        );

MUX_2to1 #(.size(32)) Mux_Jr(
        .data0_i(jr_out),
        .data1_i(read_data1),
        .select_i(jr),
        .data_o(pc_back)
        );

endmodule