/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART5 - program counter
*/

`timescale 1ns/100ps

// module reverse
// output the reversed input data
module reverse (OUTDATA, INDATA);
	input [7:0] INDATA ;
	output reg [7:0] OUTDATA ;

	always @ (INDATA)
	begin
		OUTDATA[7] = INDATA[0] ;
		OUTDATA[6] = INDATA[1] ;
		OUTDATA[5] = INDATA[2] ;
		OUTDATA[4] = INDATA[3] ;
		OUTDATA[3] = INDATA[4] ;
		OUTDATA[2] = INDATA[5] ;
		OUTDATA[1] = INDATA[6] ;
		OUTDATA[0] = INDATA[7] ;
	end

endmodule
