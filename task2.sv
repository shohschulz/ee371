//module array32x3 (address, clock, data, wren, q);
//	logic [2:0] memory[31:0]; 
//	input logic [4:0] address;
//	input logic [2:0] data; 
//	input logic wren; 
//	input logic clock;
//	output logic [2:0] q; 
//	
//	always_ff @(posedge clock) begin
//		if(wren == 1) begin 	
//			memory[address] = data; 
//			q <= data; 
//		end
//		else begin
//			q <= memory[address];
//		end
//		
//	end
//
//endmodule

module addressHelp(address, data, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8);
	input logic   SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8;
	output logic [4:0] address;
	output logic [2:0] data;

	assign address = {SW8, SW7, SW6, SW5, SW4};
	assign data = {SW3, SW2, SW1};
			

endmodule



module task2(address, clock, data, wren, q);

	input logic [4:0] address;
	input logic [2:0] data; 
	input logic wren; 
	input logic clock;
	output logic [2:0] q; 
	
	logic [2:0] memory[31:0];

	//wren is SW0, Clock is KEY0

		
	
	
	
	always_ff @(posedge clock) begin
		if (wren) begin
			memory[address] <= data;
			q <= data;
		end
		else
			q <= memory[address];
		end
	
	

endmodule



	
module task2tb();

 logic [4:0] address;
 logic[2:0] data;
 logic wren;
 logic [2:0] q;
 logic clock; 
 
 task2tb dut (.*);
 
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
