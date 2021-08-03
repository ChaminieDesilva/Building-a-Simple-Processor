/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART1
*/

// include separetly created modules
`include "shift.v"
`include "rotate.v"
`timescale 1ns/100ps

// alu module
module alu (DATA1, DATA2, RESULT, SELECT, ZERO);

	// port declaration
	input wire [7:0] DATA1, DATA2; // for input data
	input [2:0] SELECT; // for opcode
	output reg  [7:0] RESULT; // for output result
	output  ZERO ; // if result is zero then ZERO signal is high

	// if the result is zero ZERO signal is 1 otherwise 0 
	//  to achive above behaviuor reduction nor operator was used
	assign ZERO = ~| RESULT ;

	// wire diclaration for logical shift operations ,arithmetic shift operation and rotate right operation
	wire [7:0] SHIFTEDVALUE ;
	wire [7:0] ROTATEDVALUE ;
	wire [3:0] AMOUNT ;
	wire FILL ;

	// since we have only 8bit registers maximum number of shifts can be done is 8 so we need only 4bits to represent shift amount
	assign AMOUNT = DATA2 [3:0] ;

	// in logical shif operations fill the rest of bits with zero while in arithmetic shift right fill rest of bits with he msb of given data
	// dicide what should be the filling value using a 2X1 multiplexer (alu opcode for logical shift is 101 and 110 is the aluop code of arithmetic shift.since last bit is difference ,the lsb is
        // used as the select signal for the multiplexer)
	mux1bit MUX6 (FILL, 1'b0, DATA1[7], SELECT[0]) ;
	// instantiate shift module
	shift MYSHIFT (SHIFTEDVALUE, DATA1,AMOUNT,FILL) ;	

	// instentiate rotate_right module for rotate right operation
	rotate_right ROTATERIGHT(ROTATEDVALUE, DATA1, AMOUNT) ;

	
	// create intermediate signals and assign results for them with latancies
	wire [7:0] forward_value, add_value, and_value, or_value,shifted_value, rotated_value, reserved ;
	assign #1 forward_value = DATA2 ;
	assign #2 add_value = DATA1 + DATA2 ;
	assign #1 and_value =  DATA1 & DATA2 ;
	assign #1 or_value = DATA1 | DATA2 ;
	assign #1 shifted_value = SHIFTEDVALUE ;
	assign #1 rotated_value = ROTATEDVALUE ;
	assign #1 reserved = 8'd0 ;

	// the alu is sensitive for data1, data2 and select inputs
	always @(*)
	begin
		case(SELECT)

			// FORWARD function
			// when opcode is 000 mov or load data2 to the result
			3'b000 : begin  
					 RESULT = forward_value;
				 end

			// ADD function
			// when opcode is 001 add data1 & data2 to the result
			3'b001 : begin
				 	 RESULT = add_value ;
				 end

			// AND function
			// when opcode is 010 bitwise and on data1 with data2 to produce the result
			3'b010 : begin
				 	 RESULT = and_value;
				 end

			// OR function
			// when opcode is 011 bitwise or on data1 with data2 to produce the result
			3'b011 : begin
				 	 RESULT = or_value ;
				 end


			// LOGICAL SHIFT function
			// logical shift left and logical shift right 
			// when alu opcode is 101 assign the shifted value to the result
			3'b101 : begin
				 	 RESULT = shifted_value ;
				 end

			// ARITHMETIC SHIFT function
			// arithmetic shift right 
			// when alu opcode is 110 assign the shifted value to the result 
			3'b110 : begin
				 	 RESULT = shifted_value ;
				 end

			// ROTATE RIGHT function
			// when alu opcode is 111 assign the rotated value get from the ROTATERIGHT module to the result
			3'b111 : begin
				 	 RESULT = rotated_value ;
				 end

			// Reserved functions
			// handle reserved bit patterns for other instructions
			default : begin
					RESULT = reserved;
					//$display (" Error : Instruction has not been implemented yet.") ;
				 end
		endcase
	end

endmodule
	

	
