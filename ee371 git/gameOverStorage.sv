// Every time a game has concluded the score from that game will be written to memory
// Outputs 3 highest scores from the memory;
module gameOverStorage (address, clock, data, wren, largest_values);
    logic [9:0] memory[31:0];
    input logic [4:0] address;
    input logic [9:0] data;
    input logic wren;
    input logic clock;
    output logic [9:0] largest_values[2:0]; // Store the three largest values

    always_ff @(posedge clock) begin
        if (wren == 1) begin
            memory[address] = data;
        end
    end

    // Return the three highest numbers
    // Sequential search for the three largest values
    always_comb begin
        logic [9:0] temp[2:0]; // Declare temporary packed arrays
        temp[2:0] = '{10'b0, 10'b0, 10'b0}; // Initialize the three largest values
        for (int i = 0; i < 32; i++) begin
            if (memory[i] > temp[0]) begin
                temp[2] = temp[1];
                temp[1] = temp[0];
                temp[0] = memory[i];
            end
            else if (memory[i] > temp[1]) begin
                temp[2] = temp[1];
                temp[1] = memory[i];
            end
            else if (memory[i] > temp[2]) begin
                temp[2] = memory[i];
            end
        end
        largest_values = temp; // Assign the packed array to the unpacked array
    end
endmodule
