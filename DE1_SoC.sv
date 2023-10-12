module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic [9:0] SW;
	input  logic		 CLOCK_50;	// 50MHz clock
	input logic [3:0] KEY;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;	// active low
	output logic [9:0] LEDR;
	// expansion header 0 (LabsLand board)
	
    // Turn off all 7-seg displays (active low: 1 = off, 0 = on)

	
	logic [4:0] address, wraddress, raddress;
	logic [2:0] data;
	logic [2:0] q;
	logic [2:0] q2;
	
	//logic for converting address bit to two 4 bit values WRITE
	
	logic [3:0] tens, ones;
	logic [4:0] address_int;
	assign address_int = (address[4] << 4) | (address[3] << 3) | (address[2] << 2) | (address[1] << 1) | address[0];
	assign tens = address_int / 10;
	assign ones = address_int % 10;
	logic [3:0] tens_logic;
	logic [3:0] ones_logic;
	
	always @(tens, ones) begin
		tens_logic = {3'b0, tens};
		ones_logic = {3'b0, ones};
	end
	
	//adding switching functionality between task2 (array RAM, 1 port) and task3(RAM 2 PORT)
	
	logic switch, wren1, wren2;
	

	assign switch = SW[9];
	 
	

	assign address = {SW[8], SW[7], SW[6], SW[5], SW[4]};
	assign wraddress = {SW[8], SW[7], SW[6], SW[5], SW[4]};
	assign data = {SW[3], SW[2], SW[1]};
	
	
	//Switch capability, when switch is 1, two port is active
	// when switch is 0, one port is active

	//always comb (if wren & SW[9]) (if wren & ~SW[9])
	
	
	//instantiate 2 port module (the one we just created) and wire it to switch.
	
	
	task2 topTask2 (.address, .clock(CLOCK_50), .data, .wren(wren1), .q(q));
	
	// raddress hooked up with counter
	
	ram32x3port2 twoPort (.clock(~KEY[0]), .data, .raddress(), .wraddress, .wren(wren2), .q(q2));
	
	//if SW[9] = 1; choose q2
	//if SW[9] = 0; choose q
	//hex is q, hex1 is q2, choose is Sw[9]
	seg7 hex5(.hex(tens_logic), .hex1(q2), .choose(switch) .leds(HEX5));
	seg7 hex4(.hex(ones_logic), .leds(HEX4));
	
	seg7 hex1(.hex(data), .leds(HEX1));
	
	seg7 hex0(.hex(q), .leds(HEX0));

endmodule  // DE1_SoC
