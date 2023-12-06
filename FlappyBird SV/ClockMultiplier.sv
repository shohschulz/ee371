module ClockMultiplier (
  input logic clock_in,   // Input clock signal
  output reg clock_out     // Output clock signal after multiplication
);
  reg [27:0] counter = 28'd0;  // 28-bit counter to keep track of divisions
  parameter REAL FRACTIONAL_PART = 0.0005;  // Fractional part for clock multiplication

  always @(posedge clock_in) begin
    counter <= counter + 28'd1;  // Increment the counter on every positive edge of clock_in

    if (counter >= $rtoi(1.0 / FRACTIONAL_PART))  // Reset the counter when it reaches or exceeds the reciprocal of the fractional part
      counter <= 28'd0;

    clock_out <= (counter < $rtoi(0.5 / FRACTIONAL_PART)) ? 1'b1 : 1'b0;  // Toggle clock_out based on counter and fractional part
  end
endmodule
