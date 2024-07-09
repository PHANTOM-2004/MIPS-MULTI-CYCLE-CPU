`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:40:16
// Design Name: 
// Module Name: muxt_cp0_r_addr
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


module muxt_cp0_r_addr(
    input MUXT_CP0_R_RD,
    input MUXT_CP0_R_SATUS,
    input MUXT_CP0_R_EPC,

    input [4:0] CP0_RD,
    output reg [4:0] MUXT_CP0_R_ADDR
    );

    parameter CP0_ADDR_CAUSE = 5'd12;
    parameter CP0_ADDR_EPC   = 5'd14;
    parameter CP0_ADDR_STATUS= 5'd12;

    always @(*) begin
        if(MUXT_CP0_R_RD) MUXT_CP0_R_ADDR <= CP0_RD;
        else if(MUXT_CP0_R_SATUS) MUXT_CP0_R_ADDR <= CP0_ADDR_STATUS;
        else if(MUXT_CP0_R_EPC) MUXT_CP0_R_ADDR <= CP0_ADDR_EPC;
        else MUXT_CP0_R_ADDR <= 5'b00000;
    end
endmodule
