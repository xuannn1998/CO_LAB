`timescale 1ns/1ps

//ID: 0516022

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

wire [32-1:0] tmp_cout;
wire [32-1:0] tmp_result;

wire less_input;
assign less_input = (src1[31]) ^ (~src2[31]) ^ (tmp_cout[30]);

alu_top alu00(src1[0], src2[0], less_input, ALU_control[3], ALU_control[2], ALU_control[3] ^ ALU_control[2], ALU_control[1:0], tmp_result[0], tmp_cout[0]);
alu_top alu01(src1[1], src2[1], 0, ALU_control[3], ALU_control[2], tmp_cout[0], ALU_control[1:0], tmp_result[1], tmp_cout[1]);
alu_top alu02(src1[2], src2[2], 0, ALU_control[3], ALU_control[2], tmp_cout[1], ALU_control[1:0], tmp_result[2], tmp_cout[2]);
alu_top alu03(src1[3], src2[3], 0, ALU_control[3], ALU_control[2], tmp_cout[2], ALU_control[1:0], tmp_result[3], tmp_cout[3]);
alu_top alu04(src1[4], src2[4], 0, ALU_control[3], ALU_control[2], tmp_cout[3], ALU_control[1:0], tmp_result[4], tmp_cout[4]);
alu_top alu05(src1[5], src2[5], 0, ALU_control[3], ALU_control[2], tmp_cout[4], ALU_control[1:0], tmp_result[5], tmp_cout[5]);
alu_top alu06(src1[6], src2[6], 0, ALU_control[3], ALU_control[2], tmp_cout[5], ALU_control[1:0], tmp_result[6], tmp_cout[6]);
alu_top alu07(src1[7], src2[7], 0, ALU_control[3], ALU_control[2], tmp_cout[6], ALU_control[1:0], tmp_result[7], tmp_cout[7]);
alu_top alu08(src1[8], src2[8], 0, ALU_control[3], ALU_control[2], tmp_cout[7], ALU_control[1:0], tmp_result[8], tmp_cout[8]);
alu_top alu09(src1[9], src2[9], 0, ALU_control[3], ALU_control[2], tmp_cout[8], ALU_control[1:0], tmp_result[9], tmp_cout[9]);
alu_top alu10(src1[10], src2[10], 0, ALU_control[3], ALU_control[2], tmp_cout[9], ALU_control[1:0], tmp_result[10], tmp_cout[10]);
alu_top alu11(src1[11], src2[11], 0, ALU_control[3], ALU_control[2], tmp_cout[10], ALU_control[1:0], tmp_result[11], tmp_cout[11]);
alu_top alu12(src1[12], src2[12], 0, ALU_control[3], ALU_control[2], tmp_cout[11], ALU_control[1:0], tmp_result[12], tmp_cout[12]);
alu_top alu13(src1[13], src2[13], 0, ALU_control[3], ALU_control[2], tmp_cout[12], ALU_control[1:0], tmp_result[13], tmp_cout[13]);
alu_top alu14(src1[14], src2[14], 0, ALU_control[3], ALU_control[2], tmp_cout[13], ALU_control[1:0], tmp_result[14], tmp_cout[14]);
alu_top alu15(src1[15], src2[15], 0, ALU_control[3], ALU_control[2], tmp_cout[14], ALU_control[1:0], tmp_result[15], tmp_cout[15]);
alu_top alu16(src1[16], src2[16], 0, ALU_control[3], ALU_control[2], tmp_cout[15], ALU_control[1:0], tmp_result[16], tmp_cout[16]);
alu_top alu17(src1[17], src2[17], 0, ALU_control[3], ALU_control[2], tmp_cout[16], ALU_control[1:0], tmp_result[17], tmp_cout[17]);
alu_top alu18(src1[18], src2[18], 0, ALU_control[3], ALU_control[2], tmp_cout[17], ALU_control[1:0], tmp_result[18], tmp_cout[18]);
alu_top alu19(src1[19], src2[19], 0, ALU_control[3], ALU_control[2], tmp_cout[18], ALU_control[1:0], tmp_result[19], tmp_cout[19]);
alu_top alu20(src1[20], src2[20], 0, ALU_control[3], ALU_control[2], tmp_cout[19], ALU_control[1:0], tmp_result[20], tmp_cout[20]);
alu_top alu21(src1[21], src2[21], 0, ALU_control[3], ALU_control[2], tmp_cout[20], ALU_control[1:0], tmp_result[21], tmp_cout[21]);
alu_top alu22(src1[22], src2[22], 0, ALU_control[3], ALU_control[2], tmp_cout[21], ALU_control[1:0], tmp_result[22], tmp_cout[22]);
alu_top alu23(src1[23], src2[23], 0, ALU_control[3], ALU_control[2], tmp_cout[22], ALU_control[1:0], tmp_result[23], tmp_cout[23]);
alu_top alu24(src1[24], src2[24], 0, ALU_control[3], ALU_control[2], tmp_cout[23], ALU_control[1:0], tmp_result[24], tmp_cout[24]);
alu_top alu25(src1[25], src2[25], 0, ALU_control[3], ALU_control[2], tmp_cout[24], ALU_control[1:0], tmp_result[25], tmp_cout[25]);
alu_top alu26(src1[26], src2[26], 0, ALU_control[3], ALU_control[2], tmp_cout[25], ALU_control[1:0], tmp_result[26], tmp_cout[26]);
alu_top alu27(src1[27], src2[27], 0, ALU_control[3], ALU_control[2], tmp_cout[26], ALU_control[1:0], tmp_result[27], tmp_cout[27]);
alu_top alu28(src1[28], src2[28], 0, ALU_control[3], ALU_control[2], tmp_cout[27], ALU_control[1:0], tmp_result[28], tmp_cout[28]);
alu_top alu29(src1[29], src2[29], 0, ALU_control[3], ALU_control[2], tmp_cout[28], ALU_control[1:0], tmp_result[29], tmp_cout[29]);
alu_top alu30(src1[30], src2[30], 0, ALU_control[3], ALU_control[2], tmp_cout[29], ALU_control[1:0], tmp_result[30], tmp_cout[30]);
alu_top alu31(src1[31], src2[31], 0, ALU_control[3], ALU_control[2], tmp_cout[30], ALU_control[1:0], tmp_result[31], tmp_cout[31]);


always@(posedge clk or negedge rst_n) 
begin
    cout = 1'b0;
    zero = 1'b0;
    if(rst_n) begin 
    result = tmp_result;
      if(ALU_control[1:0] == 2'b10) begin
         cout = (tmp_cout == 1'b0)?0:1;
      end
      if(result == 0) begin
          zero = 1;
      end
    overflow = (tmp_cout[30] ^ tmp_cout[31]);
    end
end

endmodule
