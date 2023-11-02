module task2(SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0, HEX1, HEX0, KEY3, KEY0, LEDR9, LEDR0, clk);

	input logic SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0, KEY3, KEY0, clk;
	
	output logic [6:0] HEX1, HEX0;
	
	output logic LEDR9, LEDR0;

	
	logic [7:0] A;
	logic search_up, search_low, less_than, greater_than;
	
	
	assign A = {SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0};
	
	
	
	task2_control control(A, start, reset, less_than, greater_than, search_up, search_low, search_mid, clk);
	
	task2_dp datapath(A, search_up, search_low, search_mid, Loc, .Done(LEDR9), .Found(LEDR0), less_than, greater_than, clk);

endmodule 


module task2_control(A, start, reset, less_than, greater_than, search_up, search_low, search_mid, clk);

	input logic start, reset, clk, less_than, greater_than;
	input logic [7:0] A;
	output logic search_up, search_low, search_mid;

	enum{S0, S1, S1, S3} ps, ns;
	always_comb begin
		case(ps)
			S0: begin //idle state
				if(start) ns = S1;
				else ns = ps;
			end
			S1: begin //starting state, pick center value of array in datapath
				 search_mid = 1;
				 if(less_than) ns = S2;
				 if(greater_than) ns = S3;
				 else ns = ps;
				 
			end
			S2: begin //less_than state, if our value is less than the found value, we 
						 //grab center value between the lower bound and found address
				search_low = 1;
				
			
			end
			S3: begin //greater_than state, if our value is greater than the found value, we 
						 //grab center value between the upper bound and found address
				search_up = 1;
			
			end
			
			default: ns = S0;
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
	


