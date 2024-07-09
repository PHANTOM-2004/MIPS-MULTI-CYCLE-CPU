`timescale 1ns / 1ps

module DIV(//32位有符号不恢复余数除法器
    input [32-1 : 0] dividend,//被除数
    input [32-1 : 0] divisor,//除数
	input div_signed,
    input start,//启动除法运算           
    input clk,
    input rst,//高电平有效
    output [32-1 : 0] q,//商
    output [32-1 : 0] r,//余数     
    output reg busy//除法器忙标志位
);
    parameter BITWIDTH = 32;
    parameter CNTWIDTH = 5;
	
	reg [CNTWIDTH-1 : 0] count;
	reg [BITWIDTH-1 : 0] reg_q;//商
	reg [BITWIDTH-1 : 0] reg_r;//余数
	reg [BITWIDTH-1 : 0] reg_b;//除数
	wire [BITWIDTH-1 : 0] r_t;

    reg dividend_sign;
    reg divisor_sign;
	reg r_sign;

	wire [BITWIDTH : 0] sub_add = r_sign ? 
								({reg_r, reg_q[BITWIDTH-1]} + {1'b0, reg_b}) : 
								({reg_r, reg_q[BITWIDTH-1]} - {1'b0, reg_b});
	assign r_t = r_sign ? reg_r + reg_b : reg_r;
	assign r = div_signed ? (dividend_sign ? (~r_t + 1) : r_t) : r_t;
    assign q = div_signed ? ((divisor_sign ^ dividend_sign) ? (~reg_q + 1) : reg_q) : reg_q;//商
	always @ (posedge clk or posedge rst) begin
		if (rst) begin//重置
			count <= {CNTWIDTH{1'b0}};
			busy  <= 0;
			reg_r <= {BITWIDTH{1'b0}};
			reg_q <= {BITWIDTH{1'b0}};
			reg_b <= {BITWIDTH{1'b0}};
			dividend_sign 	<= 1'b0;
			divisor_sign 	<= 1'b0;
			r_sign <= 1'b0;
		end else begin
			if (start) begin
				reg_r <= {BITWIDTH{1'b0}};
				r_sign <= 0;
				reg_q <= div_signed ? (dividend[BITWIDTH-1] ? ~dividend + 1 : dividend) : dividend;
				reg_b <= div_signed ? (divisor[BITWIDTH-1] ? ~divisor + 1 : divisor) : divisor;
				count <= {CNTWIDTH{1'b0}};
                dividend_sign <= dividend[BITWIDTH-1];
                divisor_sign <= divisor[BITWIDTH-1];
				busy <= 1'b1;
			end else if (busy) begin
				reg_r <= sub_add[BITWIDTH-1 : 0];
				r_sign <= sub_add[BITWIDTH];
				reg_q <= {reg_q[BITWIDTH-2 : 0], ~sub_add[BITWIDTH]};
				count <= count + 5'b1;
				if (count == {CNTWIDTH{1'b1}})
					busy <= 0; 
			end
		end
	end
endmodule