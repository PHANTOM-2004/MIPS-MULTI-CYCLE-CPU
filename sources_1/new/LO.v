`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:43:58
// Design Name: 
// Module Name: LO
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


module LO(
    input clk,
    input rst,
    input LO_in,
    input LO_out,
    input [31:0] data_in,
    output [31:0] data_out
    );
    reg [31:0] lo_reg;

    always@ (negedge clk or posedge rst) begin
        if(rst) lo_reg <= 32'h0;
        else if(LO_in) lo_reg <= data_in;
    end

    assign data_out = LO_out ? lo_reg : 32'h0;

endmodule
