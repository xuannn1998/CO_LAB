`timescale 1ns/1ps

//ID: 0516022

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           cout;
reg           a, b;

always@(*)
begin
  a = src1 ^ A_invert;
  b = src2 ^ B_invert;

   case(operation[1:0])
    4'b00: begin result = a & b; cout = 0; end //and, nor
    4'b01: begin result = a | b; cout = 0; end //or
    4'b10: begin result = (a^b)^cin; cout = (a&b)|(a&cin)|(b&cin); end // add, sub
    4'b11: begin result = less; cout = (a&b)|(a&cin)|(b&cin); end //slt
  endcase
end

endmodule
