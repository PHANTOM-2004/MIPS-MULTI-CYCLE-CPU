`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/06 17:06:31
// Design Name: 
// Module Name: controller
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


module controller(
    input clk,
    input rst,
    input [5:0] instr_type,
    // input branch_on,
    input negative, //for bgez
    input zero,
    input clz_busy,
    input div_busy,
    input mult_busy,
    input [3:0] alu_code_t,
    
    /*--------------------*/
    //用于平台测试的信号
    output mask_update,
    output next_update_pc,
    output next_update_ir,
    output pc_for_final_test_update,
    /*--------------------*/
    output reg [4:0] cp0_cause_code,
    output GR_R1_ADDR_RD,
    /*--------------------*/
    output reg [3:0] alu_code,
    output ext16_unsigned,
    output IM_R,
    output PC_out,
    output PC_in,
    output M_R,
    output M_W,
    output DRw_out,
    output DRw_in,
    output DRr_out,
    output DRr_in,
    output Z_out,
    output Z_in,
    output IR_out,
    output IR_in,
    output GR_in,
    output GR_R1_out,
    output GR_R2_out,
    output LO_in,
    output LO_out,
    output HI_in,
    output HI_out,
    output CP0_Rd_in,
    output CP0_Rd_out,
    output t_status_in,
    output t_status_out,
    output reg mult_start,
    output mult_signed,
    output reg div_start,
    output div_signed,
    output reg clz_start,
    // CP0 : which register to write
    output MUXT_CP0_W_EPC,
    output MUXT_CP0_W_STATUS,
    output MUXT_CP0_W_CAUSE,
    output MUXT_CP0_W_RD,
    // CP0 : which data to select
    output MUXT_CP0_WDATA_PC,
    output MUXT_CP0_WDATA_Z,      
    output MUXT_CP0_WDATA_T_STATUS,
    output MUXT_CP0_WDATA_IR, //
    output MUXT_CP0_WDATA_RT,
    // CP0: read select
    output MUXT_CP0_R_RD,
    output MUXT_CP0_R_EPC,
    output MUXT_CP0_R_STATUS,
    // HILO: which to select
    output MUX_HI_WDATA_RS,//1 for Rs, 0 for Z
    output MUX_HI_WDATA_MULT,
    output MUX_HI_WDATA_DIV,
    output MUX_LO_WDATA_RS,
    output MUX_LO_WDATA_MULT, //
    output MUX_LO_WDATA_DIV,
    // GR: w: which addr to select
    output MUX_GR_W_ADDR_RD,
    output MUX_GR_W_ADDR_RT,
    output MUX_GR_W_ADDR_31,
    //GR: w: which data to select
    output reg[2:0] MUX_GR_W_DATA,
    // ALU:a,b
    output reg [2:0] MUXT_ALU_A,
    output reg [2:0] MUXT_ALU_B,//
    // DMEM, 
    output DMEM_is_signed,
    output DMEM_is_half,
    output DMEM_is_byte,//
    // PC, which data to select,
    output reg [2:0] MUXT_PC_W_DATA
    );

    // control cycle and register io
    parameter ALUCODE_ADDU  = 4'b0000;
    parameter ALUCODE_ADD   = 4'b0010;
    parameter ALUCODE_SUBU  = 4'b0001;
    parameter ALUCODE_SUB   = 4'b0011;
    parameter ALUCODE_AND   = 4'b0100;
    parameter ALUCODE_OR    = 4'b0101;
    parameter ALUCODE_XOR   = 4'b0110;
    parameter ALUCODE_NOR   = 4'b0111;
    parameter ALUCODE_LUI   = 4'b100x;
    parameter ALUCODE_SLT   = 4'b1011;
    parameter ALUCODE_SLTU  = 4'b1010;
    parameter ALUCODE_SRA   = 4'b1100;
    parameter ALUCODE_SLL   = 4'b111x;
    parameter ALUCODE_SRL   = 4'b1101;
    parameter ALUCODE_NONE  = 4'b1111;
    // except for mult/div, max cycles : 7
    parameter T1 = 3'd0;
    parameter T2 = 3'd1;
    parameter T3 = 3'd2;
    parameter T4 = 3'd3;
    parameter T5 = 3'd4;
    parameter T6 = 3'd5;
    parameter T7 = 3'd6;
    parameter T8 = 3'd7;
    
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

    parameter INTERRUPTION_ON = 1;
    parameter INTERRUPTION_OFF = 0;

 /*-----------------------------------------------------------------------------------------------*/

    reg [2:0] cycle;
    reg [2:0] next_cycle;
    reg interruption;
    wire t1,t2,t3,t4,t5,t6,t7,t8;
    wire branch_on;
    wire teq_equal;

    assign t1 = cycle == T1;
    assign t2 = cycle == T2;
    assign t3 = cycle == T3;
    assign t4 = cycle == T4;
    assign t5 = cycle == T5;
    assign t6 = cycle == T6;
    assign t7 = cycle == T7;
    assign t8 = cycle == T8;

    assign _add     = instr_type == INST_TYPE_ADD  ; 
    assign _addu    = instr_type == INST_TYPE_ADDU ; 
    assign _sub     = instr_type == INST_TYPE_SUB  ; 
    assign _subu    = instr_type == INST_TYPE_SUBU ; 
    assign _and     = instr_type == INST_TYPE_AND  ; 
    assign _or      = instr_type == INST_TYPE_OR   ; 
    assign _xor     = instr_type == INST_TYPE_XOR  ; 
    assign _nor     = instr_type == INST_TYPE_NOR  ; 
    assign _slt     = instr_type == INST_TYPE_SLT  ; 
    assign _sltu    = instr_type == INST_TYPE_SLTU ; 
    assign _sll     = instr_type == INST_TYPE_SLL  ; 
    assign _srl     = instr_type == INST_TYPE_SRL  ; 
    assign _sra     = instr_type == INST_TYPE_SRA  ; 
    assign _sllv    = instr_type == INST_TYPE_SLLV ; 
    assign _srlv    = instr_type == INST_TYPE_SRLV ; 
    assign _srav    = instr_type == INST_TYPE_SRAV ; 
    assign _jr      = instr_type == INST_TYPE_JR   ; 
    assign _addi    = instr_type == INST_TYPE_ADDI ; 
    assign _addiu   = instr_type == INST_TYPE_ADDIU; 
    assign _andi    = instr_type == INST_TYPE_ANDI ; 
    assign _ori     = instr_type == INST_TYPE_ORI  ; 
    assign _xori    = instr_type == INST_TYPE_XORI ; 
    assign _lw      = instr_type == INST_TYPE_LW   ; 
    assign _sw      = instr_type == INST_TYPE_SW   ; 
    assign _beq     = instr_type == INST_TYPE_BEQ  ; 
    assign _bne     = instr_type == INST_TYPE_BNE  ; 
    assign _slti    = instr_type == INST_TYPE_SLTI ; 
    assign _sltiu   = instr_type == INST_TYPE_SLTIU; 
    assign _lui     = instr_type == INST_TYPE_LUI  ; 
    assign _j       = instr_type == INST_TYPE_J    ; 
    assign _jal     = instr_type == INST_TYPE_JAL  ; 
    assign _jalr    = instr_type == INST_TYPE_JALR ; 
    assign _mult    = instr_type == INST_TYPE_MULT ; 
    assign _multu   = instr_type == INST_TYPE_MULTU; 
    assign _div     = instr_type == INST_TYPE_DIV  ; 
    assign _divu    = instr_type == INST_TYPE_DIVU ; 
    assign _mflo    = instr_type == INST_TYPE_MFLO ; 
    assign _mfhi    = instr_type == INST_TYPE_MFHI ; 
    assign _mtlo    = instr_type == INST_TYPE_MTLO ; 
    assign _mthi    = instr_type == INST_TYPE_MTHI ; 
    assign _teq     = instr_type == INST_TYPE_TEQ  ; 
    assign _break   = instr_type == INST_TYPE_BREAK; 
    assign _eret    = instr_type == INST_TYPE_ERET ; 
    assign _syscall = instr_type == INST_TYPE_SYSCALL;
    assign _lb      = instr_type == INST_TYPE_LB   ; 
    assign _lbu     = instr_type == INST_TYPE_LBU  ; 
    assign _lh      = instr_type == INST_TYPE_LH   ; 
    assign _lhu     = instr_type == INST_TYPE_LHU  ; 
    assign _sb      = instr_type == INST_TYPE_SB   ; 
    assign _sh      = instr_type == INST_TYPE_SH   ; 
    assign _bgez    = instr_type == INST_TYPE_BGEZ ; 
    assign _mfc0    = instr_type == INST_TYPE_MFC0 ; 
    assign _mtc0    = instr_type == INST_TYPE_MTC0 ; 
    assign _clz     = instr_type == INST_TYPE_CLZ  ; 

 /*-----------------------------------------------------------------------------------------------*/
    // negedge set interruption
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            interruption <= INTERRUPTION_OFF;
        end

        else begin
            if(_break || _syscall) interruption<= INTERRUPTION_ON;
            else if(_teq) interruption <= (t1 || t2 || t3 || t4) ? INTERRUPTION_OFF: INTERRUPTION_ON;
            else if(_eret) interruption <= t4 ? INTERRUPTION_OFF: INTERRUPTION_ON;
            else interruption <= INTERRUPTION_OFF;
       end
    end

    parameter MULT_TIMES = 3'd5;
    parameter DIV_TIMES  = 6'd32;


/*-----------------------------------------------------------------------------------------------*/
    // helper
    assign _bs          = _break || _syscall;
    assign _md          = _mult || _multu || _div || _divu;
    assign _b_branch    = _beq || _bne || _bgez;
    assign _l_load      = _lw || _lb || _lbu || _lh || _lhu;
    assign _s_store     = _sw || _sb || _sh;
    assign _r_sum_t     = (_addu || _add || _subu || _sub || 
                          _and || _xor || _nor || _or || _slt || _sltu || _sllv || _srlv || _srav);
    assign _i_sum_t     = (_addi || _addiu 
                          || _andi || _ori || _xori || _slti || _sltiu || _lui);
    assign _sh_sum_t    = (_sll || _srl || _sra);
/*-----------------------------------------------------------------------------------------------*/

    always @(*) begin
        if(_teq)            cp0_cause_code <= 5'b1101;
        else if(_break)     cp0_cause_code <= 5'b1001;
        else if(_syscall)   cp0_cause_code <= 5'b1000;
        else                cp0_cause_code <= 5'b0000;
    end


/*-----------------------------------------------------------------------------------------------*/

    always @(posedge clk or posedge rst) begin
        if(rst) cycle <= T8;
        else cycle <= next_cycle;
    end

/*-----------------------------------------------------------------------------------------------*/
    always @(*) begin
        // MULT: 3 + 1 + 5
        // DIV:  3 + 1 + 32
        // CLZ:  3 + 1 + 32

        // 3 cycles: j, jr, mflo, mfhi, mfc0, mtc0, mtlo, mthi, TEQ1, 
        // 6 cycles: beq2, bne2, begz2,
        // 5 cycles: lw,lb,lbu,lhu,lh,sw,sh,sb
        // 7 cycles: TEQ2, BREAK, SYSCALL
        case(instr_type)

            INST_TYPE_CLZ: begin
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: if(!clz_busy && !clz_start) 
                            next_cycle <= T4;
                        else next_cycle <= T3;
                    default: begin next_cycle <= T1;end
                endcase
            end

            INST_TYPE_MULT, INST_TYPE_MULTU: begin
                case(cycle)
                T1: begin next_cycle <= T2; end
                T2: next_cycle <= T3;
                T3: if(!mult_busy && !mult_start) // spare 1 cycle
                        next_cycle <= T4;
                    else next_cycle <= T3;
                default:begin next_cycle <= T1;end
                endcase
            end

            INST_TYPE_DIV, INST_TYPE_DIVU: begin
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: if(!div_busy && !div_start) 
                            next_cycle <= T4;
                        else next_cycle <= T3;
                    default: begin next_cycle <= T1;end
                endcase

            end

            INST_TYPE_J, 
            INST_TYPE_JR, 
            INST_TYPE_MFLO,
            INST_TYPE_MFHI,
            INST_TYPE_MTLO,
            INST_TYPE_MTHI,
            INST_TYPE_MTC0,
            INST_TYPE_MFC0: begin // 3 cycles
                case(cycle) 
                    T1: begin next_cycle <= T2; end
                    T2: begin next_cycle <= T3;  end
                    // T3: cycle <= T1;
                    default: begin next_cycle <= T1;  end
                endcase
            end

            INST_TYPE_BEQ,
            INST_TYPE_BNE,
            INST_TYPE_BGEZ: begin // it depends on branch , 6cycles
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    // 若branch on, T3之后一个周期已经归零， 若branch off， 这里已经设置1
                    T3: begin next_cycle <= T4; end
                    T4: if(branch_on)   next_cycle <= T5;
                        else begin      next_cycle <= T1;end
                    T5:  begin next_cycle <= T6; end
                    // T6: cycle <= T1;
                    default: begin  next_cycle <= T1;end

                endcase
            end

            INST_TYPE_LW,
            INST_TYPE_LB,
            INST_TYPE_LBU,
            INST_TYPE_LH,
            INST_TYPE_LHU,
            INST_TYPE_SW,
            INST_TYPE_SH,
            INST_TYPE_SB: begin // 5 cycles
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: next_cycle <= T4;
                    T4: begin next_cycle <= T5;end
                    // T5: cycle <= T1;
                    default: begin next_cycle <= T1; end
                endcase
            end

            INST_TYPE_BREAK,
            INST_TYPE_SYSCALL: begin
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: next_cycle <= T4;
                    T4: next_cycle <= T5;
                    T5:  begin next_cycle <= T6;end
                    default: begin next_cycle <= T1;end
                endcase
            end

            INST_TYPE_TEQ: begin
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: begin next_cycle <= T4; end
                    T4: if(teq_equal) next_cycle <= T5;
                        else begin next_cycle <= T1; end
                    T5: next_cycle <= T6;
                    T6: next_cycle <= T7;
                    T7:  begin next_cycle <= T8;  end
                    default: begin  next_cycle <= T1;  end
                endcase
            end


            default: begin //containing ERET
                case(cycle)
                    T1: next_cycle <= T2;
                    T2: next_cycle <= T3;
                    T3: begin  next_cycle <= T4; end
                    default:begin next_cycle <= T1; end
                endcase
            end

        endcase
    end


/*-----------------------------------------------------------------------------------------------*/

    // fetch bits
    assign IM_R         = t1;
    assign IR_in        = t1;
    assign IR_out       = 1;
    // read/write CP0
    assign CP0_Rd_in    = (_mtc0 && t3) ||
                          (_teq && (t5||t6||t8)) || 
                          (_bs && (t3||t4||t6)) ||
                          (_eret && t3);
    assign CP0_Rd_out   = (_mfc0 && t3) || (_teq && t7) || (_bs && t5) || (_eret && t4);
    assign t_status_in  = (_teq && t7) || (_bs && t5);
    assign t_status_out = _eret && t3;
    // PC
    assign PC_in        = t2 || (_b_branch && t6)
                             || ((_j || _jr) && t3) 
                             || ((_jal || _jalr) && t4)
                             || (_teq && t8)
                             || (_bs && t6)
                             || (_eret && t4); 
    assign PC_out       = t1 || (_b_branch && t5)
                             || ((_jal || _jalr) && t3)
                             || (_teq && t5) 
                             || (_bs && t3)
                             || (_j || _jal); // it needs pc
    // M
    assign M_R              =  _l_load && t4;
    assign M_W              = _s_store && t5;
    assign DMEM_is_byte     = _lb || _lbu || _sb;
    assign DMEM_is_half     = _lh || _lhu || _sh;
    assign DMEM_is_signed   = _lb || _lh;

    // DRw
    assign DRw_in       = _s_store && t4;          
    assign DRw_out      = _s_store && t5;
    // DR                  
    assign DRr_in       = _l_load && t4;
    assign DRr_out      = _l_load && t5;
    // Z
    assign Z_in         = t1 || (t3 && (_r_sum_t || _i_sum_t || _sh_sum_t ||
                                 _l_load || _s_store || _b_branch || _teq))
                            || (_b_branch && t5) 
                            || (_teq && t7)
                            || (_bs && t5);
    assign Z_out        = t2 
                            || (t4 && (_r_sum_t || _i_sum_t || _sh_sum_t || _b_branch || _teq ))
                            || ((_l_load & t4) || (_s_store && t5))
                            || (_teq && t8)
                            || (_b_branch & t6)
                            || (_bs && t6);
    // GR
    assign GR_in        = (t4 && (_r_sum_t || _i_sum_t || _sh_sum_t)) || (t5 && _l_load)
                            || ((_jal || _jalr) && t3)
                            || ((_mflo || _mfhi || _mfc0) && t3)
                            || (t4 && _clz);
    assign GR_R1_out    = (t3 && (_r_sum_t || _i_sum_t || _b_branch || _l_load || _jr || _md || _clz||_teq)) 
                            || (t4 && (_jalr))
                            || (t3 && (_mtlo || _mthi))
                            || (t3 && _s_store)
                            ;

                        // rd is actually rt here
    assign GR_R2_out    = (t3 && (_r_sum_t || _sh_sum_t || _b_branch || _md 
                            || _mtc0 || _mtlo || _mthi||_teq))
                           || (t4 && _s_store);
                            
    // LO, HI
    assign LO_in        =  (t4 && _md) || (t3 && _mtlo);
    assign LO_out       =  t3 && _mflo;
    assign HI_in        =  (t4 && _md) || (t3 && _mthi);
    assign HI_out       =  t3 && _mfhi;

    // branch
    // when branch on;
    // inbgez, we see negative bit
    // in bne, we see zero bit
    // in beq, we see zero bit
    assign branch_on = (_beq && t4 && zero) || (_bne && t4 && !zero) || (_bgez && t4 && !negative);

    // teq 
    assign teq_equal = (_teq && t4 && zero);

    // andi, ori, xori
    assign ext16_unsigned = _ori || _andi || _xori;

    // 
    assign GR_R1_ADDR_RD = _mfhi || _mthi;
/*-----------------------------------------------------------------------------------------------*/
    // MULT, DIV
    assign mult_signed  = _mult;
    assign div_signed   = _div;

    wire mult_start_next;
    assign mult_start_next = (_mult || _multu) && !mult_busy && t2;
    always @(posedge clk or posedge rst) begin
        if(rst) mult_start <= 0;
        else begin
            if(mult_start) mult_start <= 0;
            else mult_start <= mult_start_next;

        end
    end
    // 使用状态机协调div_busy 与 div_start的关系，关键是记录div_start恢复的状态, 因为他只开一个周期
    wire div_start_next;
    assign div_start_next = (_div || _divu) && !div_busy && t2;
    always @(posedge clk or posedge rst) begin
        if(rst) div_start <= 0;
        else begin
            if(div_start) div_start <= 0;
            else div_start <= div_start_next;// div_busy时不能回归1
        end
    end

    // clz
    wire clz_start_next;
    assign clz_start_next = _clz && !clz_busy && t2;
    always @(posedge clk or posedge rst) begin
        if(rst) clz_start <= 0;
        else begin
            if(clz_start) clz_start <= 0;
            else clz_start <= clz_start_next;
        end
    end

 /*-----------------------------------------------------------------------------------------------*/
    wire [2:0] is_last_cycle;
    assign is_last_cycle = (next_cycle == T1);
    assign next_update_ir = t2;//刚取到的指令
    assign next_update_pc = t1;
    assign mask_update = is_last_cycle;//指令最后一个周期
    assign pc_for_final_test_update = is_last_cycle;
 /*-----------------------------------------------------------------------------------------------*/





  // 下面是MUX的信号
 /*-----------------------------------------------------------------------------------------------*/
    //选择PC
    parameter MUXT_PC_W_DATA_Z      = 3'd0;
    parameter MUXT_PC_W_DATA_EPC    = 3'd1;
    parameter MUXT_PC_W_DATA_JAL    = 3'd2; // j and jal
    parameter MUXT_PC_W_DATA_J      = 3'd3;    
    parameter MUXT_PC_W_DATA_RS     = 3'd4; // jalr, jr
    parameter MUXT_PC_W_DATA_0x4    = 3'd5;
    parameter MUXT_PC_W_DATA_NONE   = 3'd7;

    always @(*) begin
        if(t2 || (_b_branch && t6))             MUXT_PC_W_DATA <= MUXT_PC_W_DATA_Z;
        else if(_j && t3)                       MUXT_PC_W_DATA <= MUXT_PC_W_DATA_J;
        else if(_jal && t4)                     MUXT_PC_W_DATA <= MUXT_PC_W_DATA_JAL;  
        else if((_jalr && t4)||(_jr && t3))     MUXT_PC_W_DATA <= MUXT_PC_W_DATA_RS;    
        else if((_teq && t8) || (_bs && t6))    MUXT_PC_W_DATA <= MUXT_PC_W_DATA_0x4;
        else if(t4 && _eret)                    MUXT_PC_W_DATA <= MUXT_PC_W_DATA_EPC;
        else                                    MUXT_PC_W_DATA <= MUXT_PC_W_DATA_NONE;
    end
 /*-----------------------------------------------------------------------------------------------*/
    assign MUXT_CP0_WDATA_PC        = (t5 && _teq) || (t3 && _bs);
    assign MUXT_CP0_WDATA_Z         = (t8 && _teq) || (t6 && _bs);
    assign MUXT_CP0_WDATA_T_STATUS  = (t4 && _eret);
    assign MUXT_CP0_WDATA_IR        = (t6 && _teq) || (t4 && _bs);
    assign MUXT_CP0_WDATA_RT        = t3 && _mtc0;
  /*-----------------------------------------------------------------------------------------------*/
    assign MUXT_CP0_W_CAUSE  =  MUXT_CP0_WDATA_IR ; //(t6 && _teq) || (t4 && _bs) ;
    assign MUXT_CP0_W_EPC    = (t5 && _teq) || (t3 && _bs) ;
    assign MUXT_CP0_W_STATUS = MUXT_CP0_WDATA_T_STATUS || MUXT_CP0_WDATA_Z; // t_status和ZX写入cp0.status
    assign MUXT_CP0_W_RD     = t3 && _mtc0;
    //(t8 && _teq) || (t6 && _bs) || (t3 && _eret);

  /*-----------------------------------------------------------------------------------------------*/
    //TODO: MUX_CP0_RADDR,
    assign MUXT_CP0_R_RD    = t3 && _mfc0;
    assign MUXT_CP0_R_STATUS = (t7 && _teq) || (t5 && _bs);
    assign MUXT_CP0_R_EPC   = t4 && _eret;

  /*-----------------------------------------------------------------------------------------------*/
    parameter MUXT_ALU_A_RS     = 3'd0;
    parameter MUXT_ALU_A_PC     = 3'd1;
    parameter MUXT_ALU_A_EXT5   = 3'd2;
    parameter MUXT_ALU_A_5      = 3'd3;
    parameter MUXT_ALU_A_NONE   = 3'd7;

    parameter MUXT_ALU_B_4          = 3'd0;
    parameter MUXT_ALU_B_RT         = 3'd1;
    parameter MUXT_ALU_B_EXT16      = 3'd2;
    parameter MUXT_ALU_B_EXT18      = 3'd3; 
    parameter MUXT_ALU_B_0          = 3'd4;
    parameter MUXT_ALU_B_CP0_STATUS = 3'd5;
    parameter MUXT_ALU_B_NONE       = 3'd7;

    always @(*) begin
        if(t1) begin MUXT_ALU_A <= MUXT_ALU_A_PC; MUXT_ALU_B <= MUXT_ALU_B_4; end
        else if(_b_branch) begin
            if(t3)      begin MUXT_ALU_A <= MUXT_ALU_A_RS;   
                              MUXT_ALU_B <= _bgez ? MUXT_ALU_B_0 : MUXT_ALU_B_RT;    end
            else if(t5) begin MUXT_ALU_A <= MUXT_ALU_A_PC;MUXT_ALU_B <= MUXT_ALU_B_EXT18;  end
            else        begin MUXT_ALU_A <= MUXT_ALU_A_NONE; MUXT_ALU_B <= MUXT_ALU_B_NONE;   end
        end
        else if(_teq) begin
            if(t3)      begin MUXT_ALU_A <= MUXT_ALU_A_RS; MUXT_ALU_B <= MUXT_ALU_B_RT; end
            else if(t7) begin MUXT_ALU_A <= MUXT_ALU_A_5;  MUXT_ALU_B <= MUXT_ALU_B_CP0_STATUS; end
            else        begin MUXT_ALU_A <= MUXT_ALU_A_NONE; MUXT_ALU_B <= MUXT_ALU_B_NONE; end
        end
        else if(_bs)    begin 
            MUXT_ALU_A <= MUXT_ALU_A_5;
            MUXT_ALU_B <= MUXT_ALU_B_CP0_STATUS;
        end
        else if(_r_sum_t) begin
            MUXT_ALU_A <= MUXT_ALU_A_RS;
            MUXT_ALU_B <= MUXT_ALU_B_RT;
        end
        else if(_i_sum_t || _l_load || _s_store) begin
            MUXT_ALU_A <= MUXT_ALU_A_RS;
            MUXT_ALU_B <= MUXT_ALU_B_EXT16;
        end
        else if(_sh_sum_t) begin 
            MUXT_ALU_A <= MUXT_ALU_A_EXT5;
            MUXT_ALU_B <= MUXT_ALU_B_RT;
        end
        else begin MUXT_ALU_A <= MUXT_ALU_A_NONE; MUXT_ALU_B <= MUXT_ALU_B_NONE; end
    end

  /*-----------------------------------------------------------------------------------------------*/
    always @(*) begin
        if(t1) alu_code <= ALUCODE_ADDU;
        else if(_b_branch) begin
            if(t3)      alu_code <= ALUCODE_SUB;
            else if(t5) alu_code <= ALUCODE_ADD;
            else        alu_code <= ALUCODE_NONE;
        end
        else if(_teq) begin
            if(t3)      alu_code <= ALUCODE_SUB;
            else if(t7) alu_code <= ALUCODE_SLL;
            else        alu_code <= ALUCODE_NONE;
        end
        else            alu_code <= alu_code_t;
    end
  /*-----------------------------------------------------------------------------------------------*/
    parameter MUX_GR_W_DATA_Z         = 3'd0;
    parameter MUX_GR_W_DATA_DRr       = 3'd1;
    parameter MUX_GR_W_DATA_HI        = 3'd2;
    parameter MUX_GR_W_DATA_LO        = 3'd3;
    parameter MUX_GR_W_DATA_PC        = 3'd4;
    parameter MUX_GR_W_DATA_CLZ       = 3'd5;
    parameter MUX_GR_W_DATA_CP0       = 3'd6;
    parameter MUX_GR_W_DATA_NONE      = 3'd7;
    always @(*) begin
        if(_r_sum_t || _i_sum_t || _sh_sum_t) // from Z to
            MUX_GR_W_DATA <= MUX_GR_W_DATA_Z;
        else if(_l_load)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_DRr;
        else if(_jal || _jalr)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_PC;
        else if(_mflo)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_LO;
        else if(_mfhi)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_HI;
        else if(_clz)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_CLZ;
        else if(_mfc0)
            MUX_GR_W_DATA <= MUX_GR_W_DATA_CP0;
        else
            MUX_GR_W_DATA <= MUX_GR_W_DATA_NONE;
    end
  /*-----------------------------------------------------------------------------------------------*/
    assign MUX_GR_W_ADDR_RD           = _r_sum_t || _sh_sum_t || _b_branch 
                                        || _jalr || _mflo || _mfhi || _clz;
    assign MUX_GR_W_ADDR_RT           = _i_sum_t || _l_load || _mfc0;
    assign MUX_GR_W_ADDR_31           = _jal;
  /*-----------------------------------------------------------------------------------------------*/


  /*-----------------------------------------------------------------------------------------------*/
    assign MUX_HI_WDATA_RS      = _mthi;
    assign MUX_HI_WDATA_MULT    = _mult || _multu;
    assign MUX_HI_WDATA_DIV     = _div || _divu;

    assign MUX_LO_WDATA_RS      = _mtlo;
    assign MUX_LO_WDATA_MULT    = _mult || _multu;
    assign MUX_LO_WDATA_DIV     = _div || _divu;

endmodule
