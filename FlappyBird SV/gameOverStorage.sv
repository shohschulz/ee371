
 Download
module gameOverStorage (address, clock, data, wren, largest_value);
	logic [9:0] memory[31:0]; 
	input logic [4:0] address;
	input logic [9:0] data; 
	input logic wren; 
	input logic clock;
    output [9:0] largest_value;
	
	always_ff @(posedge clock) begin
		if(wren == 1) begin 	
			memory[address] = data; 
		end
		// do nothing
	end
    //return the highest number 
    // Sequential search for the largest value
    always_comb begin
        largest_value = memory[0];
        for (int i = 1; i < 32; i++) begin
            if (memory[i] > largest_value) begin
                largest_value = memory[i];
            end
        end
    end

endmodule