`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 18:34:10
// Design Name: 
// Module Name: mux_pc_w_data
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


module muxt_pc_w_data(
    input [2:0] MUXT_PC_W_DATA,
    input [31:0] Z_data,
    input [31:0] EPC_data,
    input [31:0] J_data,
    input [31:0] JAL_data,
    input [31:0] RS_data,
    output reg [31:0] MUXT_PC_W_DATA_IN
    );

    parameter MUXT_PC_W_DATA_Z      = 3'd0;
    parameter MUXT_PC_W_DATA_EPC    = 3'd1;
    parameter MUXT_PC_W_DATA_JAL    = 3'd2;
    parameter MUXT_PC_W_DATA_J      = 3'd3;    
    parameter MUXT_PC_W_DATA_RS     = 3'd4; // jalr, jr
    parameter MUXT_PC_W_DATA_0x4    = 3'd5;
    parameter MUXT_PC_W_DATA_NONE   = 3'd7;

    always @(*) begin
        case(MUXT_PC_W_DATA)
            MUXT_PC_W_DATA_Z:       MUXT_PC_W_DATA_IN = Z_data;
            MUXT_PC_W_DATA_EPC:     MUXT_PC_W_DATA_IN = EPC_data;
            MUXT_PC_W_DATA_J:       MUXT_PC_W_DATA_IN = J_data;
            MUXT_PC_W_DATA_JAL:     MUXT_PC_W_DATA_IN = JAL_data;
            MUXT_PC_W_DATA_RS:      MUXT_PC_W_DATA_IN = RS_data;
            MUXT_PC_W_DATA_0x4:     MUXT_PC_W_DATA_IN = 32'h00400004;
            default:                MUXT_PC_W_DATA_IN = 32'h00000000;
        endcase
    end

endmodule
