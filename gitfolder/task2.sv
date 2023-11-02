`timescale 1 ps / 1 ps
module task2(A, start, reset, Loc, Done, Found, clk);

	input logic [7:0] A; 
	input logic start, reset, clk; 
	output logic [4:0] Loc;
	
	output logic Done, Found; 
	
	
	logic [7:0] middle;
	logic [4:0] upper, lower;
	logic search_up, search_low, loadReady, finished, conFound;
	
	
	
	task2_control control(.A, .start, .middle, .upper, .lower, .reset, .search_up, .search_low, .loadReady, .finished, .conFound, .clk);
	
	task2_dp datapath(.search_up, .search_low, .loadReady, .finished, .Loc, .Done, .Found, .conFound, .upper, .middle, .lower, .clk);

endmodule 




module task2_control(A, start, middle, upper, lower, reset, search_up, search_low, loadReady, finished, conFound, clk);

	input logic start, reset, clk;
	input logic [7:0] middle; 
	input logic [4:0] upper, lower;
	input logic [7:0] A;
	output logic search_up, search_low, loadReady, finished, conFound;

	enum{S0, S1, S2, S3} ps, ns;
	always_comb begin
	search_up = 0; search_low = 0; loadReady = 0; finished = 0; conFound = 0;
		case(ps)
			S0: begin //idle state
				if(start) ns = S1;
				
				else begin
				loadReady = 1; ns = S0;
				end
			end
			S1: begin //starting state, pick center value of array in datapath
				if (upper == lower) 
					ns = S3;
				else if(A < middle) begin 
					search_low = 1; 
					ns = S1; 
				end
				else if(A > middle) begin 
					search_up = 1; 
					ns = S1;
				end
				else ns = S2;
				 
			end
			S2: begin //done state
				finished = 1;
				conFound = 1;
				ns = S2;
				
			end
			S3: begin //not found state
				finished = 1;
				conFound = 0;
				ns = S3;
				
			end
			
			default: ns = S0;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(reset) ps <= S0;
		else ps <= ns;
		
	
	end
endmodule 



module task2_dp(search_up, search_low,loadReady, finished, Loc, Done, conFound, Found, upper, middle, lower, clk);
	
	input logic search_up, search_low, loadReady, finished, conFound, clk;
	
	output logic Done, Found;
	output logic [4:0] Loc; //final location
	output logic [7:0] middle; //information in middle address
	output logic [4:0] upper, lower;
	logic [4:0] address; //current address
	logic [4:0] middleAddr; 
	parameter N = 32;
	BSA_RAM ramSub(.address(middleAddr),
		.clock(clk),
		.data(0),
		.wren(0),
		.q(middle));
		
	
	always_ff @(posedge clk) begin
		if(search_up) begin
			upper <= upper;
			lower <= middleAddr - 1;
		end
		
		if(search_low) begin
			upper <= middleAddr + 1; 
			lower <= lower;
		end
			
		if(conFound && finished) begin
			Loc <= middleAddr; 
			Found <= 1;
			Done <= 1; 
		end
		else if(~conFound && finished) begin
			Done <= 1; 
		end
				
		if(loadReady) begin   
			upper <= N-1;
			lower <= 0;
		end
	end
	
	assign middleAddr = (upper + lower) / 2;
		
endmodule 

module task2_tb();

	logic [7:0] A; 
	logic start, reset, clk; 
	logic [4:0] Loc;
	
	logic Done, Found; 
	
	task2 dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
		
	initial begin
		reset <= 0; @(posedge clk);
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		A <= 7'b0000011; @(posedge clk);
		start <= 0; @(posedge clk);
		start <= 1; @(posedge clk);
		
		for (int i = 0; i < 15; i++) begin
			@(posedge clk);
		end
		
		$stop;
	end
endmodule
	




