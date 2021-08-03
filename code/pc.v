/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - program counter
*/

`timescale 1ns/100ps

// program counter module
module program_counter(PCOUT, PCIN, RESET, CLK, BUSYWAIT);
	// port declaration
	input RESET, CLK, BUSYWAIT ;
	input [31:0] PCIN ;
	output reg [31:0] PCOUT ;

	// create 32bit wire for connect pc value to adder 
	//wire [31:0] pc_reg ;

	// instantiate adder module
	//adder pc_adder (pc_reg, PC) ;

	// if reset signal is high then pc register should be reset
	// pc is reset to negetive 4 because after reseting and adding 4 0th instruction should be read
	always @ (posedge RESET)
	begin
		if(RESET) begin
			#1 PCOUT = 32'b11111111111111111111111111111100;	// latency for reset is one time units	
		end

	end

	// at the positive edge of the clock pc register value should be output and updated
	always @ (posedge CLK)
	begin #1
		if(RESET == 0 & BUSYWAIT == 0) begin
			 PCOUT = PCIN ;	// latency for update is one time unit	
			
		end
	end

endmodule


