`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:29:44
// Design Name: 
// Module Name: Z
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


module Z(
    input clk,
    input rst,
    input Z_in,
    input Z_out,
    input [31:0]Z_wdata,
    output [31:0]Z_rdata
    );
    reg [31:0] d;

    assign Z_rdata = Z_out ? d : 32'h0;

    always @(negedge clk or posedge rst) begin
        if(rst)  d <= 32'h0;
        else if(Z_in) d <= Z_wdata;
    end
endmodule
