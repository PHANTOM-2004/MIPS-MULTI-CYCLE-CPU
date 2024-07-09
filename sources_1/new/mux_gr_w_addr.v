`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:49:51
// Design Name: 
// Module Name: mux_gr_w_addr
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


module mux_gr_w_addr(
    input [4:0] RD_addr,
    input [4:0] RT_addr,

    input MUX_GR_W_ADDR_RD,
    input MUX_GR_W_ADDR_RT,
    input MUX_GR_W_ADDR_31,

    output reg [4:0] MUX_GR_W_ADDR
    );

    always @(*) begin
        if(MUX_GR_W_ADDR_RD)        MUX_GR_W_ADDR <= RD_addr;
        else if(MUX_GR_W_ADDR_RT)   MUX_GR_W_ADDR <= RT_addr;
        else if(MUX_GR_W_ADDR_31)   MUX_GR_W_ADDR <= 5'd31;
        else                        MUX_GR_W_ADDR <= 5'h0;
    end

endmodule
