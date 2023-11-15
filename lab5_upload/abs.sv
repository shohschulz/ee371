//Helper module for line_drawer
module abs #(parameter WIDTH = 11) (out, x, y);
	output logic [WIDTH-1:0] out;
	input logic [WIDTH-1:0] x, y;

	always_comb begin
		if (x > y) begin
			out = x - y;
		end
		else begin
			out = y - x;
		end
	end
endmodule 