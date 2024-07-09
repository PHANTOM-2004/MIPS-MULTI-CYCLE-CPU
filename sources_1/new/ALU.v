module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output reg [31:0] r,
    output reg zero,
    output reg carry,
    output reg negative,
    output reg overflow
    );
    // reg [32:0] tmp;
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

    always @(*) begin
        
        casex(aluc)

            ALUCODE_ADDU:/*Addu*/begin
                {carry, r} = a + b;
                negative = r[31];
                overflow = overflow;
                zero = !r;
            end

            ALUCODE_ADD:/*Add*/begin
                r = a + b;
                negative = r[31];
                overflow = 
                (a[31]&b[31]&~r[31])|(~a[31]&~b[31]&r[31]);
                zero = !r;
            end
            ALUCODE_SUBU:/*Subu*/begin
                r = a - b;
                negative = r[31];
                carry = ($unsigned(b) > $unsigned(a))? 1 : 0 ;
                zero = !r;
            end
            ALUCODE_SUB:/*Sub*/begin
                r = a - b;
                negative = r[31];
                overflow = 
                (~a[31]&b[31]&r[31])|(a[31]&~b[31]&~r[31]);
                zero = !r;
            end
            ALUCODE_AND:/*And*/begin
                r = a & b;
                negative = r[31];
                zero = !r;
            end
            ALUCODE_OR:/*Or*/begin
                r = a | b;
                carry = carry;
                negative = r[31];
                zero = !r;
            end
            ALUCODE_XOR:/*Xor*/begin
                r = a ^ b;
                negative = r[31];
                zero = !r;
            end
            ALUCODE_NOR:/*Nor*/begin
                r = ~(a | b);
                negative = r[31];
                zero = !r;
            end
            ALUCODE_LUI:/*Lui*/begin
                r = {b[15:0],16'b0};
                negative = r[31];
                zero = !r;
            end
            ALUCODE_SLT:/*Slt*/begin
                r = $signed(a) < $signed(b) ? 1:0;
                negative = r[0];
                zero = (a==b)?1:0;
            end
            ALUCODE_SLTU:/*Sltu*/begin
                r = (a < b) ? 1: 0;
                negative = r[31];
                carry = (a < b) ? 1: 0;
                zero = (a==b)?1:0;
            end
            ALUCODE_SRA:/*Sra*/begin
                r = ($signed(b) >>> a);
                negative = r[31];
                zero = !r;
            end
            ALUCODE_SLL:/*Sll/sla*/begin
                carry = r[32 - a];
                r = b << a;
                negative = r[31];
                zero = !r;
            end
            ALUCODE_SRL:/*srl*/begin
                carry = r[a-1];
                r = b >> a;
                negative = r[31];
                zero = !r;
            end
            default: begin
                carry = 0;
                overflow = 0;
                negative = 0;
                zero = 0;
            end
        endcase

    end

endmodule
