`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 14:54:18
// Design Name: 
// Module Name: DMEM_tb
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


module DMEM_tb;

reg clk;
reg [31:0] wdata;
wire [31:0] rdata;
reg is_byte;
reg is_half;
reg is_signed;
reg w;
reg r;
reg rst;
reg [6:0]address;
reg [31:0] ans;

parameter DA1   =32'haabbccdd;
parameter ADDR1 = 7'd60;

parameter DA2   =32'h11223344;
parameter ADDR2 =7'd8;

parameter DA3   =32'h12341234;
parameter ADDR3 =7'd44;

parameter HADDR1 = 7'd13;
parameter HADDR2 = 7'd21;
parameter BADDR1 = 7'd8;
parameter BADDR2 = 7'd33;   

always #5 clk = ~clk;
wire [4:0] _4byte_addr = inst._4byte_addr;
wire [1:0] _4byte_inner_pos = inst._4byte_inner_pos;
wire [7:0] _byte = inst._byte;
wire [15:0] _half = inst._half;
wire [31:0] _4byte = inst._4byte;

DMEM inst(//
    .clk(clk),
    .rst(rst),
    .write(w),
    .read(r),
    .is_byte(is_byte),
    .is_half(is_half),
    .address(address),
    .wdata(wdata),
    .rdata(rdata),
    .is_signed(is_signed)
);

initial begin
    clk = 0;
    rst = 1;
    is_byte = 0;
    is_half = 0;
    w = 0;
    r = 0;
    address = 0;
    is_signed = 0;
    ans = 0;

    #13;
    rst = 0;
    w = 1;

    w = 1;
    address = ADDR1;
    wdata = DA1;                                

    #20;

    address = ADDR2;
    wdata   = DA2;

    #20;

    address = ADDR3;
    wdata   = DA3;

    #20 
    w = 0;
    r = 1;
    address = ADDR1;
    ans = DA1;

    #20;
    address = ADDR2;
    ans = DA2;

    #20 
    address = ADDR3;
    ans = DA3;

    #20
    w = 1;
    r = 0;
    address = HADDR1;
    is_half = 1;
    wdata   = 32'hffffb0c0;

    #20
    address = HADDR2;
    is_half = 1;
    wdata   =  32'h99887766;

    #20 
    w = 0;
    r = 1;
    address = HADDR1;
    ans = 32'hb0c0;

    #20
    is_signed = 1;
    ans = 32'hffffb0c0;

    #20
    is_signed = 0;
    address = HADDR2;
    ans = 32'h7766;

    #20
    is_signed = 1;
    ans = 32'h7766;

    #20
    w = 1;
    r = 0;
    is_half = 0;
    is_byte = 1;
    is_signed = 0;

    address = BADDR1;
    wdata   = 32'ha1a2a3a4;

    #20;

    address = BADDR1;
    wdata   = 32'hb1b2b3b4;

    #20;
    w = 0;
    r = 1;
    address = BADDR1;
    ans = 32'hb4;

    #20 
    is_signed = 1;
    ans = 32'hffff_ffb4;


end



endmodule
