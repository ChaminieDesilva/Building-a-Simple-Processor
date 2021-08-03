/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART2
*/

`timescale 1ns/100ps

// register file module
module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET, BUSYWAIT );

	// port declaration
	input [2:0] OUT1ADDRESS, OUT2ADDRESS, INADDRESS ; // for input and output register addresses
	input WRITE, CLK, RESET, BUSYWAIT ; // for control signals 
	input [7:0] IN ; // for input data
	output [7:0] OUT1, OUT2 ; // for output the data

	// create a register array for implement eight, 8bit registers
	reg [7:0] reg_arr [0:7] ; 

	// read from regitser file is not synchronous with the clock signal
	// read values with delay of 2 time units
	assign #2 OUT1 = reg_arr[OUT1ADDRESS] ; 
	assign #2 OUT2 = reg_arr[OUT2ADDRESS] ;

	// write given data to the given register at rising edge of the clock 
	// delay for write is 1 time units
	always @ (posedge CLK)
	begin
		#1
		if(WRITE==1 & RESET == 0 & BUSYWAIT == 0) begin
			 case (INADDRESS)
				3'b000 : begin
						 reg_arr [0] <= IN;
					 end
				3'b001 : begin
						 reg_arr [1] <= IN;
					 end	
				3'b010 : begin
						 reg_arr [2] <= IN;
					 end
				3'b011 : begin
						 reg_arr [3] <= IN;
					 end
				3'b100 : begin
						 reg_arr [4] <= IN;
					 end
				3'b101 : begin
						 reg_arr [5] <= IN;
					 end
				3'b110 : begin
						 reg_arr [6] <= IN;
					 end
				3'b111 : begin
						 reg_arr [7] <= IN;
					 end 
			endcase
		end
	end

	// the reset of the registers is not synchronous with the clock signal

	always @ (RESET)
	begin
		if(RESET) begin
			#2            // delay for rest is two time unit
			
			// make every register value zero
			reg_arr [0] <= 8'd0 ;
			reg_arr[1] <= 8'd0 ;
			reg_arr[2] <= 8'd0 ;
			reg_arr[3] <= 8'd0 ;
			reg_arr[4] <= 8'd0 ;
			reg_arr[5] <= 8'd0 ;
			reg_arr[6] <= 8'd0 ;
			reg_arr[7] <= 8'd0 ;
		end
	end

endmodule






