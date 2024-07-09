module regfile_tb;
    reg clk;
    reg we;
    reg rst;

    reg [4:0] raddr1;
    reg [4:0] raddr2;

    reg read1;
    reg read2;

    wire [31:0] rdata1;
    reg  [31:0] correct_rdata1;
    wire [31:0] rdata2;
    reg  [31:0] correct_rdata2;

    reg [4:0] waddr;
    reg [31:0] wdata;

    parameter interval = 40;
    parameter short_interval = 20;

    parameter ADDR1 = 5'b00100;
    parameter ADDR2 = 5'b11111;
    parameter ADDR3 = 5'b00000;
    parameter ADDR4 = 5'b01101;
    parameter ADDR5 = 5'b00111;

    parameter DATA1 = 32'hccffccff;
    parameter DATA2 = 32'hffffffff;
    parameter DATA3 = 32'hffff0000;
    parameter DATA4 = 32'h0000ffff;
    parameter DATA5 = 32'hcccccccc;
    parameter DATA6 = 32'h66666666;
    parameter DATA7 = 32'h77777777;
    parameter DATA8 = 32'h88888888;

    regfile inst(
        .clk(clk),
        .rst(rst),
        .we(we),
        .read1(read1),
        .read2(read2),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    always #10 clk = ~clk;

    initial begin
        clk =0;
        we  =0;
        rst =1;
        raddr1=0;
        raddr2=0;
        correct_rdata1=0;
        correct_rdata2=0;
        waddr=0;
        read1=0;
        read2=0;

        # interval;
        rst=0;
        we=1;
        read1=1;
        read2=1;
        waddr = ADDR1;
        wdata = DATA1;

        
        # short_interval;
        raddr1 = ADDR1;
        raddr2 = ADDR2;
        correct_rdata1 = DATA1;
        correct_rdata2 = 0;

        # short_interval;
        read1=0;
        # short_interval;
        read1=1;

        # short_interval;
        read2=0;
        # short_interval;
        read2=1;

        # interval;
        we=1;
        waddr = ADDR2;
        wdata = DATA2;
        # short_interval;
        raddr1 = ADDR1;
        raddr2 = ADDR2;
        correct_rdata1 = DATA1;
        correct_rdata2 = DATA2;

        # interval;
        we=1;
        waddr = ADDR3;
        wdata = DATA3;
        # short_interval;
        raddr1 = ADDR1;
        raddr2 = ADDR3;
        correct_rdata1 = DATA1;
        correct_rdata2 = DATA3;        

        # interval;
        we=1;
        waddr = ADDR4;
        wdata = DATA4;
        # short_interval;
        raddr1 = ADDR3;
        raddr2 = ADDR4;
        correct_rdata1 = DATA3;
        correct_rdata2 = DATA4;


        # interval;
        we=1;
        waddr = ADDR5;
        wdata = DATA5;
        # short_interval;
        raddr1 = ADDR3;
        raddr2 = ADDR5;
        correct_rdata1 = DATA3;
        correct_rdata2 = DATA5;        

        # interval;
        we=1;
        waddr = ADDR2;//change 2
        wdata = DATA6;
        # short_interval;
        raddr1 = ADDR1;
        raddr2 = ADDR2;
        correct_rdata1 = DATA1;
        correct_rdata2 = DATA6;

        # interval;
        we=1;
        waddr = ADDR3;//change 2
        wdata = DATA8;
        # short_interval;
        raddr1 = ADDR2;
        raddr2 = ADDR3;
        correct_rdata1 = DATA6;
        correct_rdata2 = DATA8;

        # interval;
        we=0;
        raddr1 = ADDR1;
        raddr2 = ADDR4;
        correct_rdata1 = DATA1;
        correct_rdata2 = DATA4;
        $stop;
    end


endmodule

