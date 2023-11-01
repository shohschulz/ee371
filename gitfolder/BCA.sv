module BCA_cntrl(clk, start, A, reset, zeroFlag, A0, Load_A, result, rShift, done, increment, loadReady);
	input logic start, reset, clk; 
	input logic [7:0] A; 
	
	//status signals
	input logic zeroFlag, A0; 
	
	//control signals
	output logic rShift, result, done, increment, loadReady; 
	output logic [7:0] Load_A;
	
	
	enum {S1, S2, S3} ps, ns; 
	
always_comb begin
    result = 0; done = 0; loadReady = 0; increment = 0; rShift = 0; Load_A = 8'b0;
    
    case (ps)
        S1: begin
            // sets A to 0;
            result = 1;
            if (start == 1) begin
                ns = S2;
            end
            else begin
                // Load A
                Load_A = A;
                loadReady = 1;
					 ns = S1; 
            end
        end
        S2: begin
            rShift = 1;
            if (zeroFlag) begin
                ns = S3;
            end
            else if (A0) begin
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

module BCA_datapath(clk, Load_A, rShift, result, done, increment, loadReady, zeroFlag, A0, sumToBoard, finished);
	input logic clk, rShift, result, done, increment;
	input logic [7:0] Load_A;
	input logic loadReady;
	
	//status signals
	output logic zeroFlag, A0; 
	
	//wires for output to board operations
	logic [3:0] sum;
	logic [7:0] A; 
	
	//outputs to the board
	output logic [3:0] sumToBoard;
	output logic finished; 
	
	//if finished sum goes back to zero
	assign sumToBoard = done ? sum : '0; 
	
	
	assign finished = done ? 1'b1 : 1'b0; 
	
	//control signals from cntrl determines each RTL operation. 
	always_ff @(posedge clk) begin
			//from control
			if(loadReady)
				A <= Load_A;
			else if(rShift) 
				A <= A >> 1;
			else if(result)
				A <= 0;
			else if(increment)
				sum <= sum + 1;
			
			//status signals
			
			if(A == 0)  
				zeroFlag = 1; 
			else 
				A0 = A[0];
	end
	 
endmodule
