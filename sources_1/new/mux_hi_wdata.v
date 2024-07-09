`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:53:02
// Design Name: 
// Module Name: mux_hi_wdata
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


module mux_hi_wdata(
    input MUX_HI_WDATA_DIV,
    input MUX_HI_WDATA_MULT,
    input MUX_HI_WDATA_RS,

    input [31:0] DIV_data,
    input [31:0] MULT_data,
    input [31:0] RS_data,

    output reg [31:0] MUX_HI_WDATA_IN
    );

    always @(*) begin
        if(MUX_HI_WDATA_DIV)    MUX_HI_WDATA_IN <= DIV_data;
        else if(MUX_HI_WDATA_MULT) MUX_HI_WDATA_IN <= MULT_data;
        else if(MUX_HI_WDATA_RS) MUX_HI_WDATA_IN <= RS_data;
        else MUX_HI_WDATA_IN <= 32'h0;
    end
endmodule
