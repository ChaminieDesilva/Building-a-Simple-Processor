# Building-a-Simple-Processor
A simple 8-bit single-cycle processor which includes an  ALU, a register file and control logic, using Verilog HDL.

1. Compile: 
  iverilog -o cpu_tb.vvp cpu_tb.v

2. Run: 
  vvp cpu_tb.vvp

3. Open with gtkwave tool: 
  gtkwave cpu_wavedata.vcd
