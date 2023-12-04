//clk: Clock input 
//reset: Will reset the game state to OVER
//collision: True if there is a collision;
//done: True if there is a collision; 
module gameState (clk, reset, collision, done);
    input logic clk, reset, collision;
    output logic done; 
    enum {RUNNING, OVER} ps, ns; 

    always_comb begin : GameStateLogic
        if(collision) begin
            ns = OVER;
        end
        else 
            ns = RUNNING;
    end
    always_ff @(posedge clk) begin
        if(reset)
            ps <= OVER;
        else 
            ps <= ns;
    end

    assign done = (ps == OVER);