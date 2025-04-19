`timescale 1ns / 1ps


module cordic_tb();
    reg                 clk, rst, s;
    reg  signed [31:0]  angle;
    wire                done;
    wire signed [31:0]  sine, cosine;
    
    cordic uut (clk, rst, s, angle, done, sine, cosine);
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 0; rst = 1; s = 0; angle = 000_000_000;
        #10 rst = 0;
        #11 angle = 600_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 300_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 450_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 150_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 750_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 900_000_000;
        #1000 s = 1;
        #20 s = 0;
        #10 angle = 000_000_000;
        #1000 s = 1;
        #20 s = 0;
        #1000 rst = 1;
    end
endmodule
