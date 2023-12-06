module finalScoreStorage(collision, largest_value, score, out);
    input logic collision; 
    input logic [9:0]largest_value[2:0] 
    output logic [29:0] out; 
    always_comb begin
    if(collision) begin
        out[9:0] = largestValue[2];
        out[19:10] = largestValue[1];
        out[29:20] = largestValue[0];
    end
    else
        out[9:0] = score;
        out[19:10] = 10'b0;
        out[29:20] = 10'b0;
    end
endmodule
