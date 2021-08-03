/*
E/16/070
DE SILVA N.S.C.K.S.
LAB06 PART2 - data cache
*/

`timescale 1ns/100ps

module dcache (BUSYWAIT, MEMREAD, MEMWRITE, MEMWRITEDATA, READDATA, MEMADDRESS, READ, WRITE,WRITEDATA,MEMREADDATA, MEMBUSY, ADDRESS, CLK, RESET);


	/* 
	signals between cpu and cache
	-----------------------------
	inputs  --> READ, WRITE, WRITEDATA [7:0], ADDRESS [7:0]
	outputs --> BUSYWAIT, READDATA [7:0]

	signals between cache and main memory 
	-------------------------------------
	inputs  --> MEMBUSY, MEMREADDATA [31:0]
	outputS --> MEMREAD, MEMWRITE, MEMWRITEDATA [31:0], MEMADDRESS [5:0]
	*/

	// port declaration

	input READ, WRITE, MEMBUSY, CLK, RESET;
	input [7:0] WRITEDATA, ADDRESS ;
	input [31:0] MEMREADDATA ;
	output reg MEMREAD, MEMWRITE, BUSYWAIT;
	output reg [7:0] READDATA ;
	output reg [31:0] MEMWRITEDATA ;
	output reg [5:0] MEMADDRESS ;

	// implement cache
	reg [0:7] VALID ; // store valid bit
	reg [0:7] DIRTY ; // store dirty bit
	reg [2:0] TAG [0:7] ; // store tag
	reg [31:0] DATA [0:7] ; // store data block

	integer i ;
	// reset cache and BUSYWAIT
	always @ (RESET)
	begin
		VALID = 8'd0 ;
		DIRTY = 8'd0 ;
	
		for (i = 0; i < 8; i++ ) begin
			TAG [i]  = 3'd0 ;
			DATA [i] = 32'd0 ;
		end
		
		BUSYWAIT = 1'b0 ;
	end

	// assert BUSYWAIT signal if READ or WRITE signal high
	always @ ( READ || WRITE ) 
	begin
		BUSYWAIT = (READ || WRITE)? 1 : 0;
	end
	
	// split the address
	wire [2:0] tag, index ;
	wire [1:0] offset ;	

	assign { tag, index, offset } = ADDRESS ;

	// find correct cache entry and extract stored data block, tag, valid bit and dirty bit
	wire valid_bit, dirty_bit ;
	wire [2:0] cache_tag ;
	wire [31:0] cache_data ;

	
	assign #1 valid_bit  = VALID [index] ;
	assign #1 dirty_bit  = DIRTY [index] ;
	assign #1 cache_tag  = TAG [index] ;
	assign #1 cache_data = DATA [index] ; 

	//tag comparison
	wire is_tag_correct ;
	assign  #0.9 is_tag_correct = (tag == cache_tag)? 1 : 0 ;


	// hit detection
	wire hit ;
	assign hit = (is_tag_correct && valid_bit )? 1 : 0 ;

	// if hit = 1 de-assert the BUSYWAIT  at a positive clock edge
	always @ (posedge CLK )
	begin
		if (hit) BUSYWAIT = 1'b0 ;
	end

	
	// read-hit
	reg [7:0] data_word ;
	
	always @ (*)
	begin
		// read data word
		case (offset)
			2'b00 : begin #1
			READDATA = cache_data [7:0] ;
			end
			2'b01 : begin #1
			READDATA = cache_data [15:8] ;
			end
			2'b10 : begin #1
			READDATA = cache_data [23:16] ;
			end
			2'b11 : begin #1
			READDATA = cache_data [31:24] ;
			end
		endcase
		
	end

		

	// write-hit
	always @ (posedge CLK)
	begin
		if (hit && WRITE) begin
			case (offset)
				2'b00 : begin #1
				DATA [index] [7:0] = WRITEDATA ;
				DIRTY [index] = 1'b1 ;
				end
				2'b01 : begin #1
				DATA [index][15:8] = WRITEDATA ;
				DIRTY [index] = 1'b1 ;
				end
				2'b10 : begin #1
				DATA [index][23:16] = WRITEDATA ;
				DIRTY [index] = 1'b1 ;
				end
				2'b11 : begin #1
				DATA [index][31:24] = WRITEDATA ;
				DIRTY [index] = 1'b1 ;
				end
			endcase
		end
	end
			 

    /* Cache Controller FSM Start */

    parameter IDLE = 2'b00, MEM_READ = 2'b01, MEM_WRITE = 2'b10, CACHE_UPDATE = 2'b11;
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                if ((READ || WRITE) && !dirty_bit && !hit)  
                    next_state = MEM_READ;
                else if ((READ || WRITE) && dirty_bit && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
            MEM_READ:
                if (!MEMBUSY)
                    next_state = CACHE_UPDATE;
                else    
                    next_state = MEM_READ;

            MEM_WRITE:
                if (!MEMBUSY)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;

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
                MEMREAD = 0;
                MEMWRITE = 0;
                BUSYWAIT = 0;
            end
         
            MEM_READ: 
            begin
                MEMREAD = 1;
                MEMWRITE = 0;
                MEMADDRESS = {tag, index};
                BUSYWAIT = 1;
            end

            MEM_WRITE: 
            begin
                MEMREAD = 0;
                MEMWRITE = 1;
                MEMADDRESS = {cache_tag, index};
                MEMWRITEDATA = DATA[index] ;
                BUSYWAIT = 1;
            end

            CACHE_UPDATE: 
            begin
                MEMREAD = 0;
                MEMWRITE = 0;
		#1 DATA [index] = MEMREADDATA ; // update the data block in cache withe latency of 1 time unit
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

    /* Cache Controller FSM End */

endmodule






















	
