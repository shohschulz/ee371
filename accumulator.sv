module accumulator (out, in, clk, reset, enable); 
	input logic [23:0] in;
	input logic clk, reset, enable;
	output logic [23:0] out;
	logic [23:0] tmp; 
	
	always_ff@(posedge clk) begin
		if(reset) begin
		tmp <= 24'b0; 
		end
		else if(enable)
			tmp <= tmp + in;
		
		else
			tmp <= tmp;
	
	end
	assign out = tmp; 
endmodule


module accumulatortb(); 
	 logic clk, reset; 
	 logic [23:0] in;
	 logic [23:0] out;
	 
	 accumulator dut (.*); 
	 
	 parameter CLOCK_PERIOD = 100;
	initial begin 
		clk <= 0; 
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		in <= 0; reset <= 1; @(posedge clk);
		 reset <= 0; @(posedge clk);
		
		
		
		for (int i = 0; i < 10; i++) begin
			in <= i; @(posedge clk);
		end
		
		
	$stop;
	end
	
endmodule
	
	
