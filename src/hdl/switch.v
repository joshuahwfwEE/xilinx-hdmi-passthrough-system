`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////
////////
// Company:
// Engineer:
//
// Create Date: 2023/09/11 12:16:37
// Design Name:
// Module Name: switch
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////
////////
module switch(
input switch,

input wire [47:0] data1,
input wire user1,
input wire valid1,
input wire last1,
output wire ready1, 
input wire [47:0] data2,
input wire user2,
input wire valid2,
input wire last2,
output wire ready2, 
output wire [47:0] data_o,
output wire user_o,
output wire valid_o,
output wire last_o,
input wire ready_o
);
assign data_o = switch? data1 : data2;
assign user_o = switch? user1 : user2;
assign valid_o = switch? valid1 : valid2;
assign last_o =  switch? last1  : last2;
assign ready1 = switch? 1 : 0;
assign ready2 = switch? 0 : 1;
endmodule
