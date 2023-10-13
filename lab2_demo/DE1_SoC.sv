`timescale 1 ps / 1 ps
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic [9:0] SW;
	input  logic		 CLOCK_50;	// 50MHz clock
	input logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	// expansion header 0 (LabsLand board)
	
    // Turn off all 7-seg displays (active low: 1 = off, 0 = on)
	
	
	logic [4:0] address;
	logic [2:0] data;
	logic [2:0] q;
	logic [2:0] q2;
	
	//logic for converting address bit to two 4 bit values WRITE (address -> hex)
	
	
	
	logic switch, wren1, wren2;
	
	//switching between RAMS
	assign switch = SW[9];
	//write Enable
	assign writeEnable = SW[0];
	

	assign address = {SW[8], SW[7], SW[6], SW[5], SW[4]};
	//assign wraddress = {SW[8], SW[7], SW[6], SW[5], SW[4]};
	assign data = {SW[3], SW[2], SW[1]};
	assign reset = ~KEY[3];
	
	//Switch capability, when switch is 1, two port is active
	// when switch is 0, one port is active
	
	
	
	//instantiate 2 port module (the one we just created) and wire it to switch.
	
	
	task2 topTask2 (.address, .clock(CLOCK_50), .data, .wren(wren1), .q(q));
	
	// raddress hooked up with counter
	
	logic [4:0] count;	
	
	counter readAddress (.out(count), .clk(CLOCK_50), .reset);
	
	ram32x3port2 twoPort (.clock(CLOCK_50), .data, .rdaddress(count), .wraddress(address), .wren(wren2), .q(q2));
	
	//Switch logic, covers all 4 cases, output to Hexs is based on switch
	//whether we read or write from that specific ram is based on writeEnable (SW[0])
	logic [2:0] out;
	always_ff @(posedge CLOCK_50) begin
		if(reset == 1) begin
			out <= q;
			wren1 <= 0;
			wren2 <= 0;
			
		end
		
		if(switch == 1 && writeEnable == 1) begin
			out <= q2;
			wren1 <= 0;
			wren2 <= 1;
		end
		
		else if(switch == 1 && writeEnable == 0) begin
			out <= q2; 
			wren1 <= 0;
			wren2 <= 0;
		end
		else if (switch == 0 && writeEnable == 1) begin
			out <= q;
			wren1 <= 1;
			wren2 <= 0;
		end
		else if (switch == 0 && writeEnable == 0) begin
			out <= q;
			wren1 <= 0;
			wren2 <= 0;
		end
		
		
	end
	
	//write Address --> hex5, hex4
	//logic [3:0] tens_logic5;
	//logic [3:0] ones_logic4;
	
	//bitConverter converter(.address, .tens_logic(tens_logic5), .ones_logic(ones_logic4));
	
	seg7 hex5(.hex({3'b0,address[4]}), .leds(HEX5));
	seg7 hex4(.hex(address[3:0]), .leds(HEX4));
	
	logic [3:0] tens_logic3;
	logic [3:0] ones_logic2;
	//readAddrses --> hex3, hex2
	
	//bitConverter converter1(.address(count), .tens_logic(tens_logic3), .ones_logic(ones_logic2));
	
	
	seg7 hex3(.hex({3'b0, count[4]}), .leds(HEX3));
	seg7 hex2(.hex(count[3:0]), .leds(HEX2));
	
	//data --> hex1
	seg7 hex1(.hex({1'b0, data}), .leds(HEX1));
	
	
	seg7 hex0(.hex({1'b0, out}), .leds(HEX0));

endmodule  // DE1_SoC


//testbench

module DE1_SoCtb ();
	logic [9:0] SW;
	logic		 CLOCK_50;	// 50MHz clock
	logic [3:0] KEY;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	logic [9:0] LEDR;
	DE1_SoC dut(.*);
	 parameter CLOCK_PERIOD = 100;
	initial begin 
		CLOCK_50 <= 0; 
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50;
	end
	
	initial begin
	
	KEY[3] <= 0; @(posedge CLOCK_50);
	KEY[3] <= 1; @(posedge CLOCK_50);
	//task 2 first
	//writes, incrementing data to incrementing addresses
	for(int i = 0; i < 32; i++) begin

	SW[9] <= 0; SW[8:4] <= i; SW[0] <= 1; SW[3:1] <= i; @(posedge CLOCK_50);
	
	end
																		 @(posedge CLOCK_50);
	//read 
	for(int i = 0; i < 32; i++) begin

	SW[9] <= 0; SW[8:4] <= i; SW[0] <= 0; SW[3:1] <= i; @(posedge CLOCK_50);
	
	end
																	 @(posedge CLOCK_50);
	//write task 3 
	for(int i = 0; i < 32; i++) begin

	SW[9] <= 1; SW[8:4] <= i; SW[0] <= 1; SW[3:1] <= i; @(posedge CLOCK_50);
	
	end
																		@(posedge CLOCK_50);
	//read task 3 
	for(int i = 0; i < 32; i++) begin

	SW[9] <= 1; SW[8:4] <= i; SW[0] <= 0; SW[3:1] <= i; @(posedge CLOCK_50);
	$stop;
	end
	end 
	endmodule
	
		