`timescale 1ns / 1ps



module MASK_PC_IR(
    input clk,
    input rst,
    input [31:0] IR,
    input [31:0] PC,
    input mask_update,
    input next_update_pc,
    input next_update_ir,
    output [31:0]next_pc_out,
    output [31:0]mask_pc_out, //
    output [31:0]mask_ir_out
    );
    reg [31:0] mask_pc_current;
    reg [31:0] mask_ir_current;

    reg [31:0] next_pc;
    reg [31:0] next_ir;

    assign next_pc_out = next_pc;
    assign mask_pc_out = mask_pc_current;
    assign mask_ir_out = mask_ir_current;
    parameter PC_DIRTY  = 32'h44436040;
    parameter IR_DIRTY  = 32'h88807704;

    always @(negedge clk or posedge rst) begin
        if(rst)                 next_pc <= 32'h0040_0000;//来自PC_pre, 为了测试只能这么初始化     
        else if(next_update_pc) next_pc <= PC;
    end
 
    always @(negedge clk or posedge rst) begin
        if(rst)                 next_ir <= 32'h0;//来自IR_pre, 为了测试
        else if(next_update_ir) next_ir <= IR;
        // the current actual PC, 当刚取PC的时候, 在t1周期有信号
    end

    always @(negedge clk or posedge rst) begin
        if(rst) begin 
            mask_pc_current <= PC_DIRTY;
            mask_ir_current <= IR_DIRTY;
        end

        else if(mask_update)// 当前指令执行完成的时候
        begin
            mask_pc_current <= next_pc;
            mask_ir_current <= next_ir;
        end
    end
endmodule

