//This module will generate an obstacle based on the location of the last obstacle,
//if the last obstacle has reached the end of the board, a new one will be generated 
//otherwise obstacles on the screen will just move to the left one pixel every clock cycle
import Constants::*;
module ObstacleOld(clk, reset, 
startingY, startingX, startingGap, //initial (x,y) coordinate of the block
y, x, gap); // x, y outputs
    input logic [9:0] startingY, startingX, startingGap;
    output logic [9:0] y, x, gap;
    logic [9:0] randomY, randomGap;
    logic [9:0] currentX, currentY;

    //if the current obstacle has reached the end of the screen, (right to left ), then we want to generate a new obstacle 
    // check x --> set currentX --> based on reset set output to either current or reset value
    always_comb begin : obstacleGeneration
        if(x <= 10'd0) begin
            //generate obstacle @ end of screen 
            currentX = Constants::OBSTACLE_MAX_DISTANCE;
            //generate obstacle size
            currentY = $urandom%Constants::OBSTACLE_MAX_Y;
            if(currentY < Constants::OBSTACLE_MIN_Y) begin
                currentY = Constants::OBSTACLE_MIN_Y;
            end
            currentGap = $urandom%Constants::OBSTACLE_GAP_HEIGHT_MAX
            if (currentGap < Constants::OBSTACLE_GAP_HEIGHT_MIN) begin
                currentGap = Constants::OBSTACLE_GAP_HEIGHT_MIN;
            end
        end
        else begin
            currentX <= x - 10'd1; 
            currentY <= y; 
            currentGap <= gap;
        end
    end
    always_ff @(posedge clk) begin : synchronization
        if(reset) begin
            x <= startingX; 
            y <= startingY;
            gap <= currentGap
        end
        else 
            x <= currentX;
            y <= currentY;
            gap <= startingGap;
    end

endmodule

module Obstacle_testbench();
    logic clk, reset;
    logic [9:0] startingY, startingX, startingGap;
    logic [9:0] y, x, gap;

    Obstacle dut (.*);
    parameter CLOCK_PERIOD = 100;
    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD / 2) clk <= ~clk;
    end
    
    reset <= 1; @(posedge clk);


endmodule
