`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 13:30:57
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input   clk, //寄存器组时钟信号，下降沿写入数据
    input   rst,
    input   read,
    input   write,
    input   is_signed,
    input   is_half,
    input   is_byte,
    input   [6:0] address,
    input   [31:0] wdata,
    output reg[31:0] rdata
    );
    
    reg [31:0] memory [31:0];

    wire [4:0] _4byte_addr;
    wire [1:0] _4byte_inner_pos;

    reg [7:0] _byte;
    reg [15:0] _half;

    wire [31:0]_4byte;
    wire [31:0]ext_byte;
    wire [31:0]ext_half;

    assign _4byte_addr      = address[6:2];
    assign _4byte_inner_pos = address[1:0];
    assign _4byte   = read ? memory[_4byte_addr] : 32'h0;

    assign ext_byte = {{24{_byte[7]&is_signed}},_byte};
    assign ext_half = {{16{_half[15]&is_signed}}, _half};

    always @(*) begin
        if(is_half)       rdata <= ext_half;
        else if(is_byte)  rdata <= ext_byte;
        else            rdata <= _4byte;
    end

    always @(*) begin
        case(_4byte_inner_pos) //仿真使用的little endian
            2'b00: begin _byte <= _4byte[7:0];   _half <= _4byte[15:0]; end
            2'b01: begin _byte <= _4byte[15:8];  _half <= _4byte[15:0]; end
            2'b10: begin _byte <= _4byte[23:16]; _half <= _4byte[31:16]; end
            2'b11: begin _byte <= _4byte[31:24]; _half <= _4byte[31:16]; end
        endcase
    end

    // assign _shift_mask =     

    always @(negedge clk or posedge rst) begin
        if(rst) begin
            memory[0]  <= 32'h0;
            memory[1]  <= 32'h0;
            memory[2]  <= 32'h0;
            memory[3]  <= 32'h0;
            memory[4]  <= 32'h0;
            memory[5]  <= 32'h0;
            memory[6]  <= 32'h0;
            memory[7]  <= 32'h0;
            memory[8]  <= 32'h0;
            memory[9]  <= 32'h0;
            memory[10] <= 32'h0;
            memory[11] <= 32'h0;
            memory[12] <= 32'h0;
            memory[13] <= 32'h0;
            memory[14] <= 32'h0;
            memory[15] <= 32'h0;
            memory[16] <= 32'h0;
            memory[17] <= 32'h0;
            memory[18] <= 32'h0;
            memory[19] <= 32'h0;
            memory[20] <= 32'h0;
            memory[21] <= 32'h0;
            memory[22] <= 32'h0;
            memory[23] <= 32'h0;
            memory[24] <= 32'h0;
            memory[25] <= 32'h0;
            memory[26] <= 32'h0;
            memory[27] <= 32'h0;
            memory[28] <= 32'h0;
            memory[29] <= 32'h0;
            memory[30] <= 32'h0;
            memory[31] <= 32'h0;
        end

        else if(write) begin 
            if(is_half) begin
                case(_4byte_inner_pos)
                    2'b00,2'b01: memory[_4byte_addr][15:0]  <= wdata[15:0];
                    2'b10,2'b11: memory[_4byte_addr][31:16] <= wdata[31:16];
                endcase
            end
            else if(is_byte) begin
                case(_4byte_inner_pos)
                    2'b00:  memory[_4byte_addr][7:0]    <= wdata[7:0];
                    2'b01:  memory[_4byte_addr][15:8]   <= wdata[15:8];
                    2'b10:  memory[_4byte_addr][23:16]  <= wdata[23:16];
                    2'b11:  memory[_4byte_addr][31:24]  <= wdata[31:24];
                endcase
            end
            else memory[_4byte_addr] <= wdata;
        end
    end

endmodule


