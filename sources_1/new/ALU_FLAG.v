`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/09 15:35:01
// Design Name: 
// Module Name: ALU_FLAG
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


module ALU_FLAG(
    input clk,
    input rst,
    input zero,
    input carry,
    input write,
    input negative,
    input overflow,
    output zero_r,
    output negative_r,
    output overflow_r,
    output carry_r //
    );
    reg zero_reg, carry_reg, overflow_reg, negative_reg;

    always @(negedge clk or posedge rst) begin
        if(rst) begin
            zero_reg <= 0;
            carry_reg <= 0;
            overflow_reg <= 0;
            negative_reg <= 0;
        end
        else if(write) begin
            zero_reg <= zero;
            carry_reg <= carry;
            overflow_reg <= overflow;
            negative_reg <= negative;
        end
    end

    assign zero_r = zero_reg;
    assign carry_r = carry_reg;
    assign overflow_r = overflow_reg;
    assign negative_r = negative_reg;

endmodule
