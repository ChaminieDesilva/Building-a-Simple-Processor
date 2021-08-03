/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - multiplexer
*/

`timescale 1ns/100ps

// module multiplexer
module mux (OUT, IN1, IN2, SELECT);
	// port declaration
	input SELECT;
	input [7:0] IN1, IN2 ;
	output reg [7:0] OUT ;

	// multiplexer sensitive for any input signal
	always @ (*)
	begin

		// if select signal is high out put the input signal1 otherwise output input signal2
		if(SELECT) begin
			OUT = IN1 ;
		end else begin
			OUT = IN2 ;
		end

	end

endmodule

// 32 bit  ultiplexer
module mux32bit (OUT, IN1, IN2, SELECT);
	// port declaration
	input SELECT;
	input [31:0] IN1, IN2 ;
	output reg [31:0] OUT ;

	// multiplexer sensitive for any input signal
	always @ (*)
	begin

	// if select signal is high output the input signal1 otherwise output input signal2
	if(SELECT) begin
		OUT = IN1 ;
	end else begin
		OUT = IN2 ;
	end

	end

endmodule


// single bit input 2_x_1 multiplexer 
module mux1bit (OUT, IN1, IN2, SELECT);
	// port declaration
	input SELECT;
	input IN1, IN2 ;
	output reg  OUT ;

	// multiplexer sensitive for any input signal
	always @ (*)
	begin

		// if select signal is high output the input signal1 otherwise output the input signal2
		if(SELECT) begin
			OUT = IN1 ;
		end else begin
			OUT = IN2 ;
		end

	end

endmodule


