package Constants;
    
    //Screen size
    parameter SCREEN_HEIGHT = 9'd480;
    parameter SCREEN_WIDTH = 10'd640;

    //Obstacle sizes
    parameter OBSTACLE_MIN_Y = 6'd50;
    parameter OBSTACLE_MAX_Y = 8'd200;
    parameter OBSTACLE_MAX_DISTANCE = 10'd680;
    parameter OBSTACLE_WIDTH = 6'd40;
    parameter TIME_TO_OBSTACLE = 6'd50; //tbd
    parameter OBSTACLE_STARTING_HEIGHT_TOP = 7'd120;
    parameter OBSTACLE_STARTING_HEIGHT_BOT = 9'd360;
    parameter OBSTACLE_STARTING_DISTANCE1 = 8'd200; 
    parameter OBSTACLE_STARTING_DISTANCE2 = 9'd350; 
    parameter OBSTACLE_STARTING_DISTANCE3 = 9'd500; 

    //Bird Width
    parameter BIRD_STARTING_HEIGHT = 8'd240;
    parameter BIRD_STARTING_DISTANCE = 7'd80; //left
    parameter BIRD_WIDTH = 6'd40; 
	 parameter BIRD_MAX_HEIGHT = 9'd460;
	 parameter BIRD_MIN_HEIGHT = 5'd20;
endpackage
