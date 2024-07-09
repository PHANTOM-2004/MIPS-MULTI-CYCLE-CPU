`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 20:42:59
// Design Name: 
// Module Name: T_STATUS
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


module T_STATUS(
    input clk,
    input rst,
    input t_status_in,
    input t_status_out,
    input [31:0]  wdata,
    output [31:0] rdata
    );
    reg [31:0]t_status_reg;

    always @(negedge clk or posedge rst) begin
        if(rst) t_status_reg <= 32'h0;
        else if(t_status_in) t_status_reg <= wdata;
    end

    assign rdata = t_status_out ? t_status_reg : 32'h0;

endmodule
