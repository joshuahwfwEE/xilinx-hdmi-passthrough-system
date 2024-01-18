`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: e-element
// Engineer: Jyun Teng Huang
// 
// Create Date: 2022/11/28 16:56:45
// Design Name: cec
// Module Name: cec
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
//////////////////////////////////////////////////////////////////////////////////


module cec ( cec_clk_in, rst_n, cec_out);
    
    input cec_clk_in, rst_n;
    output reg cec_out;
    
    reg [16:0] cnt;
    
    always @ ( posedge cec_clk_in or negedge rst_n ) begin
        if( ~rst_n ) begin
            cnt <= 14'd0;
            cec_out <= 1'd0;
        end
        else if( cnt == 17'd50000 ) begin
            cec_out = ~cec_out;
            cnt <= 14'd0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end
    end
    
endmodule

