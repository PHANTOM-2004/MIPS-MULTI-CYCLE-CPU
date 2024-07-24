# Multi-cycle CPU On FPGA For MIPS ISA(support 54 instructions)

It is trivial that it is a toy CPU.

## Tongji University MIPS CPU

说明: 本项目是同济大学组成原理课程设计的最后一次大作业.

全新版本: 又多一个可以`copy`的项目不必担心查重了(lol).

## Background

这个项目算是从0开始做的, 起初31条指令的CPU是做的单周期, 然而实际上单周期难度还是比较低的.
于是打算在最后一次作业中挑战一下多周期, 然而实际上多周期并不算容易. 从时序控制器到选择控制器,
再到最后综合测试, 还是花了4-5天的时间去做的.

这其中的坑很多. 同时也看到了这个课程设计中的而很多不足:

- 梯度陡峭, 没有阶段性得分. 这造成的结果是显然的(...).
- 测试简陋, 有一个广为流传的单周期CPU版本, 里面的`DMEM` 是错误的, 尽管如此, 他的错误没有被测出来,
并且在被`copy`多次后, 还是没有被测出来.
- `copy+paste` , 这个懂得都懂, 不懂的说了也不懂. 大概Prof. Zhang还是比较善良的.
- 抽象vivado2023, vivado2023初始化`ip core`还是有不少`bug`.

## IDE

This project is finished on `vivado 2023.2`.

## Structure

结构如下:

- `tb`结尾的均为测试, 其中部分测试可能由于后续模块文件的修改而编译错误. 使用的时候关注一下`error`.
- 两个`.xlsx`是对应的接口设计和时序设计.
- `imem` 是`ip core`自己使用`distributed memory`.
- `.sh`是生产`.coe`的`shell`脚本.

```
.
├── cycles.xlsx
├── instr_sim
│   └── new
│       └── instr_tb.v
├── IO_port.xlsx
├── README.md
├── sim_1
│   └── new
│       ├── controller_tb_1.v
│       ├── controller_tb_2.v
│       ├── controller_tb_3.v
│       ├── controller_tb_4.v
│       ├── controller_tb_5.v
│       ├── controller_tb_6.v
│       ├── controller_tb_7.v
│       ├── controller_tb_8.v
│       ├── DMEM_tb.v
│       ├── instr_decoder_tb.v
│       ├── regfile_tb.v
│       └── testbench_cpu54_multiple.v
├── sources_1
│   ├── ip
│   │   └── imem
│   │       └── imem.xci
│   └── new
│       ├── ALU_FLAG.v
│       ├── ALU.v
│       ├── CLZ.v
│       ├── controller.v
│       ├── CP0.v
│       ├── cpu.v
│       ├── DIV.v
│       ├── DMEM.v
│       ├── DRr.v
│       ├── DRw.v
│       ├── EXT16.v
│       ├── EXT18.v
│       ├── EXT5.v
│       ├── HI.v
│       ├── instr_decoder.v
│       ├── IR.v
│       ├── LO.v
│       ├── MASK_PC_IR.v
│       ├── MULT.v
│       ├── mux_gr_w_addr.v
│       ├── mux_gr_w_data.v
│       ├── mux_hi_wdata.v
│       ├── mux_lo_wdata.v
│       ├── muxt_alu_a.v
│       ├── muxt_alu_b.v
│       ├── muxt_cp0_r_addr.v
│       ├── muxt_cp0_w_addr.v
│       ├── muxt_cp0_wdata.v
│       ├── muxt_pc_w_data.v
│       ├── PC.v
│       ├── regfile.v
│       ├── sccomp_dataflow.v
│       ├── T_STATUS.v
│       └── Z.v
└── utils_1
    └── imports
        └── synth_1
            └── controller.dcp


```

```
```
