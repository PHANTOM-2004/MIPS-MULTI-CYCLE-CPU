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

    reg [31:0] Cause;
    reg [31:0] EPC;
    reg [31:0] Status;

    always @(*) begin
        if(r)begin
            case(Rdaddr_r)
            CP0_ADDR_CAUSE:     rdata <= Cause;
            CP0_ADDR_EPC:       rdata <= EPC;
            CP0_ADDR_STATUS:    rdata <= Status;
            default:            rdata <= 32'h0;
            endcase
        end
        else rdata <= 32'h0;
    end

    always @(negedge clk or posedge rst) begin
        if(rst) begin
            Cause <= 32'h0;
            EPC   <= 32'h0;
            Status<= 32'h0;
        end
        else if(w)begin
            case(Rdaddr_w)
                CP0_ADDR_CAUSE:  Cause <= wdata;
                CP0_ADDR_EPC:    EPC   <= wdata;
                CP0_ADDR_STATUS: Status<= wdata;
            endcase
        end
    end


endmodule
