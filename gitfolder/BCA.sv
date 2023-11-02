module BCA_cntrl(clk, start, reset, Awire, result, rShift, done, increment, loadReady);
	input logic start, reset, clk; 
	 
	
	//status signals
	input logic [7:0] Awire;
	
	//control signals
	output logic rShift, result, done, increment, loadReady; 
	
	
	
	enum {S1, S2, S3} ps, ns; 
	
always_comb begin
    result = 0; done = 0; loadReady = 0; increment = 0; rShift = 0;
    
    case (ps)
        S1: begin
            // sets A to 0;
            result = 1;
            if (start == 1) begin
                ns = S2;
            end
            else begin
                // Load A
                loadReady = 1;
					 ns = S1; 
            end
        end
        S2: begin
            rShift = 1;
            if (Awire == 0) begin
                ns = S3;
            end
				else if (Awire[0] == 1) begin
					increment = 1;
					ns = S2;
				end
				else 
					ns = S2;
        end
        S3: begin
            done = 1;
            if (start == 1) begin
                ns = S3;
            end
            else begin
                ns = S1;
            end
        end
    endcase
end

	
	always_ff @(posedge clk) begin
		if(reset)
			ps <= S1; 
		else
			ps <= ns; 
	
	end
endmodule

//module BCAcntrltb();
//	logic start, reset, clk; 
//	logic [7:0] A; 
//	
//	//status signals
//	logic [7:0] Awire; 
//	
//	//control signals
//	logic rShift, result, done, increment, loadReady; 
//	logic [7:0] Load_A;
//	
//	BCA_cntrl dut (.*);
//	
//	parameter CLOCK_PERIOD = 100;
//	initial begin 
//		clk <= 0; 
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	
//	end
//	initial begin
//	//set A
//		reset <= 1; A0 <= 0; zeroFlag <= 0; start <= 0; @(posedge clk);
//		reset <= 0; @(posedge clk);
//		start <= 0; @(posedge clk); //Load_ready, stay in s1
//		start <= 1;  @(posedge clk); //go to S2, 
//		A0 <= 1; @(posedge clk); //increment, rShift, stay in S2
//		A0 <= 1;	@(posedge clk); //increment, again stay in S2;
//		A0 <= 0; @(posedge clk); //no increment, stay in S2
//					@(posedge clk);
//		zeroFlag <= 1; @(posedge clk);
//							@(posedge clk);			//should be in S3 and stay
//							@(posedge clk);
//		$stop;
//	end
//	
//endmodule


module BCA_datapath(clk, A, rShift, result, done, increment, loadReady, sumToBoard, finished, Awire);
	input logic clk, rShift, result, done, increment;
	input logic [7:0] A;
	input logic loadReady;
	
	//status signals
	output logic [7:0] Awire;
	
	//wires for output to board operations
	logic [3:0] sum;
	 
	logic test; 
	
	
	//outputs to the board
	output logic [3:0] sumToBoard;
	output logic finished; 
	
	
	assign sumToBoard = done ? sum : '0; 
	
	
	assign finished = done ? 1'b1 : 1'b0; 
	
	//control signals from cntrl determines each RTL operation. 
	always_ff @(posedge clk) begin
			//needs a reset state 
			//should work as intialization  
			//acts as our reset in our datapath
			
			if(result) begin
				sum <= 0; 
			end
			if(rShift) begin
				Awire <= {{1{Awire[7]}}, Awire[7:1]};
			end	
			if (loadReady) 
					Awire <= A;			
			if(increment)
				sum <= sum + 1;
			
			//status signals
		
	end
	
endmodule


module BCA_datapathtb();
	logic clk, rShift, result, done, increment;
	logic [7:0] A;
	logic loadReady;
	logic [7:0] Awire; 
	logic [3:0] sumToBoard;
	logic finished; 
	parameter CLOCK_PERIOD = 100;
	initial begin 
		clk <= 0; 
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	
	end
	
	BCA_datapath dut (.*);
	
	initial begin
	
	rShift <= 0; result <= 0; done <= 0; increment <= 0; A <= 8'b00000000; loadReady <= 0; result <= 1; @(posedge clk);
	result <= 0; @(posedge clk);
	loadReady <= 1; A <= 8'b00001111; @(posedge clk); //Awire should be equal to A
	rShift <= 1; loadReady <= 0; @(posedge clk); //should RShift
	result <= 1; @(posedge clk); //Awire = 0, zero flag
	increment <= 1; result <= 0; @(posedge clk); // should increment
	@(posedge clk);
	$stop;
	end
endmodule
