`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/06 13:14:02
// Design Name: 
// Module Name: instr_decoder_tb
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

module instr_decoder_tb;


    reg [31:0] instruction;
    reg clk;

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

    parameter interval = 40;
    parameter small_interval = 20;

    wire [3:0] alu_code;
    reg  [3:0] correct_alu_code;
    wire [5:0] type;
    reg  [5:0] correct_type;
    // reg instr_flag;

    instr_decoder inst(
        .instruction(instruction),
        .alu_code(alu_code),
        .instr_type(type)
        );


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

    wire [2:0]type1 = inst.type;
    wire [5:0]op = inst.op;

    always #10 clk = ~clk;

    initial begin
        clk=0;

        // syscall
        # interval
        instruction = 32'hc;
        correct_alu_code = ALUCODE_SLL;
        correct_type = INST_TYPE_SYSCALL;

        // break;
        # interval
        instruction = 32'hd;
        correct_alu_code = ALUCODE_SLL;
        correct_type = INST_TYPE_BREAK;

        // eret
        # interval
        instruction = 32'h42000018;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_ERET;

        // teq
        # interval
        instruction = 32'h00200034;
        correct_alu_code = ALUCODE_SUBU;
        correct_type = INST_TYPE_TEQ;


        // clz
        // 70000820
        // 70200820
        #interval
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_CLZ;
        instruction = 32'h70000020;
        #small_interval
        instruction = 32'h70200820;

        // divu
        /*
            divu $30,$31
        */
        # interval
        correct_alu_code = ALUCODE_NONE;
        correct_type     = INST_TYPE_DIVU;
        instruction =32'h03df001b;

        // div
        /*
            div $30,$31
        */
        # interval
        correct_alu_code = ALUCODE_NONE;
        correct_type     = INST_TYPE_DIV;
        instruction =32'h03df001a;

        // jalr
        // jalr $30,$1
        # interval
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_JALR;
        instruction = 32'h0020f009;

        // lb
        // lb $1,31($1)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_LB;
        instruction = 32'h8021001f;

        // sb
        // sb $31,31($1)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_SB;
        instruction = 32'ha03f001f;

        // lbu
        // lbu $1,31($1)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type =INST_TYPE_LBU;
        instruction =32'h9021001f;

        // lh
        // lh $30,0($31)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_LH;
        instruction = 32'h87fe0000;

        // lhu
        // 97fe0000 lhu $30,0($31)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_LHU;
        instruction = 32'h97fe0000;

        // sb
        // sb $31,62($1)
        # interval
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_SB;
        instruction = 32'ha03f003e;


        // sh
        // sh $31, 62($1)
        # interval;
        correct_alu_code = ALUCODE_ADD;
        correct_type = INST_TYPE_SH;
        instruction = 32'ha43f003e;

        // mtc0 $14,$14
        # interval;
        instruction = 32'h408e7000;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MTC0;


        // mfc0 $4,$14
        # interval;
        instruction = 32'h40047000;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MFC0;

        // mthi $1
        # interval
        instruction=32'h00200011;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MTHI;


        // mfhi $7
        # interval
        instruction=32'h00003810;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MFHI;

        // mtlo $1
        #interval
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MTLO;
        instruction = 32'h00200013;
    


        // mflo $7
        # interval
        instruction = 32'h00003812;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MFLO;

        // mult $30,$31
        # interval
        instruction = 32'h03df0018;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MULT;


        // multu $30,$31
        # interval
        instruction = 32'h03df0019;
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_MULTU;




        /*31 instructions  below, test last time*/        

        #interval;//addi
        correct_type = INST_TYPE_ADDI;
        correct_alu_code = ALUCODE_ADD;
        instruction =32'h2000ffff;
        #small_interval
        instruction =32'h20010001;
        #small_interval
        instruction =32'h20028000;
        /*
        addi $0,$0,0xffffffff
        addi $1,$0,0x0001
        addi $2,$0,0xffff8000
        */
        #interval;//addiu
        correct_type = INST_TYPE_ADDIU;
        correct_alu_code = ALUCODE_ADDU;
        instruction = 32'h2400ffff;
        #small_interval
        instruction = 32'h24010001;
        #small_interval
        instruction = 32'h24028000;
        
        /*
        addiu $0,$0,0xffffffff
        addiu $1,$0,0x0001
        addiu $2,$0,0xffff8000
        */

        #interval;//lui
        correct_type = INST_TYPE_LUI;
        correct_alu_code = ALUCODE_LUI;
        instruction = 32'h3c000000;
        #small_interval
        instruction = 32'h3c010001;
        #small_interval
        instruction = 32'h3c028000;
        /*
        lui $0, 0x0000
        lui $1, 0x0001  
        lui $2, 0x8000
        */

        #interval;//add
        correct_type = INST_TYPE_ADD;
        correct_alu_code = ALUCODE_ADD;

        instruction=32'h03e1f820;
        #small_interval
        instruction=32'h03e2f820;
        #small_interval
        instruction=32'h03e3f820;
        /*
        add $31,$31,$1
        add $31,$31,$2
        add $31,$31,$3
        */

        #interval;//addu
        correct_type = INST_TYPE_ADDU;
        correct_alu_code = ALUCODE_ADDU;
        instruction=32'h03e1f821;
        #small_interval
        instruction=32'h03e2f821;
        #small_interval
        instruction=32'h03e3f821;
        /*addu $31,$31,$1
        addu $31,$31,$2
        addu $31,$31,$3*/

        #interval;//andi
        correct_type = INST_TYPE_ANDI;
        correct_alu_code = ALUCODE_AND;
        instruction=32'h33bd5555;
        #small_interval
        instruction=32'h33deaaaa;
        #small_interval
        instruction=32'h33ff1234;
        /*
        andi $29,$29,0x5555
        andi $30,$30,0xaaaa
        andi $31,$31,0x1234
        */

        #interval;//and
        correct_type = INST_TYPE_AND;
        correct_alu_code = ALUCODE_AND;
        instruction=32'h03e4a824;
        #small_interval
        instruction=32'h03e1a824;
        #small_interval
        instruction=32'h03e3a824;
        /*
        and $21,$31,$4
        and $21,$31,$1
        and $21,$31,$3
        */

        #interval;//sw
        correct_type = INST_TYPE_SW;
        correct_alu_code = ALUCODE_ADD;
        instruction=32'hac3f007c;
        //sw $31,124($1)

        #interval;//lw
        correct_type = INST_TYPE_LW;
        correct_alu_code = ALUCODE_ADD;
        instruction=32'h8c21007c;
        //lw $1,124($1)

        #interval;//nor
        correct_type = INST_TYPE_NOR;
        correct_alu_code = ALUCODE_NOR;
        instruction=32'h03e4a827;
        #small_interval
        instruction=32'h03e1a827;
        #small_interval
        instruction=32'h03e3a827;
        // nor $21,$31,$4
        // nor $21,$31,$1
        // nor $21,$31,$3

        #interval;//or
        correct_type = INST_TYPE_OR;
        correct_alu_code = ALUCODE_OR;
        instruction=32'h03e4a825;
        #small_interval
        instruction=32'h03e1a825;
        #small_interval
        instruction=32'h03e3a825;
        //or $21,$31,$4
        //or $21,$31,$1
        //or $21,$31,$3

        #interval; //ori
        correct_type = INST_TYPE_ORI;
        correct_alu_code = ALUCODE_OR;
        instruction=32'h37bd5555;
        #small_interval
        instruction=32'h37deaaaa;
        #small_interval
        instruction=32'h37ff1234;

        // ori $29,$29,0x5555
        // ori $30,$30,0xaaaa
        // ori $31,$31,0x1234
        
        #interval;//sll
        correct_type = INST_TYPE_SLL;
        correct_alu_code = ALUCODE_SLL;
        instruction=32'h001fe840;
        #small_interval
        instruction=32'h001ff7c0;
        #small_interval
        instruction=32'h001ff800;
        // sll $29,$31,1
        // sll $30,$31,31
        // sll $31,$31,0

        #interval;//sllv
        correct_type = INST_TYPE_SLLV;
        correct_alu_code = ALUCODE_SLL;
        instruction=32'h03fff004;
        #small_interval
        instruction=32'h001ff804;
        // sllv $30,$31,$31
        // sllv $31,$31,$0

        #interval;//slt
        correct_type = INST_TYPE_SLT;
        correct_alu_code = ALUCODE_SLT;
        instruction=32'h00c1182a;
        #small_interval
        instruction=32'h00c1202a;
        #small_interval
        instruction=32'h00c1282a;
        // slt $3,$6,$1
        // slt $4,$6,$1
        // slt $5,$6,$1

        #interval;//slti
        correct_type = INST_TYPE_SLTI;
        correct_alu_code = ALUCODE_SLT;
        instruction=32'h2bbd8000;
        #small_interval
        instruction=32'h2bde7fff;
        #small_interval
        instruction=32'h2bff8000;

        // slti $29,$29,0xffff8000
        // slti $30,$30,0x7fff
        // slti $31,$31,0xffff8000

        #interval;//sltiu
        correct_type = INST_TYPE_SLTIU;
        correct_alu_code = ALUCODE_SLTU;
        instruction=32'h2fbd8000;
        #small_interval
        instruction=32'h2fde7fff;
        #small_interval
        instruction=32'h2fff8000;
        // sltiu $29,$29,0xffff8000
        // sltiu $30,$30,0x7fff
        // sltiu $31,$31,0xffff8000

        #interval;//sltu
        correct_type = INST_TYPE_SLTU;
        correct_alu_code = ALUCODE_SLTU;
        instruction=32'h00c1182b;
        #small_interval
        instruction=32'h00c1202b;
        #small_interval
        instruction=32'h00c1282b;
        // sltu $3,$6,$1
        // sltu $4,$6,$1
        // sltu $5,$6,$1

        #interval;//sra
        correct_type = INST_TYPE_SRA;
        correct_alu_code = ALUCODE_SRA;
        instruction=32'h001fe843;
        #small_interval
        instruction=32'h001ff7c3;
        #small_interval
        instruction=32'h001ff803;
        // sra $29,$31,1
        // sra $30,$31,31
        // sra $31,$31,0

        #interval;//srav
        correct_type = INST_TYPE_SRAV;
        correct_alu_code = ALUCODE_SRA;
        instruction=32'h03fff007;
        #small_interval
        instruction=32'h001ff807;
        // srav $30,$31,$31
        // srav $31,$31,$0

        #interval;//srl
        correct_type = INST_TYPE_SRL;
        correct_alu_code = ALUCODE_SRL;
        instruction=32'h001fe842;
        #small_interval
        instruction=32'h001ff7c2;
        #small_interval
        instruction=32'h001ff802;
        // srl $29,$31,1
        // srl $30,$31,31
        // srl $31,$31,0

        #interval;//srlv
        correct_type = INST_TYPE_SRLV;
        correct_alu_code = ALUCODE_SRL;
        instruction=32'h03fff006;
        #small_interval
        instruction=32'h001ff806;
        // srlv $30,$31,$31
        // srlv $31,$31,$0

        #interval;//sub
        correct_type = INST_TYPE_SUB;
        correct_alu_code = ALUCODE_SUB;
        instruction=32'h03e0f822;
        #small_interval
        instruction=32'h03e1f822;
        #small_interval
        instruction=32'h03e2f822;
        // sub $31,$31,$0
        // sub $31,$31,$1
        // sub $31,$31,$2

        #interval;//subu
        correct_type = INST_TYPE_SUBU;
        correct_alu_code = ALUCODE_SUBU;
        instruction=32'h03e1f823;
        #small_interval
        instruction=32'h03e2f823;
        #small_interval
        instruction=32'h03e3f823;
        // subu $31,$31,$1
        // subu $31,$31,$2
        // subu $31,$31,$3

        #interval;//xor
        correct_type = INST_TYPE_XOR;
        correct_alu_code = ALUCODE_XOR;
        instruction=32'h03e4a826;
        #small_interval
        instruction=32'h03e1a826;
        #small_interval
        instruction=32'h03e3a826;
        // xor $21,$31,$4
        // xor $21,$31,$1
        // xor $21,$31,$3

        #interval;//xori
        correct_type = INST_TYPE_XORI;
        correct_alu_code = ALUCODE_XOR;
        instruction=32'h3bbd5555;
        #small_interval
        instruction=32'h3bdeaaaa;
        #small_interval
        instruction=32'h3bff1234;
        // xori $29,$29,0x5555
        // xori $30,$30,0xaaaa
        // xori $31,$31,0x1234

        #interval;//beq
        correct_type = INST_TYPE_BEQ;
        correct_alu_code = ALUCODE_SUBU;
        instruction=32'h10000001;
        // beq $0,$0,TAG1

        #interval;//bne
        correct_type = INST_TYPE_BNE;
        correct_alu_code = ALUCODE_SUBU;        
        instruction=32'h14000017;
        // bne $0,$0,WRONG

        #interval;//j
        correct_type = INST_TYPE_J;
        correct_alu_code = ALUCODE_NONE;
        instruction=32'h08100022;
        // j RIGHT

        #interval;//jal
        correct_type = INST_TYPE_JAL;
        correct_alu_code = ALUCODE_NONE;
        instruction=32'h0c100022;
        // jal RIGHT

        #interval;//jr
        correct_alu_code = ALUCODE_NONE;
        correct_type = INST_TYPE_JR;
        instruction=32'h00200008;
        // jr $1 
        $stop;
    end

endmodule