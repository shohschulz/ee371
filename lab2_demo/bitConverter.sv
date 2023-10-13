module bitConverter(address, tens_logic, ones_logic);
	logic [3:0] tens, ones;
	logic [4:0] address_int;
	input logic [4:0] address;
	output logic [3:0] tens_logic;
	output logic [3:0] ones_logic;
	
	assign address_int = (address[4] << 4) | (address[3] << 3) | (address[2] << 2) | (address[1] << 1) | address[0];
	assign tens = address_int / 10;
	assign ones = address_int % 10;
	
	
	always @(tens, ones) begin
		tens_logic = {3'b0, tens};
		ones_logic = {3'b0, ones};
	end

endmodule

