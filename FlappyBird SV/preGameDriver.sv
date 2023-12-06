import Constants::*;
//draw everything, set rgb values, 
module preGameDriver (reset, x, y, redGameOver, greenGameOver, yellowGameOver, 
birdTop, birdBot, birdLeft, birdRight, //bird dimensions
finalObsLeft1, finalObsRight1, finalYBot1, finalYTop1, //obstacle1 dimensions
finalObsLeft2, finalObsRight2, finalYBot2, finalYTop2, //obstacle2 dimensions
finalObsLeft3, finalObsRight3, finalYBot3, finalYTop3, //obstacle2 dimensions
yScreenMax, yScreenMin, //Screen dimensions
collision, r, g, b)
    input logic [7:0] x, y;
    input logic [8:0] birdTop, birdBot, birdLeft, birdRight; 
    input logic [8:0] yScreenMax, yScreenMin; 
    input logic [8:0] finalYBot1, finalYTop1;
    input logic [9:0] finalObsLeft1, finalObsRight1;
    input logic [8:0] finalYBot2, finalYTop2;
    input logic [9:0] finalObsLeft2, finalObsRight2;
    input logic [8:0] finalYBot3, finalYTop3;
    input logic [9:0] finalObsLeft3, finalObsRight3;
    input logic [7:0] redGameOver, greenGameOver, yellowGameOver;
    input logic collision; 
    output logic [7:0] r, g, b; 
//draw game over screen 

//draw reset screen 
always_comb begin
    if(reset) begin //red
        r = 255; 
        g = 0;
        b = 0;
    end
    if(collision) begin 
        r = redGameOver;
        g = greenGameOver;
        b = yellowGameOver
    end
    else if ((x <= BirdRight && x >= BirdLeft) && (y <= BirdBot && y >= BirdTop)) begin
        r = 255; // yellow
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight1 && x >= finalObsLeft1) && (y <= Screen_HEIGHT && y >= finalYBot1)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight1 && x >= finalObsLeft1) && (y <= finalYTop1 && y >= yScreenMin)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight2 && x >= finalObsLeft2) && (y <= Screen_HEIGHT && y >= finalYBot2)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight2 && x >= finalObsLeft2) && (y <= finalYTop2 && y >= yScreenMin)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight3 && x >= finalObsLeft3) && (y <= Screen_HEIGHT && y >= finalYBot3)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else if ((x <= finalObsRight3 && x >= finalObsLeft3) && (y <= finalYTop3 && y >= yScreenMin)) begin
        r = 0; //green
        g = 255;
        b = 0;
    end
    else begin //white if nothing has been generated yet, should never reach this
        r = 255;
        g = 255;
        b = 255;
    end

end

endmodule

 
