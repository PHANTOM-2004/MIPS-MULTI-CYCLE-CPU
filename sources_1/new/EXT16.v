module EXT16(
    input  [15:0]  content,
    input is_unsigned,
    output [31:0]  ext16
);
//32-16=16
//这里必然是有符号扩展
assign ext16 =  {{16{content[15]&&!is_unsigned}},content};

endmodule