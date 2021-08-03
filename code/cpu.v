/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - cpu
*/


// include all other modules 
`include "decode_&_control.v"
`include "pc.v"
`include "register_file.v"
`include "alu.v"
`include "twos_complement.v"
`include "mux.v"
`include "adder.v"
`include "reverse.v"
`timescale 1ns/100ps

 
module cpu(INSTRUCTION, CLK, RESET,BUSYWAIT, DATAIN, PC, READ, WRITE, ALURESULT, DATAOUT );
	// port declaration for inputs and outputs
	input [31:0] INSTRUCTION ;
	// if memory read or write operation take place in data memory then cpu should stall. for tha BUSYWAIT signal is used
	input CLK, RESET, BUSYWAIT ;
	input [7:0] DATAIN ;
	output [31:0] PC ;
	output READ, WRITE ;
	output [7:0] ALURESULT, DATAOUT ;
 	// port declaration for all wire signals
	wire [31:0] PCOUT,PCIN,UPDATEDPC,EXTENDEDVALUE,JUMPPC ;
	wire [2:0] SOURCE1, SOURCE2 ,DESTINATION, ALUOP, MUX6OUT ;
	wire [7:0] OUT1, MUX2OUT, MUX7OUT ;
	wire [7:0] RESULT, IMMEDIATEVALUE, TWOSCOMPLEMENT, MUX1OUT, OUT2, OPCODE,JUMPVALUE, MUX5OUT,REVERSEDOUT1,MUX4OUT,REVERSEDRESULT;
	wire ISIMMEDIATE, ISSUB, WRITEENABLE, PCRESET, REGRESET, ZERO, ISBEQ, MUX3SELECT, BNE, ISBRANCH,ISBNE, ISSHIFTLEFT, MEMREAD, MEMWRITE ;

	// assign the address of the instruction which should be fetched from memory to the cpu output pc value
	assign PC = PCOUT ;

	// integrate created modules 

	// instantiate program_counter module 
	program_counter PROGRAMCOUNTER (PCOUT, PCIN, PCRESET, CLK, BUSYWAIT);

	// instantiate adder module for pc adder 
	// second data value is fixed (4)
	pcadder PCADDER (UPDATEDPC, PCOUT, 32'd4) ;

	// sign extend and shift the jump value befor add to the pc+4 value
	assign EXTENDEDVALUE = {{22{JUMPVALUE[7]}}, JUMPVALUE, 2'b00 } ;

	// instantiate adder module for calculate next pc value for branch and jump instructions
	adder JUMPADD(JUMPPC,UPDATEDPC,EXTENDEDVALUE) ;

	// ISBEQ is the control signal which decides the beq instruction was success or not 
	assign ISBEQ = ZERO & ISBRANCH ;

	// BNE is the control signal which decides the bne instruction was success or not
	assign BNE = ~ZERO & ISBNE ;
	
	// mux3 works either ISBEQ or ISJUMP or BNE signal is high therefor, create combinational circuit to generate select signal for mux3
	assign MUX3SELECT =  ISBEQ | ISJUMP | BNE;

	// instantiate 32bit multiplexer to select the next pc value
	mux32bit MUX3(PCIN,JUMPPC,UPDATEDPC,MUX3SELECT) ;

	//  instantiate dcode_&_control module 
	decode DECODER(INSTRUCTION,RESET, SOURCE1, SOURCE2, DESTINATION, IMMEDIATEVALUE, JUMPVALUE, ALUOP, ISSUB, ISIMMEDIATE, WRITEENABLE, ISJUMP, ISBRANCH, ISBNE, ISSHIFTLEFT,ISMEM, MEMREAD, MEMWRITE,   PCRESET, REGRESET);

	// assign MEMREAD and MEMWRITE control signals to the appropriate cpu output ports
	assign READ = MEMREAD ;
	assign WRITE = MEMWRITE ;

	// select correct data which should be written to the registerfile
	mux MUX6 (MUX7OUT, DATAIN, MUX5OUT, ISMEM) ;	

	// instantiate reg_file module
	reg_file REGISTERFILE(MUX7OUT, OUT1, OUT2, DESTINATION, SOURCE1, SOURCE2, WRITEENABLE, CLK, REGRESET, BUSYWAIT) ;

	// assign out1 data for DATAOUT port. this data will be used as writedata by the data memory module
	assign DATAOUT = OUT1 ;

	// instantiate twos_complement module
	twos_complement TWOSCOMPLEMENTUNIT(TWOSCOMPLEMENT,OUT2);
	
	// instantiate mux module for mux1
	mux MUX1(MUX1OUT,TWOSCOMPLEMENT,OUT2,ISSUB) ;

	// instantiate mux module for mux2
	mux MUX2(MUX2OUT,IMMEDIATEVALUE,MUX1OUT,ISIMMEDIATE) ;
	
	// instentiate reverse module for reverse the OUT1 
	reverse REVERSE1 (REVERSEDOUT1,OUT1) ;
	
	// instentiate mux module for MUX4. if current instruction is sll output the reversed out1 
	mux MUX4(MUX4OUT, REVERSEDOUT1, OUT1, ISSHIFTLEFT) ;

	// instantiate alu module
	alu ALU(MUX4OUT, MUX2OUT, RESULT, ALUOP, ZERO) ;

	// instentiate reverse module for reverse the result
	reverse REVERSE2 (REVERSEDRESULT,RESULT) ;
	
	// instentiate mux module for MUX5. if current instruction is sll reverse the result befor write to the register file
	mux MUX5(MUX5OUT, REVERSEDRESULT, RESULT, ISSHIFTLEFT) ;

	// assign result of alu to the ALURESULT output port. this will be an address of data memory for data memory accessing instructions 
	assign ALURESULT = RESULT ;
endmodule

