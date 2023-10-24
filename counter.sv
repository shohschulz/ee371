module counter(curr, clk);
	output logic [15:0] curr;
	input logic clk;
	
	always_ff @(posedge clk) begin
		if(curr < 48001)
			curr <= curr + 1;
				
		else begin 
			curr <= 0;
		end 
			
	end
	
endmodule 