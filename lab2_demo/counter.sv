//counter increments @ 1hz.
module counter(out, clk, reset);
    output logic [4:0] out;
    input logic clk, reset;
	 logic dividedClk;
	 
	Clock_divider clkdivider(.clock_in(clk), .clock_out(dividedClk));
//	ClockDivider clkdivider(.clk_50MHz(clk), .clk_1Hz(dividedClk));
    
	 always_ff @(posedge dividedClk) begin
        if (reset)
            out <= 0;
        else begin
            if (out < 32)
                out <= out + 1;
				//reset to zero after last memory address
				else begin
					out <= 0;
				end
        end
    end
endmodule


module ClockDivider (
    input logic clk_50MHz,   // 50 MHz input clock
    output logic clk_1Hz     // 1 Hz output clock
);

    localparam COUNTER_WIDTH = 25; // Counter width for a 50 MHz clock to generate 1 Hz

    logic [COUNTER_WIDTH-1:0] counter;

    always_ff @(posedge clk_50MHz) begin
        if (counter == (50_000_000 - 1)) begin
            counter <= 0;
            clk_1Hz <= ~clk_1Hz; // Invert the 1 Hz output clock
        end else begin
            counter <= counter + 1;
        end
    end

endmodule

module Clock_divider(clock_in,clock_out);
	input logic clock_in; // input clock on FPGA
	output logic clock_out; // output clock after dividing the input clock by divisor
	logic[27:0] counter=28'd0;
	parameter DIVISOR = 50_000_000;
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



module counter_testbench();

    logic [4:0] out;
    logic clk, reset;
    counter dut(.*);
    parameter CLOCK_PERIOD = 100;

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);
		  
		  

        repeat (33) begin
            
            @(posedge clk);
        end

        $stop;
    end

endmodule 