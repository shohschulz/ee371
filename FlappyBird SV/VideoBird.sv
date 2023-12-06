
module VideoBird(bird_height, BirdLeft, BirdRight, BirdTop, BirdBot);
  input [8:0] bird_height;
  output [9:0] BirdLeft, BirdRight;
  output [8:0] BirdTop, BirdBot;

  assign BirdLeft = 10'd60;
  assign BirdRight = 10'd100;
  assign BirdTop = Constants::SCREEN_HEIGHT - (bird_height + (Constants::BIRD_STARTING_HEIGHT / 9'd2));
  assign BirdBot = Constants::SCREEN_HEIGHT - (bird_height - (Constants::BIRD_STARTING_HEIGHT / 9'd2));
endmodule

module VideoBird_testbench();
  logic [8:0] bird_height;
  logic [9:0] BirdLeft, BirdRight;
  logic [8:0] BirdTop, BirdBot;

  VideoBird dut(.bird_height, .BirdLeft, .BirdRight, .BirdTop, .BirdBot);

  initial begin
    bird_height = 9'd20;  #10;
    bird_height = 9'd40;  #10;
    bird_height = 9'd60;  #10;
    bird_height = 9'd20;  #10;
    bird_height = 9'd320; #10;
    bird_height = 9'd460; #10;
  end
endmodule