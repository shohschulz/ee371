/* Top level module of the FPGA that takes the onboard resources 
 * as input and outputs the lines drawn from the VGA port.
 *
 * Inputs:
 *   KEY 			- On board keys of the FPGA
 *   SW 			- On board switches of the FPGA
 *   CLOCK_50 		- On board 50 MHz clock of the FPGA
 *
 * Outputs:
 *   HEX 			- On board 7 segment displays of the FPGA
 *   LEDR 			- On board LEDs of the FPGA
 *   VGA_R 			- Red data of the VGA connection
 *   VGA_G 			- Green data of the VGA connection
 *   VGA_B 			- Blue data of the VGA connection
 *   VGA_BLANK_N 	- Blanking interval of the VGA connection
 *   VGA_CLK 		- VGA's clock signal
 *   VGA_HS 		- Horizontal Sync of the VGA connection
 *   VGA_SYNC_N 	- Enable signal for the sync of the VGA connection
 *   VGA_VS 		- Vertical Sync of the VGA connection
 */
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR[8:0] = SW[8:0];
	
	logic [10:0] x0, y0, x1, y1, x, y;
	
	VGA_framebuffer fb (
		.clk50			(CLOCK_50), 
		.reset			(1'b0), 
		.x, 
		.y,
		.pixel_color	(SW[8]), 
		.pixel_write	(1'b1),
		.VGA_R, 
		.VGA_G, 
		.VGA_B, 
		.VGA_CLK, 
		.VGA_HS, 
		.VGA_VS,
		.VGA_BLANK_n	(VGA_BLANK_N), 
		.VGA_SYNC_n		(VGA_SYNC_N));
	
	
	Clock_divider clkdivider(.clock_in(CLOCK_50), .clock_out(clk));
	logic done;

	line_drawer lines (.clk, .reset(SW[0]|| done),.x0, .y0, .x1, .y1, .x, .y, .done);
	
	assign LEDR[9] = (ps == doneS);

	//animation FSM below
	enum {start, S1, S2, S3, S4, doneS} ps, ns;
	
	always_comb begin
		case(ps)
			start: if(SW[0]) ns = S1; 
						else ns = start;
			S1: if(done) ns = S2;
						else ns = S1;
			S2: if(done) ns = S3;
						else ns = S2;
			S3: if(done) ns = S4;
						else ns = S3;
			S4: if(done) ns = doneS;
						else ns = S4;
			doneS: ns = doneS; 
		endcase
	end
	
	always_ff @(posedge clk) begin
		if(SW[9]) ps <= start;
		else ps <= ns;
	end
	
	always_ff @(posedge clk) begin
		if (ps == S1) begin
			x0 <= 300;
			y0 <= 220;
			x1 <= 240;
			y1 <= 260;
		end
		if (ps == S2) begin
			x0 <= 340;
			y0 <= 220;
			x1 <= 400;
			y1 <= 190;
		end
		if (ps == S3) begin
			x0 <= 220;
			y0 <= 100;
			x1 <= 260;
			y1 <= 150;
		end
		if (ps == S4) begin
			x0 <= 220;
			y0 <= 100;
			x1 <= 260;
			y1 <= 170;
		end
		//dummy stage, this line will not be drawn, only meant for done
		if (ps == doneS) begin
			x0 <= 220;
			y0 <= 100;
			x1 <= 260;
			y1 <= 170;
		end
	end



endmodule  // DE1_SoC


module Clock_divider(clock_in,clock_out);
	input logic clock_in; // input clock on FPGA
	output logic clock_out; // output clock after dividing the input clock by divisor
	logic[27:0] counter=28'd0;
	parameter DIVISOR = 50_000_00;
	// The frequency of the output clk_out
	//  = The frequency of the input clk_in divided by DIVISOR
	// For example: Fclk_in = 50Mhz, if you want to get 1Hz signal to blink LEDs
	// You will modify the DIVISOR parameter value to 28'd50.000.000
	// Then the frequency of the output clk_out = 50Mhz/50.000.000 = 1Hz
	always @(posedge clock_in)
	begin
		 counter <= counter + 28'd1;
		 if(counter>=(DIVISOR-1))
		  counter <= 28'd0;
		 clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
		end

endmodule
