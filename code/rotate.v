/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART5 - program counter
*/

`timescale 1ns/100ps

// module rotate right
// rotate right by a given amount
module rotate_right (OUTDATA, INDATA, AMOUNT);
	input [7:0] INDATA ;
	input [3:0] AMOUNT ;
	output  [7:0] OUTDATA ;

	wire [7:0] state1, state2, state3 ;

	// rotate by 0 or 1 bits
	mux m6 (state1, {INDATA[0],INDATA[7:1]}, INDATA, AMOUNT[0] ) ;

	// rotate by 0 or 2 bits
	mux m7 (state2, {state1[1:0],state1[7:2]}, state1, AMOUNT[1] ) ;

	// rotate by 0 or 4 bits
	mux m8 (state3, {state2[3:0],state2[7:4]}, state2, AMOUNT[2] );
	
	// rotate by 0 or 8 bits
	mux m9 (OUTDATA, INDATA, state3, AMOUNT[3] ) ;

endmodule
