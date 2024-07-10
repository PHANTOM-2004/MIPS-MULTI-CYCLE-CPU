`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/07 21:00:11
// Design Name: 
// Module Name: CP0
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


module CP0(
    input clk,
    input rst,
    input [4:0] Rdaddr_r,
    input [4:0] Rdaddr_w,
    input w, //high = read, low = right
    input r,
    input  [31:0] wdata,
    input  [2:0]  sel,
    output reg [31:0] rdata
    );

    // 根据mips手册，我们需要用到三个寄存器编码如下
    // 1. Cause : Rdaddr  = 13d, sel = 0
    // 2. EPC   : Rdaddr  = 14d, sel = 0
    // 3. Status: Rdaddr  = 12d, sel = 0
    // 我们暂且认为，按照Rd进行选址， 可以不考虑sel
    parameter CP0_ADDR_CAUSE = 5'd13;
    parameter CP0_ADDR_EPC   = 5'd14;
    parameter CP0_ADDR_STATUS= 5'd12;


    reg [31:0] cp0_array[31:0];

    always @(*) begin
        if(r) rdata <= cp0_array[Rdaddr_r];
        else rdata <= 32'h0;
    end

    always @(negedge clk or posedge rst) begin
        if(rst) begin
            cp0_array[0] <= 32'h0;
            cp0_array[1] <= 32'h0;
            cp0_array[2] <= 32'h0;
            cp0_array[3] <= 32'h0;
            cp0_array[4] <= 32'h0;
            cp0_array[5] <= 32'h0;
            cp0_array[6] <= 32'h0;
            cp0_array[7] <= 32'h0;
            cp0_array[8] <= 32'h0;
            cp0_array[9] <= 32'h0;
            cp0_array[10] <= 32'h0;
            cp0_array[11] <= 32'h0;
            cp0_array[12] <= 32'h0;
            cp0_array[13] <= 32'h0;
            cp0_array[14] <= 32'h0;
            cp0_array[15] <= 32'h0;
            cp0_array[16] <= 32'h0;
            cp0_array[17] <= 32'h0;
            cp0_array[18] <= 32'h0;
            cp0_array[19] <= 32'h0;
            cp0_array[20] <= 32'h0;
            cp0_array[21] <= 32'h0;
            cp0_array[22] <= 32'h0;
            cp0_array[23] <= 32'h0;
            cp0_array[24] <= 32'h0;
            cp0_array[25] <= 32'h0;
            cp0_array[26] <= 32'h0;
            cp0_array[27] <= 32'h0;
            cp0_array[28] <= 32'h0;
            cp0_array[29] <= 32'h0;
            cp0_array[30] <= 32'h0;
            cp0_array[31] <= 32'h0;
        end
        else if(w)begin
            cp0_array[Rdaddr_w] <= wdata;
        end
    end


endmodule
