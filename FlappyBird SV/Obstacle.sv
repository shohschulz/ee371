//This module will generate an obstacle based on the location of the last obstacle,
//if the last obstacle has reached the end of the board, a new one will be generated 
//otherwise obstacles on the screen will just move to the left one pixel every clock cycle
import Constants::*;
//640x480

module Obstacle(clk, reset, 
startingYBottom, startingX, startingYTop,
yBot, x, yTop
);
    input logic [9:0] startingX;
    input logic [8:0] startingYTop, startingYBottom;
    logic randomYTop, randomYBot;
    logic currentYTop, currentYBot, currentX; 
    output logic [9:0] x;
    output logic [8:0] yBot, yTop;

    always_comb begin
        if(x <= 10'd0) begin
            currentX = Constants::OBSTACLE_MAX_DISTANCE; //generate obstacle at end of screen
            currentYBot = $urrandom%Constants::OBSTACLE_MAX_Y;
            currentYTop = $urrandom%Constants::OBSTACLE_MAX_Y;
            if(currentYBot < Constants::OBSTACLE_MIN_Y) begin
                currentYBot = Constants::OBSTACLE_MIN_Y;
            end
            if(currentYTop < Constants::OBSTACLE_MIN_Y) begin
                currentYTop = Constants::OBSTACLE_MIN_Y;
            end
        end
        else begin
            currentX = x - 10'd1;
            currentYBot = yBot;
            currentYTop = yTop;
        end
    end 
    always_ff @(posedge clk) begin : synchronization
        if(reset) begin
            x <= startingX; 
            yTop <= startingYTop;
            yBot <= startingYBottom;
        end
        else begin
            x <= currentX; 
            yBot <= currentYBot; 
            yTop <= currentYTop;
        end
    end
endmodule

module Obstacle_testbench(); 
    logic clk, reset; //inputs
    logic startingYBot, startingYTop, startingX; //inputs
    logic x, yBot, yTop; //outputs

    Obstacle dut(.*); //intialization

    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end

    //testing
    initial begin
    reset <= 1; startingYBot <= 9'd160; startingYTop <= 9'd160; startingX <= 10'd500; @(posedge clk);
                @(posedge clk);
                @(posedge clk);
    reset <= 0; @(posedge clk);
                @(posedge clk); 
    for (int i = 0; i < 500; i++) begin //check that x is properly decrementing
                @(posedge clk);
    end
                @(posedge clk); //check to see a new "random" obstacle has been created                 
                @(posedge clk);
    $stop;
    end
endmodule
