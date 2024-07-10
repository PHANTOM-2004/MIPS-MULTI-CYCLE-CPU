`timescale 1ns / 1ps



module instr_tb;

	// Inputs
	reg clk_in;
	reg reset;

	// Outputs
	wire [31:0] inst;
	wire [31:0] pc;
	// Instantiate the Unit Under Test (UUT)
	sccomp_dataflow uut (
		.clk_in(clk_in), 
		.reset(reset), 
		.inst(inst),
		.pc(pc)
	);

	integer file_output;
	//integer flag;
	reg [31:0] pc_pre;
	reg [31:0] inst_pre;
	//reg [31:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,reg15,reg16,reg17,reg18,reg19,reg20,reg21,reg22,reg23,reg24,reg25,reg26,reg27,reg28,reg29,reg30,reg31;
    wire [31:0]  PC      = uut.sccpu.cpu_pc.pc_reg;
    wire [31:0] IR      = uut.sccpu.cpu_ir.IR_reg;
    wire [2:0]  cycle   = uut.sccpu.cpu_controller.cycle;

	wire [31:0] cp0_cause_from_ir = uut.sccpu.cp0_cause_from_ir;
	wire MUXT_CP0_WDATA_IR = uut.sccpu.cpu_controller.MUXT_CP0_WDATA_IR;


	// wire [31:0] Cause = ;
	wire MUXT_CP0_W_CAUSE 	= uut.sccpu.cpu_controller.MUXT_CP0_W_CAUSE; // w地址
	wire MUXT_CP0_W_EPC		= uut.sccpu.cpu_controller.MUXT_CP0_W_EPC;
	wire MUXT_CP0_W_STATUS	= uut.sccpu.cpu_controller.MUXT_CP0_W_STATUS;

	wire MUXT_CP0_R_RD		= uut.sccpu.cpu_controller.MUXT_CP0_R_RD;
	wire MUXT_CP0_R_STATUS	= uut.sccpu.cpu_controller.MUXT_CP0_R_STATUS;
	wire MUXT_CP0_R_EPC		= uut.sccpu.cpu_controller.MUXT_CP0_R_EPC;

	wire CP0_Rd_in = uut.sccpu.cpu_controller.CP0_Rd_in;
	wire CP0_Rd_out = uut.sccpu.cpu_controller.CP0_Rd_out;

	wire [4:0] CP0_Rdaddr_r = uut.sccpu.cpu_cp0.Rdaddr_r;
	wire [4:0] CP0_Rdaddr_w = uut.sccpu.cpu_cp0.Rdaddr_w;
	wire [31:0] CP0_rdata   = uut.sccpu.cpu_cp0.rdata;

	wire [31:0] t_status_reg 	= uut.sccpu.tst.t_status_reg;
	wire [31:0] t_status_wdata	= uut.sccpu.t_status_wdata;
	wire [31:0] t_status_rdata  = uut.sccpu.t_status_rdata;
	// Cause
	wire [31:0] CP0_8		= uut.sccpu.cpu_cp0.cp0_array[8];
	wire [31:0] CP0_Cause	= uut.sccpu.cpu_cp0.cp0_array[13];
	wire [31:0] CP0_EPC		= uut.sccpu.cpu_cp0.cp0_array[14];
	wire [31:0] CP0_Status  = uut.sccpu.cpu_cp0.cp0_array[12];

	wire [31:0] DRr_reg = uut.sccpu.cpu_drr.DRr_reg;
    wire [3:0] alu_code       = uut.sccpu.cpu_alu.aluc;
    wire [31:0] Z       = uut.sccpu.z_reg.d;
	wire [2:0] muxt_alu_a = uut.sccpu.cpu_controller.MUXT_ALU_A;
	wire [2:0] muxt_alu_b = uut.sccpu.cpu_controller.MUXT_ALU_B;
	wire [31:0] RS_data = uut.sccpu.RS_data;
	wire [31:0] RT_data = uut.sccpu.RT_data;

	wire branch_on = uut.sccpu.cpu_controller.branch_on;

	wire GR_in		= uut.sccpu.GR_in;
    wire [31:0] alu_a = uut.sccpu.alu_a;
    wire [31:0] alu_b = uut.sccpu.alu_b;
    wire [2:0] MUXT_ALU_A = uut.sccpu.cpu_controller.MUXT_ALU_A;
    wire [31:0] PC_rdata =uut.sccpu.PC_rdata;
    wire ext16_unsigned = uut.sccpu.cpu_controller.ext16_unsigned;
    wire [31:0]ext16_data = uut.sccpu.EXT16_data;
    wire [31:0]gr_wdata = uut.sccpu.MUX_GR_W_DATA_IN;
    wire [4:0] gr_waddr = uut.sccpu.MUX_GR_W_ADDR_IN;
    wire [2:0] gr_wdata_controller = uut.sccpu.MUX_GR_W_DATA;
    wire [2:0] pc_sel = uut.sccpu.cpu_controller.MUXT_PC_W_DATA;
    wire zero = uut.sccpu.zero;
	
	wire [31:0] mask_pc_current = uut.sccpu.mpcir.mask_pc_current;
    wire [31:0] mask_ir_current = uut.sccpu.mpcir.mask_ir_current; 
	wire [31:0] next_pc = uut.sccpu.mpcir.next_pc; 
    wire [31:0] next_ir = uut.sccpu.mpcir.next_ir; 


	wire [31:0] CLZ_rdata = uut.sccpu.CLZ_rdata;
	wire [31:0] CLZ_wdata = uut.sccpu.CLZ_wdata;
    wire mask_update    = uut.sccpu.mpcir.mask_update;
    wire next_update_ir = uut.sccpu.mpcir.next_update_ir;
    wire next_update_pc = uut.sccpu.mpcir.next_update_pc;
	wire [31:0] reg29 = uut.sccpu.cpu_ref.array_reg[29];



	wire [2:0] mult_cnt = uut.sccpu.cpu_mult.cnt;

	wire [31:0] LO_rdata = uut.sccpu.LO_rdata;
	wire [31:0] HI_rdata = uut.sccpu.HI_rdata;
	wire [31:0] LO_wdata = uut.sccpu.LO_wdata;
	wire [31:0] HI_wdata = uut.sccpu.HI_wdata;


	wire [31:0] div_q = uut.sccpu.div_q;
	wire [31:0] div_r = uut.sccpu.div_r;


	wire MUX_LO_WDATA_DIV = uut.sccpu.MUX_LO_WDATA_DIV;
	wire MUX_LO_WDATA_MULT = uut.sccpu.MUX_LO_WDATA_MULT;
	wire MUX_LO_WDATA_RS  = uut.sccpu.MUX_LO_WDATA_RS;

	wire [31:0] HI_reg   = uut.sccpu.cpu_hi.hi_reg;
	wire [31:0] LO_reg	 = uut.sccpu.cpu_lo.lo_reg;

	wire HI_in = uut.sccpu.HI_in;
	wire HI_out = uut.sccpu.HI_out;
	wire LO_in = uut.sccpu.LO_in;
	wire LO_out = uut.sccpu.LO_out;

	wire [31:0]mult_a = uut.sccpu.mult_a;
	wire [31:0]mult_b = uut.sccpu.mult_b;
	wire [63:0]mult_ans = uut.sccpu.mult_ans;
	wire mult_busy = uut.sccpu.mult_busy;
	wire mult_start = uut.sccpu.mult_start;

	wire _mtlo = uut.sccpu.cpu_controller._mtlo;
	wire _mthi = uut.sccpu.cpu_controller._mthi;
	wire [5:0] instr_type = uut.sccpu.instr_type;

    wire dmem_read = uut.sccpu.dmem_read;
    wire dmem_write = uut.sccpu.dmem_write;
    wire [6:0]  dmem_address = uut.sccpu.dmem_address;
    wire [31:0] dmem0 = uut.memory.memory[0];
    wire [31:0] dmem1 = uut.memory.memory[1];
	wire [31:0] dmem2 = uut.memory.memory[2];
	wire [31:0] dmem3 = uut.memory.memory[3];
	wire [31:0] dmem4 = uut.memory.memory[4];
	wire [31:0] dmem5 = uut.memory.memory[5];


	wire [31:0] _4byte = uut.memory._4byte;
	wire [31:0] wdata = uut.memory.wdata;
	wire [4:0] _4byte_addr = uut.memory._4byte_addr;
	wire [1:0] _4byte_inner_pos = uut.memory._4byte_inner_pos;

    wire [31:0] dmem_rdata = uut.sccpu.dmem_rdata;
    wire [31:0] dmem_wdata = uut.sccpu.dmem_wdata;

    wire DRr_in = uut.sccpu.DRr_in;
    wire DRr_out = uut.sccpu.DRr_out;
    wire DRw_in = uut.sccpu.DRw_in;
    wire DRw_out = uut.sccpu.DRw_out;

    wire [31:0] DRr_rdata = uut.sccpu.DRr_rdata;
    wire [31:0] DRr_wdata = uut.sccpu.DRr_wdata;
    wire [31:0] DRw_rdata = uut.sccpu.DRw_rdata;
    wire [31:0] DRw_wdata = uut.sccpu.DRw_wdata;

    wire GR_R1_out  = uut.sccpu.GR_R1_out;
    wire GR_R2_out  = uut.sccpu.GR_R2_out;


    initial begin
		file_output = $fopen("./result/cyt_final.txt");	
		// Initialize Inputs
		clk_in = 0;
		reset = 1;
        //pc初始值32'h00400000
        //inst初始值32'h08100004
		pc_pre = 32'h44436040; 
		inst_pre = 32'h88807704;
		

		// Wait 200 ns for global reset to finish
		#225;
        reset = 0;		
		
		
	end
   
	always begin		
	#50;	
	clk_in = ~clk_in;
	if(clk_in == 1'b1 && reset == 0) begin	
			if(pc_pre != pc)
			begin
			$fdisplay(file_output, "pc: %h", pc);	
			$fdisplay(file_output, "instr: %h", inst);
			$fdisplay(file_output, "regfile0: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[0]);
			$fdisplay(file_output, "regfile1: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[1]);
			$fdisplay(file_output, "regfile2: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[2]);
			$fdisplay(file_output, "regfile3: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[3]);
			$fdisplay(file_output, "regfile4: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[4]);
			$fdisplay(file_output, "regfile5: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[5]);
			$fdisplay(file_output, "regfile6: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[6]);
			$fdisplay(file_output, "regfile7: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[7]);
			$fdisplay(file_output, "regfile8: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[8]);
			$fdisplay(file_output, "regfile9: %h",  instr_tb.uut.sccpu.cpu_ref.array_reg[9]);
			$fdisplay(file_output, "regfile10: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[10]);
			$fdisplay(file_output, "regfile11: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[11]);
			$fdisplay(file_output, "regfile12: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[12]);
			$fdisplay(file_output, "regfile13: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[13]);
			$fdisplay(file_output, "regfile14: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[14]);
			$fdisplay(file_output, "regfile15: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[15]);
			$fdisplay(file_output, "regfile16: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[16]);
			$fdisplay(file_output, "regfile17: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[17]);
			$fdisplay(file_output, "regfile18: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[18]);
			$fdisplay(file_output, "regfile19: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[19]);
			$fdisplay(file_output, "regfile20: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[20]);
			$fdisplay(file_output, "regfile21: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[21]);
			$fdisplay(file_output, "regfile22: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[22]);
			$fdisplay(file_output, "regfile23: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[23]);
			$fdisplay(file_output, "regfile24: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[24]);
			$fdisplay(file_output, "regfile25: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[25]);
			$fdisplay(file_output, "regfile26: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[26]);
			$fdisplay(file_output, "regfile27: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[27]);
			$fdisplay(file_output, "regfile28: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[28]);
			$fdisplay(file_output, "regfile29: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[29]);
			$fdisplay(file_output, "regfile30: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[30]);
			$fdisplay(file_output, "regfile31: %h", instr_tb.uut.sccpu.cpu_ref.array_reg[31]);
			pc_pre = pc;
			inst_pre = inst;
		end
		
	end
	end
endmodule
