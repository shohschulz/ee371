module task2(A, start, reset, Loc, done, found, clk);

	input logic [7:0] A; 
	input logic start, reset, clk; 
	output logic [4:0] Loc;
	
	output logic done, found; 
	
	
	logic [7:0] A, middle;
	logic [5:0] upper, lower;
	logic search_up, search_low, loadReady, finished, Found;
	
	
	
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




