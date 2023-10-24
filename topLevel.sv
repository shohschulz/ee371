module topLevel (CLOCK_50, CLOCK2_50, SW, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	input logic [9:0] SW;
	
	parameter N = 3;
	
	//Task3
	

	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	wire [15:0] currAdd;
	wire [23:0] outData;
	wire [23:0] currDataLeft;
	wire [23:0] currDataRight;
	wire [23:)] currData;
	
	
	always_ff @(posedge CLOCK_50) begin
		if(SW[9] ) begin
			currDataLeft <= outData;
			currDataRight <= outData;
		end
		else if (~SW[9])begin
			currDataLeft <= readdata_left;
			currDataRight <= readdata_right;
		end
	end
	counter currentAddress(.curr(currAdd), .clk(CLOCK_50));
	
	ROM task2(.address(currAdd), .clock(CLOCK_50), .q(outData));
	
	logic empty, full; 
	logic [23:0] fDataIn;
	logic [23:0] fDataOut;
	//divide by N, shift right
	assign fDataIn = writeData_left >> N;
	
	FIFO #(.DATA_WIDTH(24), .ADDR_WIDTH(N)) fi (.clk(CLOCK_50), .reset, .rd(read), .wr(write), .empty, .full, .w_data(fDataIn), .r_data(fDataOut));
	//only writing when fifo buffer is full, otherwise zero.
	//mux2_1 mx21 (.output_bit, .input_bit_0(0), .input_bit_1(fDataOut), .select_bit(full));
	logic [23:0] muxOut; 
	assign muxOut = full ? fDataOut: 0; 
	
	logic [23:0] adderWire;
	logic [23:0] outData2; 
	//adder
	assign adderWire = fDataIn + (-1 * muxOut); 
	accumlator acc (.out(outData2), .in(fDataOut), .clk(CLOCK_50), .reset);
	
	
	assign writedata_left = currDataLeft;
	assign writedata_right = currDataRight;
	assign read = (read_ready && write_ready);
	assign write = (read_ready && write_ready);
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule

