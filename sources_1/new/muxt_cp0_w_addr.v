`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:04:03
// Design Name: 
// Module Name: muxt_cp0_w_addr
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


module muxt_cp0_w_addr(
    input MUXT_CP0_W_CAUSE,
    input MUXT_CP0_W_EPC,
    input MUXT_CP0_W_STATUS,

    output reg [4:0]MUXT_CP0_W_ADDR//
    );

    parameter CP0_ADDR_CAUSE = 5'd12;
    parameter CP0_ADDR_EPC   = 5'd14;
    parameter CP0_ADDR_STATUS= 5'd12;
    always @(*) begin
        if(MUXT_CP0_W_CAUSE)        MUXT_CP0_W_ADDR <= CP0_ADDR_CAUSE;
        else if(MUXT_CP0_W_EPC)     MUXT_CP0_W_ADDR <= CP0_ADDR_EPC;
        else if(MUXT_CP0_W_STATUS)  MUXT_CP0_W_ADDR <= CP0_ADDR_STATUS;
        else                        MUXT_CP0_W_ADDR <= 32'h0;
    end
endmodule
