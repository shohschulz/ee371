module task1(address, clock ,data, wren, q);
	input logic [4:0] address;
	input logic [2:0] data;
	input logic wren, clock; 
	output logic [2:0] q;
	//post ff, write = wren
	logic [4:0] addressFF;
	logic [2:0] dataFF;
	logic wrenFF;
	
	always_ff @(posedge clock) begin
			addressFF <= address;
			dataFF <= data; 
			wrenFF <= wren;
	end
	
	ram32x3 ramSubModule(.address(addressFF), .clock, .data(dataFF), .wren(wrenFF), .q);
	

endmodule

`timescale 1 ps / 1 ps

module task1tb();


 logic [4:0] address;
 logic[2:0] data;
 logic wren;
 logic [2:0] q;
 logic clock; 
 
 task1 dut(.*);
 
 parameter CLOCK_PERIOD = 100;
	initial begin 
		clock <= 0; 
		forever #(CLOCK_PERIOD/2) clock <= ~clock;
	end

	initial begin
		wren <= 1; data <= 3'b001; address <= 4'b0001; @(posedge clock);
		                           @(posedge clock);
		//show that it reads when wren = 0
		wren <= 0; data <= 3'b111; @(posedge clock);
		$stop;
	end
endmodule 