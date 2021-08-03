/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART5 - program counter
*/

`timescale 1ns/100ps

// module shift
module shift (OUTDATA, INDATA, AMOUNT,S);
	input [7:0] INDATA ;
	input [3:0] AMOUNT ;
	input S ;
	output  [7:0] OUTDATA ;

	wire [7:0] state1, state2, state3 ;
	
	// shift by 0 or 1 bits
	mux m1 (state1, {S,INDATA[7:1]}, INDATA, AMOUNT[0] ) ;

	// shift by 0 or 2 bits
	mux m2 (state2, {{2{S}},state1[7:2]}, state1, AMOUNT[1] ) ;

	// shift by 0 or 4 bits
	mux m3 (state3, {{4{S}},state2[7:4]}, state2, AMOUNT[2] );
	
	// shift by 0 or 8 bits
	mux m4 (OUTDATA, {8{S}}, state3, AMOUNT[3] ) ;

endmodule


