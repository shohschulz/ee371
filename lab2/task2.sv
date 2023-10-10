module array32x3 (address, clock, data, wren, q);
	logic [2:0] memory[31:0]; 
	input logic [4:0] address;
	input logic [2:0] data; 
	input logic wren; 
	input logic clock;
	output logic q; 
	
	always_ff @(posedge clock) begin
		if(wren == 1) begin 	
			memory[address] = data; 
			q <= data; 
		end
		else begin
			q <= memory[address];
		end
		
	end

endmodule

//module addressHelp(address, SW4, SW5, SW6, SW7, SW8);
//input logic SW4, SW5, SW6, SW7, SW8;
//output logic address;
//
//always_ff @(posedge clock) begin
//	address <= SW;
//	end
//
//endmodule

module task2(SW, KEY0, q);

	input logic SW[3:1]; //DataIn
	input logic SW[8:4]; //Address
	input logic SW[0], KEY0; //Wren, Clock
	output logic [2:0] q;
	//post ff, write = wren
	logic [4:0] addressFF;
	logic [2:0] dataFF;
	logic wrenFF;
	
	always_comb begin
		case (address)
	
		endcase
		
		case (DataIn)
		
		endcase
	end
	
	always_ff @(posedge clock) begin
			addressFF <= address;
			dataFF <= data; 
			wrenFF <= wren;
	end
	
	

endmodule

	
module task2tb();

 logic [4:0] address;
 logic[2:0] data;
 logic wren;
 logic [2:0] q;
 logic clock; 
 
 task2b dut (.*);
 
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
