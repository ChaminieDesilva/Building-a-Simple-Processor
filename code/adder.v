/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - adder
*/

`timescale 1ns/100ps

// module adder 
// one input port for adder has fixed to value 4 
// out put is the addition of fixed value and input data
module adder(RESULT, DATA1, DATA2);
	input [31:0] DATA1, DATA2 ;	
	output reg [31:0] RESULT ;

	always @ (*)
	begin
	#2 RESULT = DATA1 + DATA2 ;
	end
endmodule




// create another adder module for calculate pc+4 value with a delay of 1 time unit
module pcadder(RESULT, DATA1, DATA2);
	input [31:0] DATA1, DATA2 ;	
	output reg [31:0] RESULT ;

	always @ (*)
	begin
	#1 RESULT = DATA1 + DATA2 ;
	end
endmodule
