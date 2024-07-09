`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 15:57:08
// Design Name: 
// Module Name: muxt_cp0_wdata
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


module muxt_cp0_wdata(
    input MUXT_CP0_WDATA_PC,
    input MUXT_CP0_WDATA_Z,
    input MUXT_CP0_WDATA_IR,
    input MUXT_CP0_WDATA_RT,
    input MUXT_CP0_WDATA_T_STATUS,

    input [31:0]PC_data,
    input [31:0]Z_data,
    input [31:0]t_status_data,
    input [31:0]IR_data,
    input [31:0]RT_data,

    output reg [31:0]CP0_WDATA    
    );

    always @(*) begin
        if(MUXT_CP0_WDATA_PC)               CP0_WDATA <= PC_data;
        else if(MUXT_CP0_WDATA_Z)           CP0_WDATA <= Z_data;
        else if(MUXT_CP0_WDATA_T_STATUS)    CP0_WDATA <= t_status_data;
        else if(MUXT_CP0_WDATA_IR)          CP0_WDATA <= IR_data;
        else if(MUXT_CP0_WDATA_RT)          CP0_WDATA <= RT_data;
        else                                CP0_WDATA <= 32'h0;
    end

endmodule
