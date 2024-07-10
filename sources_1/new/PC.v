module PC(
    input clk,//pc应该在时钟下降沿写入
    input rst,
    input read,
    input write,
    output [31:0] PC_CONSTANT,
    input  [31:0] data_in,
    output [31:0] data_out
    );
    parameter IMEM_ADDRESS_OFFSET = 32'h00400000;
    reg [31:0] pc_reg;
    
    assign PC_CONSTANT = pc_reg;

    assign data_out = read ? pc_reg : 32'h0;
    //下降沿写入数据
    always @(negedge clk or posedge rst)
    begin
        if (rst) begin
            pc_reg <= IMEM_ADDRESS_OFFSET + 32'h0;
        end
        else if(write) pc_reg <= data_in;
    end
endmodule

