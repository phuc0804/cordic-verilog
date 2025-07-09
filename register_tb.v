`timescale 1ns / 1ps


module register_tb();
    reg                 clk, rst, ld;
    reg  signed [31:0]  ld_val;
    wire signed [31:0]  val;
    
    register #(32) uut (clk, rst, ld, ld_val, val);
    
    always #1 clk = ~clk;
        
    initial begin
        clk = 0; rst = 1; ld = 0; ld_val = 32'b10001000100010001000100010001000;
        #10 rst = 0;
        #10 ld = 1;
        #10 ld_val = 32'b11111000100010001000100010001000;
        #10 ld = 0;
        #10 ld_val = 32'b11111111100010001000100010001000;
        #10 rst = 1;
    end
endmodule
