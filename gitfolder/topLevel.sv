module topLevel (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic [9:0] SW;
	input  logic		 CLOCK_50;	// 50MHz clock
	input logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	
	
	//assigning inputs from the board 
	logic start, reset;
	logic [7:0] A; 
	//active low
	assign start = ~KEY[3]; 
	assign A = {SW[7], SW[6], SW[5], SW[4], SW[3], SW[2], SW[1], SW[0]};
	//active low
	assign reset = ~KEY[0];
	
//	logic [6:0] conflictingHex1, conflictingHex2;
//	logic conflictingLEDR9, conflictingLEDR92;
//	logic conflictingLEDR02;
	logic [4:0] Loc;
	logic found;
	logic task2_done;
	logic [4:0] addr;
	task2(.found, .done(task2_done), .addr, .target(A), .clk(CLOCK_50), .reset, .startSig(start));
	logic [3:0] ones_num, tens_num, b0, b1, out2_ones, out2_tens;
	
	assign b0 = addr % 5'd16;
   assign b1 = addr / 5'd16;
	always_comb begin 
		if(found) begin
			out2_ones = b0;
			out2_tens = b1;
		end
		else begin
			out2_ones = 4'b0000;
			out2_tens = 4'b0000;
		end
   end
	seg7 tens (.hex(tens_num), .leds(HEX1));
	
	seg7 ones (.hex(ones_num), .leds(HEX0));
	
	//wires to connect the cntrl to the datapath
	logic result, rShift, done, increment, loadReady;  
	logic [7:0] Awire; 
	//outputs from datapath to be displayed on the board
	logic [3:0] sumToBoard; 
	logic finished; //done state
		
	
	BCA_cntrl cntrl (.clk(CLOCK_50), .start, .reset, .Awire, .result, .rShift, .done, .increment, .loadReady);
	
	BCA_datapath dp (.clk(CLOCK_50), .A, .rShift, .result, .done, .increment, .loadReady, .sumToBoard, .finished(finished), .Awire);
					   
//	seg7 display (.hex(sumToBoard), .leds(conflictingHex2));
	
	
	always_ff @(posedge CLOCK_50) begin
		if(SW[9]) begin
			tens_num <= out2_tens;
			ones_num <= out2_ones;
			LEDR[9] <= task2_done;
			LEDR[0] <= found;
		end
		else begin
			tens_num <= 4'b0000;
			ones_num <= sumToBoard;
			LEDR[9] <= finished;
			LEDR[0] <= 0;
		end
			
	end
	
endmodule

module topLeveltb();

	 logic [9:0] SW;
    logic		 CLOCK_50;	// 50MHz clock
	 logic [3:0] KEY;
	 logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	 logic [9:0] LEDR;
	 
	  parameter CLOCK_PERIOD = 100;
	initial begin 
		CLOCK_50 <= 0; 
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	

//propsed functionality: should display 2 for amounts of ones
//as start never leaves one the FSM should stay in S3 as it finishes its computation.

	topLevel dut (.*); 
	
	initial begin
		
		SW[9] <= 0; KEY[0] <= 0; SW[7:0] <= 8'b00000000; KEY[3] <= 1; @(posedge CLOCK_50);	
		KEY[0] <= 1; @(posedge CLOCK_50); 
		SW[7:0] <= 8'b01000101; KEY[3] <= 1; @(posedge CLOCK_50);
	   KEY[3] <= 0; @(posedge CLOCK_50);
		
		//gives the BCA time to compute everything
		for (int i = 0; i < 20; i++) begin
			@(posedge CLOCK_50);
		end
		$stop;
	
	end
	
endmodule
	
