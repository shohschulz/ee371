
module bird(clk, reset, up, height);
  input logic clk, reset, up;
  output logic [8:0] height;

  always_ff @(posedge clk) begin
    if (reset)
      height <= Constants::BIRD_STARTING_HEIGHT;
    else
      if (up && height < Constants::BIRD_MAX_HEIGHT)
        height <= height + 9'b1;
      else if (!up && Constants::BIRD_MIN_HEIGHT < height)
        height <= height - 9'b1;
  end
endmodule


module bird_testbench();
  logic clk, reset, up;
  logic [8:0] height;

  bird dut(.clk, .reset, .up, .height);

  parameter clk_PERIOD = 100;
  initial begin
    clk <= 0;
    forever #(clk_PERIOD / 2) clk <= ~clk;
  end

  integer i;
  initial begin
                          @(posedge clk);
    reset <= 1; up <= 0; @(posedge clk);
    reset <= 0; up <= 0; @(posedge clk);
    for (i = 0; i < 300; ++i) begin
      @(posedge clk);
    end

    up <= 1;             @(posedge clk);
    up <= 0;             @(posedge clk);
    up <= 1;             @(posedge clk);
                          @(posedge clk);
                          @(posedge clk);
    up <= 0;             @(posedge clk);
                          @(posedge clk);
    up <= 1;             @(posedge clk);
    for (i = 0; i < 500; ++i) begin
      @(posedge clk);
    end
    $stop;
  end
endmodule 