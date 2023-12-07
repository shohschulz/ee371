import Constants::*;
//This module edits the inputs from the obstacle module to generate obstacle dimensions/locations
//that work with our VGA monitor (640x480).
//Top left bit is 0x0
module ObstacleVideoFormat (x, yBot, yTop, finalObsLeft, finalObsRight,
finalYBot, finalYTop);
    input logic [9:0] x;
    input logic [8:0] yBot, yTop;
    output logic [9:0] finalObsLeft, finalObsRight;
    output logic [8:0] finalYBot, finalYTop;

    assign finalObsLeft = x; //left side
    assign finalObsRight = x + Constants::OBSTACLE_WIDTH;
    assign finalYBot = Constants::SCREEN_HEIGHT - (yBot);
    assign finalYTop = yTop;
endmodule

