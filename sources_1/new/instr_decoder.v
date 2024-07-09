`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/06 07:32:14
// Design Name: 
// Module Name: instr_decoder
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


module instr_decoder(
    input [31:0]instruction,

    output wire [4:0] Rsaddr,
    output wire [4:0] Rtaddr,
    output wire [4:0] Rdaddr,
    output wire [4:0] sa,
    output wire [15:0] imm16,
    output wire [25:0] address,
    output wire [2:0]  sel,
    output reg  [3:0] alu_code,
    output reg  [5:0] instr_type
    );
    // alu op
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

    //func code
    parameter ADD   = 6'b100000;
    parameter ADDU  = 6'b100001;
    parameter SUB   = 6'b100010;
    parameter SUBU  = 6'b100011;
    parameter AND   = 6'b100100;
    parameter OR    = 6'b100101;
    parameter XOR   = 6'b100110;
    parameter NOR   = 6'b100111;
    parameter SLT   = 6'b101010;
    parameter SLTU  = 6'b101011;
    parameter SLL   = 6'b000000;
    parameter SRL   = 6'b000010;
    parameter SRA   = 6'b000011;
    parameter SLLV  = 6'b000100;
    parameter SRLV  = 6'b000110;
    parameter SRAV  = 6'b000111;
    parameter JR    = 6'b001000;
    parameter JALR  = 6'b001001;
    parameter MULT  = 6'b011000;
    parameter MULTU = 6'b011001;
    parameter DIV   = 6'b011010;
    parameter DIVU  = 6'b011011;
    parameter MFLO  = 6'b010010;
    parameter MTLO  = 6'b010011;
    parameter MFHI  = 6'b010000;
    parameter MTHI  = 6'b010001;
    parameter TEQ   = 6'b110100;
    parameter BREAK = 6'b001101;
    parameter ERET  = 6'b011000; // COP0 + func
    parameter SYSCALL = 6'b001100;
    parameter CLZ   = 6'b100000; // special2

    //op code
    parameter ADDI  = 6'b001000;
    parameter ADDIU = 6'b001001;
    parameter ANDI  = 6'b001100;
    parameter ORI   = 6'b001101;
    parameter XORI  = 6'b001110;
    parameter LW    = 6'b100011;
    parameter LB    = 6'b100000;
    parameter LBU   = 6'b100100;
    parameter LH    = 6'b100001;
    parameter LHU   = 6'b100101;
    parameter SW    = 6'b101011;
    parameter SB    = 6'b101000;
    parameter SH    = 6'b101001;
    parameter BEQ   = 6'b000100;
    parameter BNE   = 6'b000101;
    parameter SLTI  = 6'b001010;
    parameter SLTIU = 6'b001011;
    parameter LUI   = 6'b001111;
    parameter J     = 6'b000010;
    parameter JAL   = 6'b000011;


    // bgez
    parameter BGEZ  = 5'b00001; // REGIMM + BGEZ
    //MF, MT
    parameter MFC0    = 5'b00000;
    parameter MTC0    = 5'b00100;


    // code
    parameter SPECIAL  = 6'b000000;
    parameter REGIMM   = 6'b000001;
    parameter COP0     = 6'b010000;
    parameter SPECIAL2 = 6'b011100;

    wire [5:0] op;
    wire [5:0] func;
    wire [4:0] MTF;
    reg  [2:0] type;

    assign op       = instruction[31:26];
    assign Rsaddr   = instruction[25:21];
    assign Rtaddr   = instruction[20:16];
    assign Rdaddr   = instruction[15:11];
    assign sa       = instruction[10:6];
    assign func     = instruction[5:0];
    assign imm16    = instruction[15:0];
    assign address  = instruction[25:0];
    assign MTF      = instruction[25:21];
    assign sel      = instruction[2:0];

    

    parameter IMM_REF_OP        = 3'b000;
    parameter SPECIAL_REF_FUNC  = 3'b001;
    parameter REGIMM_REF_BGEZ   = 3'b010;
    parameter COP0_REF_FUNC     = 3'b011;
    parameter COP0_REF_MTF      = 3'b100;
    parameter SPECIAL2_REF_FUNC = 3'b101;

    always @(*) begin
        case(op) 
            SPECIAL:    type <= SPECIAL_REF_FUNC;
            SPECIAL2:   type <= SPECIAL2_REF_FUNC;
            REGIMM:     type <= REGIMM_REF_BGEZ;
            COP0:       begin
                case(MTF)   
                    MTC0,MFC0:  type <= COP0_REF_MTF;
                    default type <= COP0_REF_FUNC;
                endcase
            end
            default:    type <= IMM_REF_OP; 
        endcase
    end

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





    always @(*) begin
        case(type)
            IMM_REF_OP: begin
                case(op)
                ADDI:           begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_ADDI;   end
                SW:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_SW;     end
                SB:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_SB;     end
                SH:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_SH;     end
                LW:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_LW;     end
                LB:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_LB;     end
                LBU:            begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_LBU;    end
                LH:             begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_LH;     end
                LHU:            begin alu_code <= ALUCODE_ADD;  instr_type <= INST_TYPE_LHU;    end
                ADDIU:          begin alu_code <= ALUCODE_ADDU; instr_type <= INST_TYPE_ADDIU;  end
                BEQ:            begin alu_code <= ALUCODE_SUBU; instr_type <= INST_TYPE_BEQ;    end
                BNE:            begin alu_code <= ALUCODE_SUBU; instr_type <= INST_TYPE_BNE;    end
                ANDI:           begin alu_code <= ALUCODE_AND;  instr_type <= INST_TYPE_ANDI;   end
                ORI:            begin alu_code <= ALUCODE_OR;   instr_type <= INST_TYPE_ORI;    end
                XORI:           begin alu_code <= ALUCODE_XOR;  instr_type <= INST_TYPE_XORI;   end
                SLTI:           begin alu_code <= ALUCODE_SLT;  instr_type <= INST_TYPE_SLTI;   end
                SLTIU:          begin alu_code <= ALUCODE_SLTU; instr_type <= INST_TYPE_SLTIU;  end
                LUI:            begin alu_code <= ALUCODE_LUI;  instr_type <= INST_TYPE_LUI;    end
                J:              begin alu_code <= ALUCODE_NONE; instr_type <= INST_TYPE_J;      end
                JAL:            begin alu_code <= ALUCODE_NONE; instr_type <= INST_TYPE_JAL;    end
                default:        begin alu_code <= ALUCODE_NONE; instr_type <= INST_TYPE_UNKNOWN; end
                endcase
            end

            SPECIAL_REF_FUNC: begin
                case(func)
                ADD:            begin alu_code <= ALUCODE_ADD;   instr_type <= INST_TYPE_ADD;       end
                ADDU:           begin alu_code <= ALUCODE_ADDU;  instr_type <= INST_TYPE_ADDU;      end
                SUB:            begin alu_code <= ALUCODE_SUB;   instr_type <= INST_TYPE_SUB;       end
                SUBU:           begin alu_code <= ALUCODE_SUBU;  instr_type <= INST_TYPE_SUBU;      end
                AND:            begin alu_code <= ALUCODE_AND;   instr_type <= INST_TYPE_AND;       end
                OR:             begin alu_code <= ALUCODE_OR;    instr_type <= INST_TYPE_OR;        end
                XOR:            begin alu_code <= ALUCODE_XOR;   instr_type <= INST_TYPE_XOR;       end
                NOR:            begin alu_code <= ALUCODE_NOR;   instr_type <= INST_TYPE_NOR;       end
                SLL:            begin alu_code <= ALUCODE_SLL;   instr_type <= INST_TYPE_SLL;       end
                SLLV:           begin alu_code <= ALUCODE_SLL;   instr_type <= INST_TYPE_SLLV;      end
                SRL:            begin alu_code <= ALUCODE_SRL;   instr_type <= INST_TYPE_SRL;       end
                SRLV:           begin alu_code <= ALUCODE_SRL;   instr_type <= INST_TYPE_SRLV;      end
                SRAV:           begin alu_code <= ALUCODE_SRA;   instr_type <= INST_TYPE_SRAV;      end
                SRA:            begin alu_code <= ALUCODE_SRA;   instr_type <= INST_TYPE_SRA;       end
                SLT:            begin alu_code <= ALUCODE_SLT;   instr_type <= INST_TYPE_SLT;       end
                SLTU:           begin alu_code <= ALUCODE_SLTU;  instr_type <= INST_TYPE_SLTU;      end
                JR:             begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_JR;        end
                JALR:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_JALR;      end
                MULT:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MULT;      end
                MULTU:          begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MULTU;     end
                DIV:            begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_DIV;       end
                DIVU:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_DIVU;      end
                MFHI:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MFHI;      end
                MTLO:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MTLO;      end
                MFLO:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MFLO;      end
                MTHI:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MTHI;      end
                TEQ:            begin alu_code <= ALUCODE_SUBU;  instr_type <= INST_TYPE_TEQ;       end
                BREAK:          begin alu_code <= ALUCODE_SLL;   instr_type <= INST_TYPE_BREAK;     end
                SYSCALL:        begin alu_code <= ALUCODE_SLL;   instr_type <= INST_TYPE_SYSCALL;   end 
                default:        begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_UNKNOWN;   end
                endcase
            end

            SPECIAL2_REF_FUNC: begin
                // here only clz
                alu_code   <= ALUCODE_NONE;
                instr_type <= INST_TYPE_CLZ;
            end

            REGIMM_REF_BGEZ: begin
                // here only BGEZ
                alu_code   <= ALUCODE_SUB;
                instr_type <= INST_TYPE_BGEZ;
            end

            COP0_REF_FUNC: begin
                case(func)
                ERET:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_ERET;      end 
                default:        begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_UNKNOWN;   end
                endcase 
            end

            COP0_REF_MTF: begin
                case(MTF)
                MTC0:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MTC0;      end
                MFC0:           begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_MFC0;      end
                default:        begin alu_code <= ALUCODE_NONE;  instr_type <= INST_TYPE_UNKNOWN;   end
                endcase
            end

            default: begin alu_code <= ALUCODE_NONE; instr_type <= INST_TYPE_UNKNOWN; end

        endcase
    end





endmodule
