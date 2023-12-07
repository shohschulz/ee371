module LSFR_9bit (
    input logic clock,
    input logic reset,
    output logic [8:0] lsfr_output
);

    logic [8:0] shift_register;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            shift_register <= 9'b0;
        end else begin
            // Feedback mechanism using XOR gates
            shift_register[8] <= shift_register[7] ^ shift_register[4];
            shift_register[7:0] <= shift_register[8:1];
        end
    end

    assign lsfr_output = shift_register;

endmodule
