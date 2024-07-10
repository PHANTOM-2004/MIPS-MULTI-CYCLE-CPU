`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 16:44:14
// Design Name: 
// Module Name: mux_gr_w_data
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


module mux_gr_w_data(
    input [2:0] MUX_GR_W_DATA,

    input [31:0] Z_data,
    input [31:0] DRr_data,
    input [31:0] HI_data,
    input [31:0] LO_data,
    input [31:0] PC_data,
    input [31:0] CLZ_data,
    input [31:0] CP0_data,

    output reg [31:0] MUX_GR_W_DATA_IN
    );
    parameter MUX_GR_W_DATA_Z         = 3'd0;
    parameter MUX_GR_W_DATA_DRr       = 3'd1;
    parameter MUX_GR_W_DATA_HI        = 3'd2;
    parameter MUX_GR_W_DATA_LO        = 3'd3;
    parameter MUX_GR_W_DATA_PC        = 3'd4;
    parameter MUX_GR_W_DATA_CLZ       = 3'd5;
    parameter MUX_GR_W_DATA_CP0       = 3'd6;
    parameter MUX_GR_W_DATA_NONE      = 3'd7;

    always @(*) begin
        case(MUX_GR_W_DATA)
            MUX_GR_W_DATA_Z:       MUX_GR_W_DATA_IN <= Z_data;
            MUX_GR_W_DATA_DRr:     MUX_GR_W_DATA_IN <= DRr_data;
            MUX_GR_W_DATA_HI:      MUX_GR_W_DATA_IN <= HI_data;
            MUX_GR_W_DATA_LO:      MUX_GR_W_DATA_IN <= LO_data;
            MUX_GR_W_DATA_PC:      MUX_GR_W_DATA_IN <= PC_data;
            MUX_GR_W_DATA_CLZ:     MUX_GR_W_DATA_IN <= CLZ_data;
            MUX_GR_W_DATA_CP0:     MUX_GR_W_DATA_IN <= CP0_data;
            default:               MUX_GR_W_DATA_IN <= 32'h0;
        endcase
    end

endmodule
