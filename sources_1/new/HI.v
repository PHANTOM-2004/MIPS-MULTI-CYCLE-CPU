`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:43:47
// Design Name: 
// Module Name: HI
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


module HI(
    input clk,
    input rst,
    input HI_in,
    input HI_out,
    input [31:0] data_in,
    output [31:0] data_out
    );

    reg [31:0] hi_reg;
    
    assign data_out = HI_out ? hi_reg : 32'h0;

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            hi_reg <= 32'h0;
        end
        else if(HI_in) hi_reg <=data_in;
    end

endmodule
