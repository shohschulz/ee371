//This module runs the user input through 2 DFF's to avoid metastability
module UserInput (clk, reset, q, d);
    input logic clk, reset, d; 
    output logic q; 
    logic q1;
    D_FF first (.q(q1), .d , .reset, .clk);
    D_FF second (.q, .d(q1) , .reset, .clk);
endmodule
