module finalScoreStorage(clk, collision, largest_values, score, out);
    input logic collision, clk;
	 input logic [9:0] score;
    input logic [9:0]largest_values[2:0]; 
    output logic [29:0] out; 
    always_ff @(posedge clk) begin
		 if(collision) begin
			  out[9:0] = largest_values[2];
			  out[19:10] = largest_values[1];
			  out[29:20] = largest_values[0];
		 end
		 else begin
			  out[9:0] = score;
			  out[19:10] = 10'b0;
			  out[29:20] = 10'b0;
		 end
	 end
endmodule 