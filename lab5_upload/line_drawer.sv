/* Given two points on the screen this module draws a line between
 * those two points by coloring necessary pixels
 *
 * Inputs:
 *   clk    - should be connected to a 50 MHz clock
 *   reset  - resets the module and starts over the drawing process
 *	 x0 	- x coordinate of the first end point
 *   y0 	- y coordinate of the first end point
 *   x1 	- x coordinate of the second end point
 *   y1 	- y coordinate of the second end point
 *
 * Outputs:
 *   x 		- x coordinate of the pixel to color
 *   y 		- y coordinate of the pixel to color
 *   done	- flag that line has finished drawing
 *
 */
module line_drawer(clk, reset, x0, y0, x1, y1, x, y, done);
	input logic clk, reset;
	input logic [10:0]	x0, y0, x1, y1;
	output logic done;
	output logic [10:0]	x, y;
	
	
	logic is_steep;
	
	logic [10:0] absolute_y, absolute_x;
	logic [10:0] x0_a, x1_a, y0_a, y1_a;
	logic [10:0] x0_b, x1_b, y0_b, y1_b;
	
	logic signed [10:0] deltax, deltay;
	logic signed [10:0] y_step;
	logic signed [10:0] error;
	logic signed [10:0] x_, y_;
	
	logic done0, done1;

	  
	abs distance_y (.out(absolute_y), .a(y1), .b(y0));
	abs distance_x (.out(absolute_x), .a(x1), .b(x0));
	assign is_steep = (absolute_y > absolute_x);

	// if steep, switch coordinates
	
	always_comb begin
		if (is_steep) begin
			x0_a = y0;
			y0_a = x0;
			x1_a = y1;
			y1_a = x1;
		end 
		else begin
			x0_a = x0;
			y0_a = y0;
			x1_a = x1;
			y1_a = y1;
		end
	end

	// if x0 is greater than x1 then swap x0 and x1, and swap y0 and y1
	
	always_comb begin
		if (x0_a > x1_a) begin
		x0_b = x1_a;
		x1_b = x0_a;
		y0_b = y1_a;
		y1_b = y0_a;
	end 
		else begin
			x0_b = x0_a;
			x1_b = x1_a;
			y0_b = y0_a;
			y1_b = y1_a;
		end
	end

	// get change in x and change in y
	
	assign deltax = x1_b - x0_b;
	abs #(11) absolute_deltay (.out(deltay), .a(y1_b), .b(y0_b));

	// get y_step
	always_comb begin
		if (y0_b < y1_b) begin
			y_step = 1;
		end
		else begin
			y_step = -1;
		end
	end

	always_ff @(posedge clk) begin 
	// YOUR CODE HERE
	
		if (reset) begin
			// for loop initializing
			x_ <= x0_b;
			y_ <= y0_b;
			error <= -(deltax/2);
			done0 <= 0;
			done1 <= 0;
		end 
		else if (x_ < (x1_b + 1)) begin
		// in the loop
		
			done1 <= done0;
			x_ <= x_ + 1;
			if (is_steep) begin
				x <= y_;
				y <= x_;
			end 
			else begin
				x <= x_;
				y <= y_;
			end
			if ((error + deltay) >= 1) begin
				
				y_ <= y_ + y_step;
				error <= error + deltay - deltax;
			end 
			else begin
				y_ <= y_;
				error <= error + deltay;
			end
		end	
		else begin
		// finished the loop, output done
		
			done0 <= 1;
			done1 <= done0;
		end
	end // always_ff

	assign done = done0 ^ done1;
	
endmodule // line_drawer


module line_drawer_testbench ();

	logic [10:0]	x0, y0, x1, y1;
	logic [10:0]	x, y;
	logic clk, reset, done;

	line_drawer dut (.*);

	parameter CLOCK_PERIOD = 300;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	integer i;
	initial begin
		
		reset <= 1; x0 <= 11'd1; y0 <= 11'd1; x1 <= 11'd1;  y1  <= 11'd5; @(posedge clk);
		
		reset <= 0;
		for (i = 0; i < 6; i++)
			@(posedge clk);

		reset <= 1; x0 <= 11'd1; y0 <= 11'd1; x1 <= 11'd12;  y1  <= 11'd5; @(posedge clk);
		
		reset <= 0;
		for (i = 0; i < 12 + 2; i++)
			@(posedge clk);
		$stop();
	end
endmodule
	
	
	

	
