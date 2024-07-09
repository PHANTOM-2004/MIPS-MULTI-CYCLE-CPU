`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/07 16:33:58
// Design Name: 
// Module Name: CLZ
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


module CLZ(
    input clk,
    input rst,
    input start,
    input [31:0] clz_data_in,
    output [31:0] clz_ans_out,
    output reg busy
    );

    reg [4:0] cnt;
    reg [4:0] pos;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            cnt     <= 5'b0;
            pos     <= 5'b11111;
            busy    <= 1'b0;
        end
        else if(start)begin
            busy    <= 1'b1;
            cnt     <= 5'b0;
            pos     <= 5'b11111;
        end
        else begin
            if(clz_data_in[pos] || !pos) busy <= 0;
            else  begin 
                cnt <= cnt + 1;
                pos <= pos - 1;
            end
        end
    end

    assign clz_ans_out = cnt;

endmodule
