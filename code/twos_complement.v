/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - two's complemnt
*/

// twos's complement unit
module twos_complement (OUT, IN);
	// port declaration
	input [7:0] IN ;
	output reg [7:0] OUT ;

	// two's complement unit sensitive for the input signal 
	// letancy is two time units
	always @ (IN)
	begin
	// assign to the output the two's complement value of given input data
	#1 OUT = ~IN + 8'd1 ; // invert the input signal and add one

	end

endmodule


