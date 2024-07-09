`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 20:25:17
// Design Name: 
// Module Name: IR
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


module IR(
    input clk,
    input rst,
    input IR_in,
    input IR_out,
    input [31:0]IR_wdata,
    output [31:0]IR_rdata
    );

    reg [31:0] IR_reg;

    always @(negedge clk or posedge rst) begin
        if(rst) IR_reg <= 32'b0;
        else if(IR_in) IR_reg <= IR_wdata;
    end

    assign IR_rdata = IR_out ? IR_reg : 32'b0;

endmodule
