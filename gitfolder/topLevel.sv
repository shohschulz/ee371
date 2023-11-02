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
	
	logic [6:0] conflictingHex1, conflictingHex2;
	logic conflictingLEDR9, conflictingLEDR92;
	logic conflictingLEDR02;
	logic [4:0] Loc;
	task2(.A, .start, .reset, .Loc, .done(conflictingLEDR92), .found(conflictingLEDR02), .clk(CLOCK_50));

	seg7 msb (.hex({3'b0, Loc[4]}), .leds(HEX1));
	
	seg7 lsb (.hex(Loc[3:0]), .leds(conflictingHex));
	
	//wires to connect the cntrl to the datapath
	logic result, rShift, done, increment, loadReady;  
	logic [7:0] Awire; 
	//outputs from datapath to be displayed on the board
	logic [3:0] sumToBoard; 
	logic finished; //done state
		
	
	BCA_cntrl cntrl (.clk(CLOCK_50), .start, .reset, .Awire, .result, .rShift, .done, .increment, .loadReady);
	
	BCA_datapath dp (.clk(CLOCK_50), .A, .rShift, .result, .done, .increment, .loadReady, .sumToBoard, .finished(conflictingLEDR9), .Awire);
					   
	seg7 display (.hex(sumToBoard), .leds(conflictingHex2));
	
	
	always_ff @(posedge CLOCK_50) begin
		if(SW[9]) begin
				HEX0 <= conflictingHex2;
				LEDR[9] <= conflictingLEDR92;
				LEDR[0] <= conflictingLEDR02;
		end
		else begin
				HEX0 <= conflictingHex1;
				LEDR[9] <= conflictingLEDR9;
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
		KEY[0] <= 0; SW[7:0] <= 8'b00000000; KEY[3] <= 1; @(posedge CLOCK_50);	
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
	
