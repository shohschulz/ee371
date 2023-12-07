module NineBitLinearFeedbackShiftRegister(clock, reset, q);
  input logic clock, reset;
  output logic [8:0] q;

  logic feedback;
  assign feedback = ~(q[8] ^ q[4]);

  always_ff @(posedge clock) begin
    if (reset)
      q <= 9'b000000000;
    else
      q <= {q[7], q[6], q[5], q[4], q[3], q[2], q[1], q[0], feedback};
  end
endmodule
