/*
E/16/070
DE SILVA N.S.C.K.S.
LAB05 PART3 - decode and control unit
*/

`timescale 1ns/100ps

// module for generate control signals, sources and destination 
module decode(INPUTINSTRUCTION, RESET, SOURCE1, SOURCE2, DESTINATION, IMMEDIATEVALUE,JUMPVALUE, ALUOP, ISSUB, ISIMMEDIATE, WRITEENABLE, ISJUMP, ISBRANCH, ISBNE, ISSHIFTLEFT, ISMEM, MEMREAD,MEMWRITE, PCRESET, REGRESET);
	// port declaration for inputs
	input [31:0] INPUTINSTRUCTION ;
	input RESET ;
	// port declaration for outputs
	output reg[2:0] SOURCE1, SOURCE2, DESTINATION ;
	output reg [7:0] IMMEDIATEVALUE, JUMPVALUE ;
	// ISSUB - control signal for mux1 
	// ISIMMEDIATE - control signal for mux2
	// WRITEENAABLE - write back process occurs if this signal is high. this signal is send to the register file
	// PCRESET - reset signal for program counter
	// REGRESET -  reset signal for register file
	// ISJUMP - control signal for mux which dicides jump instruction or not 
	// ISBRANCH - if the executing instruction is a beq instruction this signal is high
	// ISBNE - if the current instruction is a bne instruction then his signal is high
	// ISSHIFTLEFT - if the current instruction is a sll instruction then this signal is high
	// WRITE - data memory write ennable signal
	// READ - data memory read ennable signal
	// ISMEM - if the current executing instruction is a memory read or write instruction then this signal is high
	// MEMREAD - if current instruction is lwd or lwi then data memory must read.to indicate that this control signal is used
	// MEMWRITE - if current instruction is swd or swi then given data must write to the given address.to indicate that this control signal is used
	output reg ISSUB, ISIMMEDIATE, WRITEENABLE, PCRESET, REGRESET, ISJUMP, ISBRANCH, ISBNE, ISSHIFTLEFT, MEMREAD, MEMWRITE, ISMEM;
	output reg [2:0] ALUOP ;

	// create tegisters for store relavent parts of instruction
	reg [7:0] OPCODE ,S1, S2, DES ;


	// create a parameter list 
	parameter [7:0] LOADI = 8'd0, 
		  	MOVE  = 8'd1, 
		 	ADD   = 8'd2, 
		  	SUB   = 8'd3, 
		  	AND   = 8'd4,
		  	OR    = 8'd5,
		        JUMP  = 8'd6 ,
			BEQ   = 8'd7 ,  // opcode of branch equal instruction
		//	MUL   = 8'd10 , // opcode of multiply instruction
			BNE   = 8'd11 , // opcode of branch not equal instruction
			SRL   = 8'd12 , // opcode for logical shift right
			SLL   = 8'd13 , // opcode for logical shift left
			SRA   = 8'd14 , // opcode for arithmetic shift right
			ROR   = 8'd15 , // opcode for arithmetic shift right
			LWD   = 8'd16 , // opcode for load word instruction (register direct addressing)
			LWI   = 8'd17 , // opcode for load word instruction (immediate addressing)
			SWD   = 8'd18 , // opcode for store word insruction (register direct addressing)
			SWI   = 8'd19 ; // opcode for store word instruction (immediate addressing)


	// when instruction is changed separate the instruction into four pices and asign them to relavent outputs
	always @ (INPUTINSTRUCTION)
	begin
		{OPCODE, DES, S1, S2} = INPUTINSTRUCTION ; 

		DESTINATION = DES ;
		SOURCE1 = S1 ;
		SOURCE2 = S2 ;
		IMMEDIATEVALUE = S2 ;
		JUMPVALUE = DES ;


	// when opcode is changed generate all control signals with a delay of one time unit

		MEMREAD  = 1'b0 ;
		MEMWRITE = 1'b0 ;
		case (OPCODE)

			LOADI : begin #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end

			MOVE : begin #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end

			ADD : begin #1
					ALUOP = 3'd1 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end

			SUB : begin #1
					ALUOP = 3'd1 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b1 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end

			AND : begin #1
					ALUOP = 3'd2 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end

			OR : begin  #1
					ALUOP = 3'd3 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end	

			// for jump instructions do not need an aluop 
			JUMP : begin  #1
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b0 ;
					ISJUMP = 1'b1 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			BEQ : begin  #1
					ALUOP = 3'd1 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b1 ;
					WRITEENABLE = 1'b0 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b1 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
					   end

		   /*	MUL : begin #1
					ALUOP = 3'd7 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBRANCH = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end                        */

			BNE : begin  #1
					ALUOP = 3'd1 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b1 ;
					WRITEENABLE = 1'b0 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b1 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			SRL : begin  #1
					ALUOP = 3'd5 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			SLL : begin  #1
					ALUOP = 3'd5 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b1 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			SRA : begin  #1
					ALUOP = 3'd6 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			ROR : begin  #1
					ALUOP = 3'd7 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b0 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b0 ;
				   end
			LWD : begin  #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b1 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b1 ;
				   end
			LWI : begin  #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b1 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b1 ;
					MEMWRITE = 1'b0 ;
					MEMREAD = 1'b1 ;
				   end
			SWD : begin  #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b0 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b0 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b1 ;
					MEMWRITE = 1'b1 ;
					MEMREAD = 1'b0 ;
				   end
			SWI : begin  #1
					ALUOP = 3'd0 ;
					ISIMMEDIATE = 1'b1 ;
					ISSUB = 1'b0 ;
					WRITEENABLE = 1'b0 ;
					ISJUMP = 1'b0 ;
					ISBNE = 1'b0 ;
					ISSHIFTLEFT = 1'b0 ;
					ISMEM = 1'b1 ;
					MEMWRITE = 1'b1 ;
					MEMREAD = 1'b0 ;
				   end
		endcase
	end

	// when reset signal is changed generate reset signals for pc and register file 
	always @ (RESET)
	begin
		if (RESET) begin
			PCRESET = 1 ;
			REGRESET = 1 ;
		end else begin	
			PCRESET = 0 ;
			REGRESET = 0 ;
		end
	end


endmodule


