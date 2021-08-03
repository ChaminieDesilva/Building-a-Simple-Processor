/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - cpu testbench
*/

`include "cpu.v"
`include "dmem_for_dcache.v" 
`include "dcache.v"
`include "icache.v"
`include "imem_for_icache.v"
`timescale 1ns/100ps
module cpu_tb;
	// port declaration
	reg CLK, RESET;
	wire [31:0] PC,MEMWRITEDATA, MEMREADDATA ;
	wire READ, WRITE, DATA_BUSYWAIT, MEMREAD, MEMWRITE,MEMBUSY, INS_BUSYWAIT, BUSYWAIT ;
	wire [7:0] ADDRESS, READDATA, WRITEDATA ;
	wire [5:0] MEMADDRESS, INS_ADDRESS ;
	wire [31:0] INSTRUCTION;
	wire [127:0] INS_BLOCK ;

	// create 1024 eight bit registers for instruction memory 
	//reg [7:0] instruction_memory [0:1023] ;
 
	// when pc value is changed fetch the relavent instruction 
	// time delay for fetching instructions is two time units
/*	always @ (PC)
	begin
	#2 INSTRUCTION = {instruction_memory[PC+10'd3], instruction_memory[PC+10'd2], instruction_memory[PC+10'd1], instruction_memory[PC+10'd0]} ;
	end

	// manually assign instructions to the created array
	initial
	begin 

	{ instruction_memory [10'd3], instruction_memory [10'd2], instruction_memory [10'd1], instruction_memory [10'd0] }     = 32'b00000000000000100000000000000010 ; // loadi 2 0x02
	{ instruction_memory [10'd7], instruction_memory [10'd6], instruction_memory [10'd5], instruction_memory [10'd4] }     = 32'b00010011000000000000001000000011 ; // swi 2 0x03
	{ instruction_memory [10'd11], instruction_memory [10'd10], instruction_memory [10'd9], instruction_memory [10'd8] }   = 32'b00010010000000000000001000000010 ; // swd 2 2
	{ instruction_memory [10'd15], instruction_memory [10'd14], instruction_memory [10'd13], instruction_memory [10'd12] } = 32'b00000000000000110000000000000110 ; // loadi 3 0x06
	{ instruction_memory [10'd19], instruction_memory [10'd18], instruction_memory [10'd17], instruction_memory [10'd16] } = 32'b00010000000001000000000000000010 ; // lwd 4 2
	{ instruction_memory [10'd23], instruction_memory [10'd22], instruction_memory [10'd21], instruction_memory [10'd20] } = 32'b00010001000001010000000000000011 ; // lwi 5 0x03
	{ instruction_memory [10'd27], instruction_memory [10'd26], instruction_memory [10'd25], instruction_memory [10'd24] } = 32'b00010011000000000000001100100000 ; // swi 3 0x20
	{ instruction_memory [10'd31], instruction_memory [10'd30], instruction_memory [10'd29], instruction_memory [10'd28] } = 32'b00010001000001100000000000100000 ; // lwi 6 0x20 


	end  */


	// instantiate cpu module
	cpu MYCPU(INSTRUCTION, CLK, RESET, BUSYWAIT, READDATA, PC, READ, WRITE, ADDRESS, WRITEDATA);

	// instantiate dcache module
	dcache MYCACHE(DATA_BUSYWAIT, MEMREAD, MEMWRITE, MEMWRITEDATA, READDATA, MEMADDRESS, READ, WRITE,WRITEDATA,MEMREADDATA, MEMBUSY, ADDRESS, CLK, RESET) ;
	
	// instantiate data memory module
	data_memory MYDMEM(CLK, RESET, MEMREAD, MEMWRITE, MEMADDRESS, MEMWRITEDATA, MEMREADDATA, MEMBUSY );

	//instantiate instruction cache
	icache MYICACHE ( INSTRUCTION, INS_BUSYWAIT, INS_READ, INS_ADDRESS, PC, INS_BLOCK, INS_MEMBUSY, CLK, RESET ) ; 

	// instantiate instruction memorey module
	instruction_memory MYINS_MEMORY ( CLK, INS_READ, INS_ADDRESS, INS_BLOCK, INS_MEMBUSY ) ;

	// cpu stall signal
	assign BUSYWAIT = (DATA_BUSYWAIT | INS_BUSYWAIT) ;

	initial
	begin

	// generate files needed to plot the waveform using GTKWave
	$dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);

	// set clock signal and reset signal 
	CLK = 1'b1;
	RESET = 1'b1 ;
	#1
	RESET = 1'b0 ;
	#2000

	$finish;

	end

	// clock signal generation
	always
	#4 CLK = ~CLK;


endmodule
