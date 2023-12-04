import Constants::*;
//This module edits the inputs from the obstacle module to generate obstacle dimensions/locations
//that work with our VGA monitor (640x480).
//Top left bit is 0x0
module ObstacleVideoFormat (clk, reset, x, yBot, yTop);
    input logic clk, reset;
    input logic [9:0] x;
    input logic [8:0] yBot, yTop;
    output logic [9:0] finalX;
    output logic [8:0] finalYBot, finalYTop;
    output logic [9:0] yScreenMin, yScreenMaz;

    assign finalX = x; 
    assign finalYBot = Constants::SCREEN_HEIGHT - (yBot);
    assign finalYTop = yTop;
    assign yScreenMin = 9'd0;
    assign yScreenMax = 9'd480;
endmodule