/*
E/16/070
DE SILVA N.S.C.K.S.
LAB06 PART3
*/
`timescale 1ns/100ps
module icache ( INSTRUCTION, BUSYWAIT, READ, ADDRESS, PC, MEMREADDATA, MEMBUSY, CLK, RESET );

	// port declaration

	/*
	signals between cpu and instruction cache
	-----------------------------------------
	inputs --> PC [31:0] 
	outputs --> INSTRUCTION [31:0], IBUSYWAIT

	signals between instructtion cache and instruction memory 
	---------------------------------------------------------
	inputs --> IMEMREADDATA[127:0], IMEMBUSY
	outputs --> READ, ADDRESS [5:0] 

	*/
	


	input [31:0] PC ;
	input [127:0] MEMREADDATA ;
	input MEMBUSY, CLK, RESET;
	output reg [31:0] INSTRUCTION;
	output reg [5:0] ADDRESS ;
	output reg READ, BUSYWAIT ;

	// create instruction cache
	
	/*
	VALID --> 8bit register array 
	TAG   --> eight, 3bit registers
	DATA  --> eight, 128bit registers (16 bytes )
	*/


	reg [7:0] VALID ;
	reg [2:0] TAG [0:7] ;
	reg [127:0] DATA [0:7] ;

	// reset the cache and IBUSYWAIT signal at the positive edge of reset
	integer i ;
	always @ ( RESET ) begin 
		for (i = 0; i< 8; i++ ) begin
			VALID [i] = 1'b0 ; 
			TAG [i] = 3'd0 ;
		end
		BUSYWAIT = 1'b0 ;
	end

	// assert the IBUSYWAIT signal when a new PC value got
	always @ ( PC ) begin
		BUSYWAIT = 1'b1 ;
	end 

	// split the address in to tag, index, offset
	wire [2:0] tag, index ;
	wire [3:0] offset ;
	
	assign { tag, index, offset } = PC [9:0] ;

	// extract stored data block, valid bit and tag 
	wire [127:0] cache_data ;
	wire [2:0] cache_tag ;
	wire valid_bit ;

	assign #1 cache_tag = TAG [index] ;
	assign #1 valid_bit = VALID[index] ;
	assign #1 cache_data = DATA [index] ;

	// performe tag comparison
	 wire is_tag_correct;
	assign #1 is_tag_correct = (tag == cache_tag) ? 1 : 0 ;

	// find hit status 
	wire hit ;
	assign hit =  (valid_bit && is_tag_correct ) ? 1:0 ;
	
	// de-assert the BUSYWAIT signa if hit = 1 
	always @ (posedge CLK ) begin 
		if (hit) BUSYWAIT = 1'b0 ;
	end
	
	// read- hit
	always @ (*) begin
		
		case (offset)
			4'b0000 : begin #1
			INSTRUCTION = cache_data [31:0] ;
			end
			4'b0100 : begin #1
			INSTRUCTION = cache_data [63:32] ;
			end
			4'b1000 : begin #1
			INSTRUCTION = cache_data [95:64] ;
			end
			4'b1100 : begin #1
			INSTRUCTION = cache_data [127:96] ;
			end
		endcase
		
	end

	// cache controller 
	parameter IDLE = 2'b00, MEM_READ = 2'b01, CACHE_UPDATE = 2'b10;
	reg [1:0] state, next_state;

	// combinational next state logic
	always @(*)
	begin
	case (state)
	    IDLE:
		if (!hit && PC < 32'd1024)  
		    next_state = MEM_READ;
		else
		    next_state = IDLE;
	    
	    MEM_READ:
		if (!MEMBUSY)
		    next_state = CACHE_UPDATE;
		else    
		    next_state = MEM_READ;


	    CACHE_UPDATE:  
		   next_state = IDLE;
	    
	endcase
	end

	// combinational output logic
	always @(*)
	begin
	case(state)
	    IDLE:
	    begin
		READ = 0;
		BUSYWAIT = 0;
	    end
	 
	    MEM_READ: 
	    begin
		READ = 1;
		ADDRESS = {tag, index};
		BUSYWAIT = 1;
	    end

	    CACHE_UPDATE: 
	    begin
		READ = 0;
		#1 DATA [index] = MEMREADDATA ; // update the data block in cache 
		VALID [index] = 1'b1 ; // set valid bit to 1
		TAG [index] = tag ; // update the tag array
		BUSYWAIT = 1;
	    end  
	    
	endcase
	end

	// sequential logic for state transitioning 
	always @(posedge CLK, RESET)
	begin
	if(RESET)
	    state = IDLE;
	else
	    state = next_state;
	end
	
endmodule






	
	
