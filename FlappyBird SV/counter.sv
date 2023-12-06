module counter(out, clk, reset);
    output logic [4:0] out;
    input logic clk, reset;
    
	 always_ff @(posedge clk) begin
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