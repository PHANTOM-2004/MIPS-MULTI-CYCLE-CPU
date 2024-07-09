`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/08 17:06:58
// Design Name: 
// Module Name: cpu
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


module cpu(
    input clk,
    input rst, //
    input [31:0] dmem_rdata,
    input [31:0] instruction_read,
    output dmem_signed,
    output dmem_byte,
    output dmem_half,
    output [31:0] dmem_wdata,
    output [31:0] dmem_address,
    output dmem_read,
    output dmem_write,
    output [31:0] v_imem_addr,
    output [31:0] pc_fake, // 这里给出假的PC
    output [31:0] instruction_fake // 这里给出假的instruction
    );
/*-----------------------------------------------------------------------------------------------*/
    // decoder data
    wire [5:0] instr_type;
    wire [4:0] RS_addr;
    wire [4:0] RT_addr;
    wire [4:0] RD_addr;
    wire [4:0] sa;
    wire [15:0] imm16;
    wire [25:0] address;
    wire [2:0] sel;
    wire [3:0] alu_code_t;

    wire [31:0] IR_rdata; // this come from IR
/*-----------------------------------------------------------------------------------------------*/
    // decoder 
    instr_decoder cpu_instr_decoder(
        .instruction(IR_rdata),
        .Rdaddr(RD_addr),
        .Rsaddr(RS_addr),
        .Rtaddr(RT_addr),
        .sa(sa),
        .imm16(imm16),
        .address(address),
        .sel(sel),
        .alu_code(alu_code_t),
        .instr_type(instr_type)
    );

/*-----------------------------------------------------------------------------------------------*/
    // controller input data
    wire clz_busy;
    wire div_busy;
    wire mult_busy;
    wire zero, carry, negative, overflow;


/*-----------------------------------------------------------------------------------------------*/
    wire [4:0] cp0_cause_code;
    wire mask_update;
    wire next_update_pc;
    wire next_update_ir;
    // controller output data
    wire [3:0] alu_code;
    wire ext16_unsigned;
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
    wire mult_signed;
    wire div_start;
    wire div_signed;
    wire clz_start;
    // CP0 : which register to write
    wire MUXT_CP0_W_EPC;
    wire MUXT_CP0_W_STATUS;
    wire MUXT_CP0_W_CAUSE;
    // CP0 : which data to select
    wire MUXT_CP0_WDATA_PC;
    wire MUXT_CP0_WDATA_Z;
    wire MUXT_CP0_WDATA_T_STATUS;
    wire MUXT_CP0_WDATA_IR;
    wire MUXT_CP0_WDATA_RT;
    // CP0: read select
    wire MUXT_CP0_R_RD;
    wire MUXT_CP0_R_EPC;
    wire MUXT_CP0_R_SATUS;
    // HILO: which to select
    wire MUX_HI_WDATA_RS;
    wire MUX_HI_WDATA_MULT;
    wire MUX_HI_WDATA_DIV;
    wire MUX_LO_WDATA_RS;
    wire MUX_LO_WDATA_MULT;
    wire MUX_LO_WDATA_DIV;
    // GR: w: which addr to select
    wire MUX_GR_W_ADDR_RD;
    wire MUX_GR_W_ADDR_RT;
    wire MUX_GR_W_ADDR_31;
    //GR: w: which data to select
    wire [2:0] MUX_GR_W_DATA;
    // ALU:a,b
    wire [2:0] MUXT_ALU_A;
    wire [2:0] MUXT_ALU_B;//
    // DMEM, 
    wire DMEM_is_signed;
    wire DMEM_is_half;
    wire DMEM_is_byte;//
    // PC, which
    wire [2:0] MUXT_PC_W_DATA;

/*-----------------------------------------------------------------------------------------------*/
    // controller here
    controller cpu_controller(
        .clk(clk),
        .rst(rst),
        .instr_type(instr_type),
        .clz_busy(clz_busy),
        .div_busy(div_busy),
        .mult_busy(mult_busy),
        .alu_code_t(alu_code_t),
        .negative(negative),
        .zero(zero),
        //
        .mask_update(mask_update),
        .next_update_pc(next_update_pc),
        .next_update_ir(next_update_ir),
        //
        .cp0_cause_code(cp0_cause_code),
        .ext16_unsigned(ext16_unsigned),
        .alu_code(alu_code),
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
        .clz_start(clz_start),
        // CP0 : which register to write
        .MUXT_CP0_W_EPC(MUXT_CP0_W_EPC),
        .MUXT_CP0_W_STATUS(MUXT_CP0_W_STATUS),
        .MUXT_CP0_W_CAUSE(MUXT_CP0_W_CAUSE),
        // CP0 : which data to select
        .MUXT_CP0_WDATA_PC(MUXT_CP0_WDATA_PC),
        .MUXT_CP0_WDATA_Z(MUXT_CP0_WDATA_Z),
        .MUXT_CP0_WDATA_T_STATUS(MUXT_CP0_WDATA_T_STATUS),
        .MUXT_CP0_WDATA_IR(MUXT_CP0_WDATA_IR),
        .MUXT_CP0_WDATA_RT(MUXT_CP0_WDATA_RT),
        // CP0: read select
        .MUXT_CP0_R_RD(MUXT_CP0_R_RD),
        .MUXT_CP0_R_EPC(MUXT_CP0_R_EPC),
        .MUXT_CP0_R_SATUS(MUXT_CP0_R_SATUS),
        // HILO: which to select
        .MUX_HI_WDATA_RS(MUX_HI_WDATA_RS),
        .MUX_HI_WDATA_MULT(MUX_HI_WDATA_MULT),
        .MUX_HI_WDATA_DIV(MUX_HI_WDATA_DIV),
        .MUX_LO_WDATA_RS(MUX_LO_WDATA_RS),
        .MUX_LO_WDATA_MULT(MUX_LO_WDATA_MULT),
        .MUX_LO_WDATA_DIV(MUX_LO_WDATA_DIV),
        // GR: w: which addr to select
        .MUX_GR_W_ADDR_RD(MUX_GR_W_ADDR_RD),
        .MUX_GR_W_ADDR_RT(MUX_GR_W_ADDR_RT),
        .MUX_GR_W_ADDR_31(MUX_GR_W_ADDR_31),
        // GR: w: which data to select
        .MUX_GR_W_DATA(MUX_GR_W_DATA),
        // ALU:a,b
        .MUXT_ALU_A(MUXT_ALU_A),
        .MUXT_ALU_B(MUXT_ALU_B),
        // DMEM,
        .DMEM_is_signed(DMEM_is_signed),
        .DMEM_is_half(DMEM_is_half),
        .DMEM_is_byte(DMEM_is_byte),
        //PC
        .MUXT_PC_W_DATA(MUXT_PC_W_DATA)
    );

/*-----------------------------------------------------------------------------------------------*/

    wire [31:0] Z_rdata;
    wire [31:0] Z_wdata;
    Z z_reg(
        .clk(clk),
        .rst(rst),
        .Z_in(Z_in),
        .Z_out(Z_out),
        .Z_rdata(Z_rdata),
        .Z_wdata(Z_wdata)
    );
/*-----------------------------------------------------------------------------------------------*/
    // PC IR wire
    wire [31:0] PC_rdata;
    wire [31:0] PC_wdata;
    wire [31:0] IR_wdata;

    wire [31:0] pc_of_cur_instr;
    wire [31:0] instr_for_top;
    wire [31:0] pc_for_top;

    assign instruction_fake = instr_for_top;
    assign pc_fake = pc_for_top;

    MASK_PC_IR mpcir(
        .clk(clk),
        .rst(rst),
        .IR(IR_rdata),
        .PC(PC_rdata),
        .mask_update(mask_update),
        .next_update_pc(next_update_pc),
        .next_update_ir(next_update_ir),
        .next_pc_out(pc_of_cur_instr),
        .mask_pc_out(pc_for_top),
        .mask_ir_out(instr_for_top)
    );

    IR cpu_ir(
        .clk(clk),
        .rst(rst),
        .IR_out(IR_out),
        .IR_in(IR_in),
        .IR_rdata(IR_rdata),
        .IR_wdata(IR_wdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    wire [31:0] J_data;
    wire [31:0] JAL_data;

    assign JAL_data = {PC_rdata[31:28], address, 2'b0};
    assign J_data   = {pc_of_cur_instr[31:28], address, 2'b0};// not right, PC not + 4;这里设计失误
/*-----------------------------------------------------------------------------------------------*/
    // MUX PC
    wire [31:0] RS_data;
    wire [31:0] RT_data;

    wire [31:0] CP0_wdata;
    wire [31:0] CP0_rdata;
    wire [4:0] CP0_Rdaddr_r;
    wire [4:0] CP0_Rdaddr_w;

    muxt_pc_w_data mpwd(
        .MUXT_PC_W_DATA(MUXT_PC_W_DATA),
        .Z_data(Z_rdata),
        .EPC_data(CP0_rdata),
        .J_data(J_data),
        .JAL_data(JAL_data),
        .RS_data(RS_data),
        .MUXT_PC_W_DATA_IN(PC_wdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    // PC module
    PC cpu_pc(
        .clk(clk),
        .rst(rst),
        .read(PC_out),
        .write(PC_in),
        .data_in(PC_wdata),
        .data_out(PC_rdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    // HI, LO
    wire [31:0] LO_rdata;
    wire [31:0] LO_wdata;
    wire [31:0] HI_rdata;
    wire [31:0] HI_wdata;

    HI cpu_hi(
        .clk(clk),
        .rst(rst),
        .HI_in(HI_in),
        .HI_out(HI_out),
        .data_in(HI_wdata),
        .data_out(HI_rdata)
    );

    LO cpu_lo(
        .clk(clk),
        .rst(rst),
        .LO_in(LO_in),
        .LO_out(LO_out),
        .data_in(LO_wdata),
        .data_out(LO_rdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    wire [31:0] DRr_rdata;
    wire [31:0] DRr_wdata;
    wire [31:0] DRw_rdata;
    wire [31:0] DRw_wdata;


    DRr cpu_drr(
        .clk(clk),
        .rst(rst),
        .DRr_in(DRr_in),
        .DRr_out(DRr_out),
        .DRr_wdata(DRr_wdata),
        .DRr_rdata(DRr_rdata)
    );

    DRw cpu_drw(
        .clk(clk),
        .rst(rst),
        .DRw_in(DRw_in),
        .DRw_out(DRw_out),
        .DRw_wdata(DRw_wdata),
        .DRw_rdata(DRw_rdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    wire [31:0] CLZ_rdata;
    wire [31:0] CLZ_wdata;
    assign CLZ_wdata = RS_data;

    CLZ cpu_clz(
      .clk(clk),
      .rst(rst),
      .start(clz_start),
      .clz_data_in(CLZ_wdata),
      .clz_ans_out(CLZ_rdata),
      .busy(clz_busy)
    );
/*-----------------------------------------------------------------------------------------------*/

    wire [31:0] MUX_GR_W_DATA_IN;

    mux_gr_w_data mgwd(
        .MUX_GR_W_DATA(MUX_GR_W_DATA),
        .Z_data(Z_rdata),
        .DRr_data(DRr_rdata),
        .HI_data(HI_rdata),
        .LO_data(LO_rdata),
        .PC_data(PC_rdata), 
        .CLZ_data(CLZ_rdata),
        .MUX_GR_W_DATA_IN(MUX_GR_W_DATA_IN)
    );

    wire [4:0] MUX_GR_W_ADDR_IN;

    mux_gr_w_addr mgwad(
        .RD_addr(RD_addr),
        .RT_addr(RT_addr),
        .MUX_GR_W_ADDR_RD(MUX_GR_W_ADDR_RD),
        .MUX_GR_W_ADDR_RT(MUX_GR_W_ADDR_RT),
        .MUX_GR_W_ADDR_31(MUX_GR_W_ADDR_31),
        .MUX_GR_W_ADDR(MUX_GR_W_ADDR_IN)
    );

    regfile cpu_ref(
        .clk(clk),
        .rst(rst),
        .we(GR_in),
        .read1(GR_R1_out),
        .read2(GR_R2_out),
        .raddr1(RS_addr),
        .raddr2(RT_addr),
        .waddr(MUX_GR_W_ADDR_IN),
        .wdata(MUX_GR_W_DATA_IN),
        .rdata1(RS_data),
        .rdata2(RT_data)
    );
/*-----------------------------------------------------------------------------------------------*/
    // MULT, DIV
    wire [31:0] mult_a;
    wire [31:0] mult_b;
    wire [63:0] mult_ans;

    assign mult_a = RS_data;
    assign mult_b = RT_data;

    MULT cpu_mult(
        .clk(clk),
        .rst(rst),
        .start(mult_start),
        .mult_signed(mult_signed),
        .a(mult_a),
        .b(mult_b),
        .z(mult_ans),
        .busy(mult_busy)
    );  

    wire [31:0] dividend;
    wire [31:0] divisor;
    wire [31:0] div_q;
    wire [31:0] div_r;
    assign dividend = RS_data;
    assign divisor  = RT_data;

    DIV cpu_div(
        .clk(clk),
        .rst(rst),
        .start(div_start),
        .div_signed(div_signed),
        .dividend(dividend),
        .divisor(divisor),
        .q(div_q),
        .r(div_r),
        .busy(div_busy)
    );
/*-----------------------------------------------------------------------------------------------*/

mux_lo_wdata mlwd(
    .MUX_LO_WDATA_DIV(MUX_LO_WDATA_DIV),
    .MUX_LO_WDATA_MULT(MUX_LO_WDATA_MULT),
    .MUX_LO_WDATA_RS(MUX_LO_WDATA_RS),
    .DIV_data(div_r),
    .MULT_data(mult_ans[31:0]),
    .RS_data(RS_data),
    .MUX_LO_WDATA_IN(LO_wdata)
);

mux_hi_wdata mhwd(
    .MUX_HI_WDATA_DIV(MUX_HI_WDATA_DIV),
    .MUX_HI_WDATA_MULT(MUX_HI_WDATA_MULT),
    .MUX_HI_WDATA_RS(MUX_HI_WDATA_RS),
    .DIV_data(div_q),
    .MULT_data(mult_ans[63:32]),
    .RS_data(RS_data),
    .MUX_HI_WDATA_IN(HI_wdata)
);
/*-----------------------------------------------------------------------------------------------*/
// t_status_data
    wire [31:0] t_status_rdata;
    wire [31:0] t_status_wdata;
    assign t_status_wdata = CP0_rdata;

    T_STATUS tst(
        .clk(clk),
        .rst(rst),
        .wdata(t_status_wdata),
        .rdata(t_status_rdata),
        .t_status_in(t_status_in),
        .t_status_out(t_status_out)
    );

/*-----------------------------------------------------------------------------------------------*/

// CP0
    muxt_cp0_w_addr mcwa(
        .MUXT_CP0_W_CAUSE(MUXT_CP0_W_CAUSE),
        .MUXT_CP0_W_EPC(MUXT_CP0_W_EPC),
        .MUXT_CP0_W_STATUS(MUXT_CP0_W_STATUS),
        .MUXT_CP0_W_ADDR(CP0_Rdaddr_w)
    );

    muxt_cp0_r_addr mcra(
        .MUXT_CP0_R_RD(MUXT_CP0_R_RD),
        .MUXT_CP0_R_SATUS(MUXT_CP0_R_SATUS),
        .MUXT_CP0_R_EPC(MUXT_CP0_R_EPC),
        .CP0_RD(CP0_Rdaddr_r),
        .MUXT_CP0_R_ADDR(CP0_Rdaddr_r)
    );

    wire [31:0] cp0_cause_from_ir;
    assign cp0_cause_from_ir = {25'b0,cp0_cause_code,2'b0};

    muxt_cp0_wdata mcwd(
        .MUXT_CP0_WDATA_PC(MUXT_CP0_WDATA_PC),
        .MUXT_CP0_WDATA_Z(MUXT_CP0_WDATA_Z),
        .MUXT_CP0_WDATA_IR(MUXT_CP0_WDATA_IR),
        .MUXT_CP0_WDATA_RT(MUXT_CP0_WDATA_RT),
        .MUXT_CP0_WDATA_T_STATUS(MUXT_CP0_WDATA_T_STATUS),

        .PC_data(pc_of_cur_instr),
        .Z_data(Z_rdata),
        .t_status_data(t_status_rdata),
        .IR_data(cp0_cause_from_ir),
        .RT_data(RT_data),

        .CP0_WDATA(CP0_wdata)
    );

    CP0 cpu_cp0(
        .clk(clk),
        .rst(rst),
        .Rdaddr_r(CP0_Rdaddr_r),
        .Rdaddr_w(CP0_Rdaddr_w),
        .w(CP0_Rd_in),
        .r(CP0_Rd_out),
        .sel(sel),
        .wdata(CP0_wdata),
        .rdata(CP0_rdata)
    );

/*-----------------------------------------------------------------------------------------------*/
    wire [31:0] EXT5_data;
    wire [31:0] EXT16_data;
    wire [31:0] EXT18_data;

    EXT5 cpu_ext5(
        .content(sa),
        .ext5(EXT5_data)
    );      

    EXT16 cpu_ext16(
        .content(imm16),
        .is_unsigned(ext16_unsigned),
        .ext16(EXT16_data)
    );
    
    EXT18 cpu_ext18(
        .content({imm16,2'b00}),
        .ext18(EXT18_data)
    );

/*-----------------------------------------------------------------------------------------------*/
// ALU
    wire [31:0] alu_a;
    wire [31:0] alu_b;
    wire [31:0] alu_out;
    wire alu_zero_o, alu_carry_o, alu_negative_o, alu_overflow_o;
    assign Z_wdata = alu_out; // alu_out to Z;

    muxt_alu_a maa(
        .MUXT_ALU_A(MUXT_ALU_A),
        .RS_data(RS_data),
        .PC_data(PC_rdata),
        .EXT5_data(EXT5_data),
        .MUXT_ALU_A_DATA(alu_a)
    );

    muxt_alu_b mab(
        .MUXT_ALU_B(MUXT_ALU_B),
        .RT_data(RT_data),
        .EXT16_data(EXT16_data),
        .EXT18_data(EXT18_data),
        .CP0_status_data(CP0_rdata),
        .MUXT_ALU_B_DATA(alu_b)
    );

    ALU cpu_alu(
        .a(alu_a),
        .b(alu_b),
        .aluc(alu_code),
        .r(alu_out),
        .zero(alu_zero_o),
        .carry(alu_carry_o),
        .negative(alu_negative_o),
        .overflow(alu_overflow_o)
    );

    ALU_FLAG flags(
        .zero(alu_zero_o),
        .carry(alu_carry_o),
        .negative(alu_negative_o),
        .overflow(alu_overflow_o),
        .clk(clk),
        .rst(rst),
        .zero_r(zero),
        .negative_r(negative),
        .overflow_r(overflow),
        .carry_r(carry),
        .write(Z_in)
    );
/*-----------------------------------------------------------------------------------------------*/





/*-----------------------------------------------------------------------------------------------*/
    assign dmem_read  = M_R;
    assign dmem_write = M_W;

    assign dmem_wdata = DRw_rdata;
    assign DRw_wdata   = RT_data; // from register

    assign DRr_wdata  = dmem_rdata; //dmem出来的写道DRr里面
    //  DRr_rdata => regfile
    
    assign IR_wdata = instruction_read;

    assign dmem_address = Z_rdata;   // fetch memory
/*-----------------------------------------------------------------------------------------------*/
    
    assign v_imem_addr = PC_rdata;
    assign dmem_half = DMEM_is_half;
    assign dmem_byte = DMEM_is_byte;
    assign dmem_signed = DMEM_is_signed;
endmodule
