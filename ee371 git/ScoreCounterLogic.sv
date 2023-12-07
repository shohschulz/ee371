module ScoreCounterLogic (clk, reset, done, finalObsRight1, finalObsRight2, finalObsRight3,
score);
    input logic clk, reset, done; 
    input logic [9:0] finalObsRight1, finalObsRight2, finalObsRight3;
    output logic [9:0] score; 
    always_ff @(posedge clk) begin
        if(reset || done)
            score = 0; 
        if(!done && ((finalObsRight1 < BIRD_STARTING_DISTANCE) || 
        (finalObsRight2 < BIRD_STARTING_DISTANCE) || 
        (finalObsRight3 < BIRD_STARTING_DISTANCE))) begin
            score += 1; 
        end

    end

endmodule