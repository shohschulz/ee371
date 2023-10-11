//counter, increments with entry signal, decrements for exit signal, counter will stop at 16 and no go past.
module counter(out, enter, exit,  clk, reset);
    output logic [4:0] out;
    input logic enter, exit, clk, reset;

    always_ff @(posedge clk) begin
        if (reset)
            out <= 0;
        else if (enter == 1) begin
            if (out < 16)
                out <= out + 1;
        end
        else if (exit == 1) begin
            if (out > 0)
                out <= out - 1;
        end
    end
endmodule


module counter_testbench();

    logic [4:0] out;
    logic enter, exit, clk, reset;
    counter dut (
        .out(out),
        .enter(enter),
        .exit(exit),
        .clk(clk),
        .reset(reset)
    );
    parameter CLOCK_PERIOD = 100;

    initial begin
        clk <= 0;
        forever #(CLOCK_PERIOD/2) clk <= ~clk;
    end

    initial begin
        reset <= 1;
        @(posedge clk);
        reset <= 0;
        @(posedge clk);
		  
		  exit <= 1;
        @(posedge clk);

        repeat (16) begin
            enter <= 1;
            @(posedge clk);
        end

        enter <= 1;
        @(posedge clk);
        enter <= 1;
        @(posedge clk);
        enter <= 1;
        @(posedge clk);

        $stop;
    end

endmodule 