module task2(SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0, HEX1, HEX0, KEY3, KEY0, LEDR9, LEDR0, clk);

	input logic SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0, KEY3, KEY0, clk;
	
	output logic [6:0] HEX1, HEX0;
	
	output logic LEDR9, LEDR0;
	
	assign start = ~KEY[3];
	assign reset = ~KEY[0];
	
	logic [7:0] A, middle;
	logic [5:0] upper, lower;
	logic search_up, search_low, loadReady, finished, Found;
	
	
	assign A = {SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0};
	
	
	
	task2_control control(A, start, middle, upper, lower, reset, search_up, search_low, loadReady, finished, Found, clk);
	
	task2_dp datapath(A, search_up, search_low, loadReady, finished, Loc, Done, Found, upper, middle, lower, clk);

endmodule 


module task2_control(A, start, middle, upper, lower, reset, search_up, search_low, loadReady, finished, Found, clk);

	input logic start, reset, clk;
	input logic [7:0] middle; 
	input logic [4:0] upper, lower;
	input logic [7:0] A;
	output logic search_up, search_low, loadReady, finished, Found;

	enum{S0, S1, S2, S3} ps, ns;
	always_comb begin
	search_up = 0; search_low = 0; loadReady = 0; finished = 0; Found = 0;
		case(ps)
			S0: begin //idle state
				if(start) ns = S1;
				
				else loadReady = 1; ns = ps;
			end
			S1: begin //starting state, pick center value of array in datapath
				if (upper == lower) ns = S3;
				else if(A < middle) begin 
					search_low = 1; 
					ns = ps; 
				end
				else if(A > middle) begin 
					search_up = 1; 
					ns = ps;
				end
				else ns = S2;
				 
			end
			S2: begin //done state
				finished = 1;
				Found = 1;
				ns = ps;
			
			end
			S3: begin 
				finished = 1;
				Found = 0;
				ns = ps;
				
			end
			
			default: ns = S0;
		endcase
	end
endmodule 



module task2_dp(A, search_up, search_low,loadReady, finished, Loc, Done, Found, upper, middle, lower, clk);
	
	input logic search_up, search_low, loadReady, finished, Found, clk;
	input logic [7:0] A;
	output logic Done, Found;
	output logic [4:0] Loc; //final location
	output logic [7:0] middle //information in middle address
	output logic [4:0] upper, lower;
	logic [4:0] address; //current address
	logic [4:0] middleAddr //
	parameter N = 32;
	BSA_RAM ramSub(.address(middleAddr),
		.clock(clk),
		.data,
		.wren,
		.q(middle));
		
	
	always_ff @(posedge clk) begin
		if(search_up) begin
			upper <= upper;
			lower <= middleAddr;
		end
		
		if(search_low) begin
			upper <= middleAddr; 
			lower <= lower;
		end
		
		if(finished)
			Done <= 1;
			
		if(Found) begin
			Loc <= address; 
			Done <= 1; 
		end
				
		if(loadReady) begin   
			upper <= N-1;
			lower <= 0;
		end
	end
	
	assign middleAddr = (upper - lower) / 2;
		
endmodule 




