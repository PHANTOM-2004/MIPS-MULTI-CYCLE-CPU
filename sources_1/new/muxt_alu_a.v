`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:07:46
// Design Name: 
// Module Name: mux_alu_a
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


module muxt_alu_a(
    input [2:0]MUXT_ALU_A,

    input [31:0]RS_data,
    input [31:0]PC_data,
    input [31:0]EXT5_data,

    output reg [31:0] MUXT_ALU_A_DATA//
    );
    parameter MUXT_ALU_A_RS   = 3'd0;
    parameter MUXT_ALU_A_PC   = 3'd1;
    parameter MUXT_ALU_A_EXT5 = 3'd2;
    parameter MUXT_ALU_A_5    = 3'd3;
    parameter MUXT_ALU_A_NONE = 3'd7;

    always @(*) begin
        case(MUXT_ALU_A)
            MUXT_ALU_A_RS:      MUXT_ALU_A_DATA <= RS_data;
            MUXT_ALU_A_EXT5:    MUXT_ALU_A_DATA <= EXT5_data;
            MUXT_ALU_A_PC:      MUXT_ALU_A_DATA <= PC_data;
            MUXT_ALU_A_5:       MUXT_ALU_A_DATA <= 32'h5;
            default:            MUXT_ALU_A_DATA <= 32'h0;
        endcase
    end
endmodule
