`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:57:06
// Design Name: 
// Module Name: DRr
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


module DRr(
    input clk,
    input rst,
    input DRr_in,
    input DRr_out,
    input [31:0] DRr_wdata,
    output [31:0] DRr_rdata
    );
    reg [31:0] DRr_reg;

    always @(negedge clk or posedge rst) begin
        if(rst) DRr_reg <= 32'h0;
        else if(DRr_in) DRr_reg <= DRr_wdata;
    end

    assign DRr_rdata = DRr_out ? DRr_reg : 32'h0;
endmodule
