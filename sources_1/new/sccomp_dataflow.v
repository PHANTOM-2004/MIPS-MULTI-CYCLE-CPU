`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 21:08:21
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc
    );

    wire [31:0] v_dmem_address;
    wire [31:0] p_dmem_address;
    wire [31:0] v_imem_addr;
    wire [31:0] p_imem_addr;

    wire [31:0]dmem_wdata;
    wire [31:0]dmem_rdata;
    wire dmem_read;
    wire dmem_write;
    wire [31:0]pc_fake;
    wire [31:0]instruction_fake;
    wire [31:0]instruction_read;
    wire dmem_signed;
    wire dmem_half;
    wire dmem_byte;

    assign pc = pc_fake;
    assign inst = instruction_fake;

    cpu sccpu(
        .clk(clk_in),
        .rst(reset),
        .instruction_read(instruction_read),
        .dmem_byte(dmem_byte),
        .dmem_half(dmem_half),
        .dmem_signed(dmem_signed),
        .dmem_rdata(dmem_rdata),
        .dmem_wdata(dmem_wdata),
        .dmem_read(dmem_read),
        .dmem_write(dmem_write),
        .dmem_address(v_dmem_address),
        .pc_fake(pc_fake),
        .instruction_fake(instruction_fake),
        .v_imem_addr(v_imem_addr)
    );

    assign p_imem_addr = v_imem_addr - 32'h0040_0000;
    imem IMEM(
        .a(p_imem_addr[12:2]),
        .spo(instruction_read) // write to IR
    );

    assign p_dmem_address = v_dmem_address - 32'h1001_0000;
    DMEM memory(
        .clk(clk_in),
        .rst(reset),
        .read(dmem_read),
        .write(dmem_write),
        .is_signed(dmem_signed),
        .is_half(dmem_half),
        .is_byte(dmem_byte),
        .address(p_dmem_address[6:0]),
        .rdata(dmem_rdata),
        .wdata(dmem_wdata)
    );
endmodule
