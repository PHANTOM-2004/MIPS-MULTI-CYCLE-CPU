module MULT(
    input clk,
    input rst,
    input start,
    input mult_signed,
    input [31:0] a,
    input [31:0] b,
    output reg [63:0] z,
    output reg busy
    );

    reg [63:0] res;
    reg [63:0] s_0;
    reg [63:0] s_1;
    reg [63:0] s_2;
    reg [63:0] s_3;
    reg [63:0] s_4;
    reg [63:0] s_5;
    reg [63:0] s_6;
    reg [63:0] s_7;
    reg [63:0] s_8;
    reg [63:0] s_9;
    reg [63:0] s_10;
    reg [63:0] s_11;
    reg [63:0] s_12;
    reg [63:0] s_13;
    reg [63:0] s_14;
    reg [63:0] s_15;
    reg [63:0] s_16;
    reg [63:0] s_17;
    reg [63:0] s_18;
    reg [63:0] s_19;
    reg [63:0] s_20;
    reg [63:0] s_21;
    reg [63:0] s_22;
    reg [63:0] s_23;
    reg [63:0] s_24;
    reg [63:0] s_25;
    reg [63:0] s_26;
    reg [63:0] s_27;
    reg [63:0] s_28;
    reg [63:0] s_29;
    reg [63:0] s_30;
    reg [63:0] s_31;

    reg [31:0] t_a;
    reg [31:0] t_b;

    reg [63:0] add1_0_1;
    reg [63:0] add1_2_3;
    reg [63:0] add1_4_5;
    reg [63:0] add1_6_7;
    reg [63:0] add1_8_9;
    reg [63:0] add1_10_11;
    reg [63:0] add1_12_13;
    reg [63:0] add1_13_14;
    reg [63:0] add1_14_15;
    reg [63:0] add1_16_17;
    reg [63:0] add1_18_19;
    reg [63:0] add1_20_21;
    reg [63:0] add1_22_23;
    reg [63:0] add1_24_25;
    reg [63:0] add1_26_27;
    reg [63:0] add1_28_29;
    reg [63:0] add1_30_31;

    reg [63:0] add2_0_3;
    reg [63:0] add2_4_7;
    reg [63:0] add2_8_11;
    reg [63:0] add2_12_15;
    reg [63:0] add2_16_19;
    reg [63:0] add2_20_23;
    reg [63:0] add2_24_27;
    reg [63:0] add2_28_31;

    reg [63:0] add3_0_7;
    reg [63:0] add3_8_15;
    reg [63:0] add3_16_23;
    reg [63:0] add3_24_31;

    reg [63:0] add4_0_15;
    reg [63:0] add4_16_31;

    reg [2:0] cnt;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res         <=0;
            s_0         <=0;
            s_1         <=0;
            s_2         <=0;
            s_3         <=0;
            s_4         <=0;
            s_5         <=0;
            s_6         <=0;
            s_7         <=0;
            s_8         <=0;
            s_9         <=0;
            s_10        <=0;
            s_11        <=0;
            s_12        <=0;
            s_13        <=0;
            s_14        <=0;
            s_15        <=0;
            s_16        <=0;
            s_17        <=0;
            s_18        <=0;
            s_19        <=0;
            s_20        <=0;
            s_21        <=0;
            s_22        <=0;
            s_23        <=0;
            s_24        <=0;
            s_25        <=0;
            s_26        <=0;
            s_27        <=0;
            s_28        <=0;
            s_29        <=0;
            s_30        <=0;
            s_31        <=0;

            t_a         <=0;
            t_b         <=0;
        
            add1_0_1    <=0;
            add1_2_3    <=0;
            add1_4_5    <=0;
            add1_6_7    <=0;
            add1_8_9    <=0;
            add1_10_11  <=0;
            add1_12_13  <=0;
            add1_14_15  <=0;
            add1_16_17  <=0;
            add1_18_19  <=0;
            add1_20_21  <=0;
            add1_22_23  <=0;
            add1_24_25  <=0;
            add1_26_27  <=0;
            add1_28_29  <=0;
            add1_30_31  <=0;
        
            add2_0_3    <=0;
            add2_4_7    <=0;
            add2_8_11   <=0;
            add2_12_15  <=0;
            add2_16_19  <=0;
            add2_20_23  <=0;
            add2_24_27  <=0;
            add2_28_31  <=0;

            add3_0_7    <=0;
            add3_8_15   <=0;
            add3_16_23  <=0;
            add3_24_31  <=0;

            add4_0_15   <=0;
            add4_16_31  <=0;

            res <= 0;
            cnt <= 0;
            busy<= 0;
        end
        else if(start) begin
            cnt <= 0;
            busy <= 1;
            t_a <= mult_signed ? (a[31] ? (~a + 32'b1) : a) : a;
            t_b <= mult_signed ? (b[31] ? (~b + 32'b1) : b) : b;
        end
        else begin

            s_0  <= t_b[ 0] ? {32'b0, t_a}         : 64'b0;
            s_1  <= t_b[ 1] ? {31'b0, t_a,  1'b0}  : 64'b0;
            s_2  <= t_b[ 2] ? {30'b0, t_a,  2'b0}  : 64'b0;
            s_3  <= t_b[ 3] ? {29'b0, t_a,  3'b0}  : 64'b0;
            s_4  <= t_b[ 4] ? {28'b0, t_a,  4'b0}  : 64'b0;
            s_5  <= t_b[ 5] ? {27'b0, t_a,  5'b0}  : 64'b0;
            s_6  <= t_b[ 6] ? {26'b0, t_a,  6'b0}  : 64'b0;
            s_7  <= t_b[ 7] ? {25'b0, t_a,  7'b0}  : 64'b0;
            s_8  <= t_b[ 8] ? {24'b0, t_a,  8'b0}  : 64'b0;
            s_9  <= t_b[ 9] ? {23'b0, t_a,  9'b0}  : 64'b0;
            s_10 <= t_b[10] ? {22'b0, t_a, 10'b0}  : 64'b0;
            s_11 <= t_b[11] ? {21'b0, t_a, 11'b0}  : 64'b0;
            s_12 <= t_b[12] ? {20'b0, t_a, 12'b0}  : 64'b0;
            s_13 <= t_b[13] ? {19'b0, t_a, 13'b0}  : 64'b0;
            s_14 <= t_b[14] ? {18'b0, t_a, 14'b0}  : 64'b0;
            s_15 <= t_b[15] ? {17'b0, t_a, 15'b0}  : 64'b0;
            s_16 <= t_b[16] ? {16'b0, t_a, 16'b0}  : 64'b0;
            s_17 <= t_b[17] ? {15'b0, t_a, 17'b0}  : 64'b0;
            s_18 <= t_b[18] ? {14'b0, t_a, 18'b0}  : 64'b0;
            s_19 <= t_b[19] ? {13'b0, t_a, 19'b0}  : 64'b0;
            s_20 <= t_b[20] ? {12'b0, t_a, 20'b0}  : 64'b0;
            s_21 <= t_b[21] ? {11'b0, t_a, 21'b0}  : 64'b0;
            s_22 <= t_b[22] ? {10'b0, t_a, 22'b0}  : 64'b0;
            s_23 <= t_b[23] ? {9'b0 , t_a, 23'b0}  : 64'b0;
            s_24 <= t_b[24] ? {8'b0 , t_a, 24'b0}  : 64'b0;
            s_25 <= t_b[25] ? {7'b0 , t_a, 25'b0}  : 64'b0;
            s_26 <= t_b[26] ? {6'b0 , t_a, 26'b0}  : 64'b0;
            s_27 <= t_b[27] ? {5'b0 , t_a, 27'b0}  : 64'b0;
            s_28 <= t_b[28] ? {4'b0 , t_a, 28'b0}  : 64'b0;
            s_29 <= t_b[29] ? {3'b0 , t_a, 29'b0}  : 64'b0;
            s_30 <= t_b[30] ? {2'b0 , t_a, 30'b0}  : 64'b0;
            s_31 <= t_b[31] ? {1'b0 , t_a, 31'b0}  : 64'b0;

            add1_0_1   <= s_0  +  s_1;
            add1_2_3   <= s_2  +  s_3;
            add1_4_5   <= s_4  +  s_5;
            add1_6_7   <= s_6  +  s_7;
            add1_8_9   <= s_8  +  s_9;
            add1_10_11 <= s_10 + s_11;
            add1_12_13 <= s_12 + s_13;
            add1_14_15 <= s_14 + s_15;
            add1_16_17 <= s_16 + s_17;
            add1_18_19 <= s_18 + s_19;
            add1_20_21 <= s_20 + s_21;
            add1_22_23 <= s_22 + s_23;
            add1_24_25 <= s_24 + s_25;
            add1_26_27 <= s_26 + s_27;
            add1_28_29 <= s_28 + s_29;
            add1_30_31 <= s_30 + s_31;

            add2_0_3   <= add1_0_1   + add1_2_3;
            add2_4_7   <= add1_4_5   + add1_6_7;
            add2_8_11  <= add1_8_9   + add1_10_11;
            add2_12_15 <= add1_12_13 + add1_14_15;
            add2_16_19 <= add1_16_17 + add1_18_19;
            add2_20_23 <= add1_20_21 + add1_22_23;
            add2_24_27 <= add1_24_25 + add1_26_27;
            add2_28_31 <= add1_28_29 + add1_30_31;

            add3_0_7   <= add2_0_3   + add2_4_7;
            add3_8_15  <= add2_8_11  + add2_12_15;
            add3_16_23 <= add2_16_19 + add2_20_23;
            add3_24_31 <= add2_24_27 + add2_28_31;

            add4_0_15  <= add3_0_7   + add3_8_15;
            add4_16_31 <= add3_16_23 + add3_24_31;

            res <= add4_0_15 + add4_16_31;

            cnt <= cnt + 1;
            if(cnt == 3'd5) busy <= 0;

            z <= mult_signed ? (a[31] == b[31] ? res : ~res + 64'b1) : res;
        end
    end

endmodule
