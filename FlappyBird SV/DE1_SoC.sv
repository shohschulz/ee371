import Constants::*;
module DE1_SoC(
    CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, VGA_R, VGA_G, VGA_B,
    VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
  input logic CLOCK_50;
  input logic [3:0] KEY;
  input logic [9:0] SW;
  output logic [6:0] HEX0, HEX1, HEX2, HEX3;
  output VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS;
  output [7:0] VGA_R, VGA_G, VGA_B;
    
    logic clock100; 
Clock_divider clkDivider (.clock_in(CLOCK_50),.clock_out(clock100));
//User input , 2xDFF to avoid metastability
    logic reset = SW[8];
    logic userPress = ~KEY[3];
    logic registeredUserPress;
UserInput user (.clk(CLOCK_50), .reset, .q(registeredUserPress), .d(userPress));
    
    logic [9:0] x1, x2, x3;
    logic [8:0] yBot1, yTop1, yBot2, yTop2, yBot3, yTop3;
Obstacle obs1 (.clk(clock100), .reset, 
.startingYBottom(Constants::OBSTACLE_STARTING_HEIGHT_BOT), .startingX(Constants::OBSTACLE_STARTING_DISTANCE1), 
.startingYTop(Constants::OBSTACLE_STARTING_HEIGHT_TOP),
.yBot(yBot1), .x(x1), .yTop(yTop1),
);
Obstacle obs2 (.clk(clock100), .reset, 
.startingYBottom(Constants::OBSTACLE_STARTING_HEIGHT_BOT), .startingX(Constants::OBSTACLE_STARTING_DISTANCE2), 
.startingYTop(Constants::OBSTACLE_STARTING_HEIGHT_TOP),
.yBot(yBot2), .x(x2), .yTop(yTop2),
);
Obstacle obs3 (.clk(clock100), .reset, 
.startingYBottom(Constants::OBSTACLE_STARTING_HEIGHT_BOT), .startingX(Constants::OBSTACLE_STARTING_DISTANCE3), 
.startingYTop(Constants::OBSTACLE_STARTING_HEIGHT_TOP),
.yBot(yBot3), .x(x3), .yTop(yTop3),
);
    logic [8:0] birdTop, birdBot; //y (max, min)
    logic [8:0] birdLeft, birdRight; // x min max
    logic [8:0] yScreenMax, yScreenMin; 
    logic [8:0] finalYBot1, finalYTop1;
    logic [9:0] finalObsLeft1, finalObsRight1;
    logic [8:0] finalYBot2, finalYTop2;
    logic [9:0] finalObsLeft2, finalObsRight2;
    logic [8:0] finalYBot3, finalYTop3;
    logic [9:0] finalObsLeft3, finalObsRight3;
    logic [8:0] yScreenMax;
    logic yScreenMin;
    assign yScreenMax = 9'd480;
    assign yScreenMin = 1'b0;
ObstacleVideoFormat addMoreSignals1 (.x(x1), .yBot(yBot1), .yTop(yTop1), 
.finalObsLeft(finalObsLeft1), .finalObsRight(finalObsRight1),
.finalYBot(finalYBot1), .finalYTop(finalYTop1));
ObstacleVideoFormat addMoreSignals2 (.x(x2), .yBot(yBot2), .yTop(yTop2), 
.finalObsLeft(finalObsLeft2), .finalObsRight(finalObsRight2),
.finalYBot(finalYBot2), .finalYTop(finalYTop2));
ObstacleVideoFormat addMoreSignals3 (.x(x3), .yBot(yBot3), .yTop(yTop3), 
.finalObsLeft(finalObsLeft3), .finalObsRight(finalObsRight3),
.finalYBot(finalYBot3), .finalYTop(finalYTop3));
    
    logic collision;
CollisionUnit collision (.birdTop, .birdBot, .birdLeft, .birdRight,
.finalYBot1, .finalYTop1, .finalObsLeft1, .finalObsRight1,
.finalYBot2, .finalYTop2, .finalObsLeft2, .finalObsRight2,
.finalYBot3, .finalYTop3, .finalObsLeft3, .finalObsRight3,
.yScreenMin, .yScreenMax, .collision);
    logic done; 
GameStateTracker FSM (.clk, .reset, .collision, .done);
    
    logic redGameOver, greenGameOver, yellowGameOver;
preGameDriver coloringLogic (.reset, .x, .y, .redGameOver, .greenGameOver, .yellowGameOver, 
.birdTop, .birdBot, .birdLeft, .birdRight, //bird dimensions
.finalObsLeft1, .finalObsRight1, .finalYBot1, .finalYTop1, //obstacle1 dimensions
.finalObsLeft2, .finalObsRight2, .finalYBot2, .finalYTop2, //obstacle2 dimensions
.finalObsLeft3, .finalObsRight3, .finalYBot3, .finalYTop3, //obstacle2 dimensions
.yScreenMax, .yScreenMin, //Screen dimensions
.collision);
    logic [4:0] count;
    logic [9:0] largest_value;
    logic [10:0] score;
counter cyclethroughMemory (.out(count), .clk(CLOCK_50), .reset); //fast clk
gameOverStorage memory (.address(count), .clock(CLOCK_50), .data(score), .wren(collision), .largest_value); //fast clk

ScoreCounterLogic currentScore(.clk(CLOCK_50), .reset, .done, .finalObsRight1, .finalObsRight2, .finalObsRight3
.score(score));

//score display
seg7 hex5(.hex({2'b0, score[[9:8]]}), .leds(HEX5));
seg7 hex4(.hex(score[7:4]), .leds(HEX4));
seg7 hex3(.hex(score[3:0]), .leds(HEX3));