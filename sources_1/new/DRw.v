`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:52:59
// Design Name: 
// Module Name: DR
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


module DRw(
    input clk,
    input rst,
    input DRw_in, 
    input DRw_out,
    input [31:0] DRw_wdata,
    output [31:0] DRw_rdata
    );

    reg [31:0] DRw_reg;


    always@(negedge clk or posedge rst) begin
        if(rst) DRw_reg <= 32'h0;
        else if(DRw_in) DRw_reg <= DRw_wdata;
    end

    assign DRw_rdata = DRw_out ? DRw_reg : 32'h0;
endmodule
