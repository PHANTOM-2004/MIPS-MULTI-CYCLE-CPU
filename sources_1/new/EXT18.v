module EXT18(
    input  [17:0]  content,
    output [31:0] ext18
);
//32-18=14
assign ext18 = {{14{content[17]}},content};

endmodule