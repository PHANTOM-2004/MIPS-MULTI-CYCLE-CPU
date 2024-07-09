`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:07:46
// Design Name: 
// Module Name: mux_alu_b
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


module muxt_alu_b(
    input [2:0]MUXT_ALU_B,

    input [31:0] RT_data,
    input [31:0] EXT16_data,
    input [31:0] EXT18_data,
    input [31:0] CP0_status_data,

    output reg [31:0] MUXT_ALU_B_DATA
    );
    parameter MUXT_ALU_B_4          = 3'd0;
    parameter MUXT_ALU_B_RT         = 3'd1;
    parameter MUXT_ALU_B_EXT16      = 3'd2;
    parameter MUXT_ALU_B_EXT18      = 3'd3; 
    parameter MUXT_ALU_B_0          = 3'd4;
    parameter MUXT_ALU_B_CP0_STATUS = 3'd5;
    parameter MUXT_ALU_B_NONE       = 3'd7;

    always @(*) begin
        case(MUXT_ALU_B)
        MUXT_ALU_B_RT:          MUXT_ALU_B_DATA <= RT_data;
        MUXT_ALU_B_EXT16:       MUXT_ALU_B_DATA <= EXT16_data;
        MUXT_ALU_B_EXT18:       MUXT_ALU_B_DATA <= EXT18_data;
        MUXT_ALU_B_CP0_STATUS:  MUXT_ALU_B_DATA <= CP0_status_data;
        MUXT_ALU_B_4:           MUXT_ALU_B_DATA <= 32'h4;
        MUXT_ALU_B_0:           MUXT_ALU_B_DATA <= 32'h0;
        default:                MUXT_ALU_B_DATA <= 32'h0;
        endcase
    end
endmodule
