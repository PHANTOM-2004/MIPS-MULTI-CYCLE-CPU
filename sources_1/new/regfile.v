`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 20:17:23
// Design Name: 
// Module Name: Regfiles
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


module regfile(
    input clk, //寄存器组时钟信号，下降沿写入数据
    input rst, //异步复位信号，高电平时全部寄存器置零
    input we, //寄存器写有效信号，高电平时允许寄存器写入数据，
    //读出数据始终允许
    input read1,
    input read2,

    input [4:0] raddr1, //所需读取的寄存器的地址
    input [4:0] raddr2, //所需读取的寄存器的地址
    input [4:0] waddr, //写寄存器的地址
    input [31:0] wdata, //写寄存器数据，数据在clk下降沿时被写入

    output reg [31:0] rdata1, //raddr1所对应寄存器的输出数据
    output reg [31:0] rdata2 //raddr2所对应寄存器的输出数据
    );

    reg [31:0] array_reg [31:0];
    
    // 下降沿写入数据
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            array_reg[0]  <= 32'h0;
            array_reg[1]  <= 32'h0;
            array_reg[2]  <= 32'h0;
            array_reg[3]  <= 32'h0;
            array_reg[4]  <= 32'h0;
            array_reg[5]  <= 32'h0;
            array_reg[6]  <= 32'h0;
            array_reg[7]  <= 32'h0;
            array_reg[8]  <= 32'h0;
            array_reg[9]  <= 32'h0;
            array_reg[10] <= 32'h0;
            array_reg[11] <= 32'h0;
            array_reg[12] <= 32'h0;
            array_reg[13] <= 32'h0;
            array_reg[14] <= 32'h0;
            array_reg[15] <= 32'h0;
            array_reg[16] <= 32'h0;
            array_reg[17] <= 32'h0;
            array_reg[18] <= 32'h0;
            array_reg[19] <= 32'h0;
            array_reg[20] <= 32'h0;
            array_reg[21] <= 32'h0;
            array_reg[22] <= 32'h0;
            array_reg[23] <= 32'h0;
            array_reg[24] <= 32'h0;
            array_reg[25] <= 32'h0;
            array_reg[26] <= 32'h0;
            array_reg[27] <= 32'h0;
            array_reg[28] <= 32'h0;
            array_reg[29] <= 32'h0;
            array_reg[30] <= 32'h0;
            array_reg[31] <= 32'h0;
        end
        else if(we && waddr) array_reg[waddr] <= wdata;
    end

    always @(*) begin
        rdata1 <= read1 ? array_reg[raddr1] : 32'h0;
        rdata2 <= read2 ? array_reg[raddr2] : 32'h0;
    end
    
endmodule

