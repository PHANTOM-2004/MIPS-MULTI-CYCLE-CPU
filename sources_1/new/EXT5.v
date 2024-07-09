module EXT5(
    input  [4:0]  content,
    output [31:0] ext5
);
// 32-5=27
// 默认是无符号扩展
assign ext5 = {27'b0, content};

endmodule