`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/07 09:30:44
// Design Name: 
// Module Name: controller_tb_1
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


module controller_tb_5;

parameter INST_TYPE_ADD   = 6'd0;
parameter INST_TYPE_ADDU  = 6'd1;
parameter INST_TYPE_SUB   = 6'd2;
parameter INST_TYPE_SUBU  = 6'd3;
parameter INST_TYPE_AND   = 6'd4;
parameter INST_TYPE_OR    = 6'd5;
parameter INST_TYPE_XOR   = 6'd6;
parameter INST_TYPE_NOR   = 6'd7;
parameter INST_TYPE_SLT   = 6'd8;
parameter INST_TYPE_SLTU  = 6'd9;
parameter INST_TYPE_SLL   = 6'd10;
parameter INST_TYPE_SRL   = 6'd11;
parameter INST_TYPE_SRA   = 6'd12;
parameter INST_TYPE_SLLV  = 6'd13;
parameter INST_TYPE_SRLV  = 6'd14;
parameter INST_TYPE_SRAV  = 6'd15;
parameter INST_TYPE_JR    = 6'd16;
parameter INST_TYPE_ADDI  = 6'd17;
parameter INST_TYPE_ADDIU = 6'd18;
parameter INST_TYPE_ANDI  = 6'd19;
parameter INST_TYPE_ORI   = 6'd20;
parameter INST_TYPE_XORI  = 6'd21;
parameter INST_TYPE_LW    = 6'd22;
parameter INST_TYPE_SW    = 6'd23;
parameter INST_TYPE_BEQ   = 6'd24;
parameter INST_TYPE_BNE   = 6'd25;
parameter INST_TYPE_SLTI  = 6'd26;
parameter INST_TYPE_SLTIU = 6'd27;
parameter INST_TYPE_LUI   = 6'd28;
parameter INST_TYPE_J     = 6'd29;
parameter INST_TYPE_JAL   = 6'd30;
parameter INST_TYPE_JALR  = 6'd31;
parameter INST_TYPE_MULT  = 6'd32;
parameter INST_TYPE_MULTU = 6'd33;
parameter INST_TYPE_DIV   = 6'd34;
parameter INST_TYPE_DIVU  = 6'd35;
parameter INST_TYPE_MFLO  = 6'd36;
parameter INST_TYPE_MFHI  = 6'd37;
parameter INST_TYPE_MTLO  = 6'd38;
parameter INST_TYPE_MTHI  = 6'd39;
parameter INST_TYPE_TEQ   = 6'd40;
parameter INST_TYPE_BREAK = 6'd41;
parameter INST_TYPE_ERET  = 6'd42;
parameter INST_TYPE_SYSCALL = 6'd43;
parameter INST_TYPE_LB    = 6'd44;
parameter INST_TYPE_LBU   = 6'd45;
parameter INST_TYPE_LH    = 6'd46;
parameter INST_TYPE_LHU   = 6'd47;
parameter INST_TYPE_SB    = 6'd48;
parameter INST_TYPE_SH    = 6'd49;
parameter INST_TYPE_BGEZ  = 6'd50;
parameter INST_TYPE_MFC0  = 6'd51;
parameter INST_TYPE_MTC0  = 6'd52;
parameter INST_TYPE_CLZ   = 6'd53;
parameter INST_TYPE_UNKNOWN = 6'd54;

reg clk;
reg rst;
reg [5:0]instr_type;
reg branch_on;
wire clz_busy;
wire clz_start;
reg teq_equal;


wire IM_R;
wire PC_out;
wire PC_in;
wire M_R;
wire M_W;
wire DRw_out;
wire DRw_in;
wire DRr_out;
wire DRr_in;
wire Z_out;
wire Z_in;
wire IR_out;
wire IR_in;
wire GR_in;
wire GR_R1_out;
wire GR_R2_out;
wire LO_in;
wire LO_out;
wire HI_in;
wire HI_out;
wire CP0_Rd_in;
wire CP0_Rd_out;
wire t_status_in;
wire t_status_out;
wire mult_start;
wire multu_start;
wire mult_signed;
wire div_start;
wire div_signed;
wire busy;
wire mask_update;
wire next_update;

wire [2:0] MUXT_ALU_A;
wire [2:0] MUXT_ALU_B;

wire [3:0] alu_code;
wire [2:0] MUXT_PC_W_DATA;

controller inst(
    .clk(clk),
    .rst(rst),
    .alu_code_t(4'b1111),
    .alu_code(alu_code),
    .mask_update(mask_update),
    .next_update(next_update),
    .instr_type(instr_type),
    .branch_on(branch_on),
    .teq_equal(teq_equal),
    .div_busy(busy),
    .IM_R(IM_R),
    .PC_out(PC_out),
    .PC_in(PC_in),
    .M_R(M_R),
    .M_W(M_W),
    .DRw_out(DRw_out),
    .DRw_in(DRw_in),
    .DRr_out(DRr_out),
    .DRr_in(DRr_in),
    .Z_out(Z_out),
    .Z_in(Z_in),
    .IR_out(IR_out),
    .IR_in(IR_in),
    .GR_in(GR_in),
    .GR_R1_out(GR_R1_out),
    .GR_R2_out(GR_R2_out),
    .LO_in(LO_in),
    .LO_out(LO_out),
    .HI_in(HI_in),
    .HI_out(HI_out),
    .CP0_Rd_in(CP0_Rd_in),
    .CP0_Rd_out(CP0_Rd_out),
    .t_status_in(t_status_in),
    .t_status_out(t_status_out),
    .mult_start(mult_start),
    .mult_signed(mult_signed),
    .div_start(div_start),
    .div_signed(div_signed),
    .clz_busy(clz_busy),
    .clz_start(clz_start),

    .MUXT_CP0_W_EPC(MUXT_CP0_W_EPC),
    .MUXT_CP0_W_STATUS(MUXT_CP0_W_STATUS),
    .MUXT_CP0_W_CAUSE(MUXT_CP0_W_CAUSE),

    .MUXT_CP0_WDATA_PC(MUXT_CP0_WDATA_PC),
    .MUXT_CP0_WDATA_Z(MUXT_CP0_WDATA_Z),
    .MUXT_CP0_WDATA_T_STATUS(MUXT_CP0_WDATA_T_STATUS),
    .MUXT_CP0_WDATA_IR(MUXT_CP0_WDATA_IR),
    .MUXT_CP0_WDATA_RT(MUXT_CP0_WDATA_RT),

    .MUXT_ALU_A(MUXT_ALU_A),
    .MUXT_ALU_B(MUXT_ALU_B),

    .MUXT_CP0_R_RD(MUXT_CP0_R_RD),
    .MUXT_CP0_R_EPC(MUXT_CP0_R_EPC),
    .MUXT_CP0_R_SATUS(MUXT_CP0_R_SATUS), //

    .MUXT_PC_W_DATA(MUXT_PC_W_DATA)
    );
    always #5 clk = ~clk;

    // wire [3:0] T_state = inst.cycle + 4'b1;
    wire [3:0] cycle   = inst.cycle;

    initial begin
        clk = 0;
        rst = 1;
        branch_on = 0;
        teq_equal = 0;

        #13;
        rst = 0; //reset
        #2;
        // teq 1
        instr_type = INST_TYPE_TEQ;
        #40;

        // teq 2
        instr_type = INST_TYPE_TEQ;
        #30;
        teq_equal = 1;//T4 Zout
        #50;

        // break
        instr_type = INST_TYPE_BREAK;
        #60

        // syscall
        instr_type = INST_TYPE_SYSCALL;

        #60;
        // eret
        instr_type = INST_TYPE_ERET;

    end



endmodule