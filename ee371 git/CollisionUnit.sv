import Constants::*;
module CollisionUnit (reset, birdTop, birdBot, birdLeft, birdRight,
finalYBot1, finalYTop1, finalObsLeft1, finalObsRight1,
finalYBot2, finalYTop2, finalObsLeft2, finalObsRight2,
finalYBot3, finalYTop3, finalObsLeft3, finalObsRight3,
yScreenMin, yScreenMax, collision);
     
	 input logic reset;
    input logic [8:0] birdTop, birdBot; //y (max, min)
    input logic [8:0] birdLeft, birdRight; // x min max
    input logic [8:0] yScreenMax, yScreenMin; 
    input logic [8:0] finalYBot1, finalYTop1;
    input logic [9:0] finalObsLeft1, finalObsRight1;
    input logic [8:0] finalYBot2, finalYTop2;
    input logic [9:0] finalObsLeft2, finalObsRight2;
    input logic [8:0] finalYBot3, finalYTop3;
    input logic [9:0] finalObsLeft3, finalObsRight3;
    output logic collision; 

    
    always_comb begin 
        //if the bird intersects with the obstacle at all
		  
        if((birdRight >= finalObsLeft1) && (birdLeft <= finalObsRight1) && 
        (birdTop <= finalYTop1 || birdBot >= finalYBot1)) begin
            collision = 1; 
        end
        else if((birdRight >= finalObsLeft2) && (birdLeft <= finalObsRight2) && 
        (birdTop <= finalYTop2 || birdBot >= finalYBot2)) begin
            collision = 1; 
        end
        else if((birdRight >= finalObsLeft3) && (birdLeft <= finalObsRight3) && 
        (birdTop <= finalYTop3 || birdBot >= finalYBot3)) begin
            collision = 1; 
        end
        
        //if a bird hits the edges of the screen
        else if(birdTop == yScreenMin || birdBot == yScreenMax) begin
            collision = 1;
        end
		  else 
				collision = 0;
		  
    end

endmodule

