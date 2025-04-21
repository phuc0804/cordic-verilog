`timescale 1ns / 1ps


module counter #(size = 8) (clk, rst, ld, ld_val, en, up, val);
    input                 clk, rst, ld, en, up;
    input      [size-1:0] ld_val;
    output reg [size-1:0] val;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            val <= 0;
        end else if (ld) begin
            val <= ld_val;
        end else if (en) begin
            val <= (up) ? val+1 : val-1;
        end
    end
endmodule

module barrelshift #(size = 8) (barrel_in, barrel, right, barrel_out);
    input      signed [size-1:0] barrel_in;
    input                  [3:0] barrel;
    input                        right;
    output reg signed [size-1:0] barrel_out;
    
    always @(barrel_in, barrel, right) begin
        if (barrel == 0) begin
            barrel_out = barrel_in;
        end else if (barrel == 1) begin
            barrel_out = (right) ? barrel_in >>> 1 : barrel_in <<< 1;
        end else if (barrel == 2) begin
            barrel_out = (right) ? barrel_in >>> 2 : barrel_in <<< 2;
        end else if (barrel == 3) begin
            barrel_out = (right) ? barrel_in >>> 3 : barrel_in <<< 3;
        end else if (barrel == 4) begin
            barrel_out = (right) ? barrel_in >>> 4 : barrel_in <<< 4;
        end else if (barrel == 5) begin
            barrel_out = (right) ? barrel_in >>> 5 : barrel_in <<< 5;
        end else if (barrel == 6) begin
            barrel_out = (right) ? barrel_in >>> 6 : barrel_in <<< 6;
        end else if (barrel == 7) begin
            barrel_out = (right) ? barrel_in >>> 7 : barrel_in <<< 7;
        end else if (barrel == 8) begin
            barrel_out = (right) ? barrel_in >>> 8 : barrel_in <<< 8;
        end else if (barrel == 9) begin
            barrel_out = (right) ? barrel_in >>> 9 : barrel_in <<< 9;
        end else if (barrel == 10) begin
            barrel_out = (right) ? barrel_in >>> 10 : barrel_in <<< 10;
        end else if (barrel == 11) begin
            barrel_out = (right) ? barrel_in >>> 11 : barrel_in <<< 11;
        end else if (barrel == 12) begin
            barrel_out = (right) ? barrel_in >>> 12 : barrel_in <<< 12;
        end else if (barrel == 13) begin
            barrel_out = (right) ? barrel_in >>> 13 : barrel_in <<< 13;
        end else if (barrel == 14) begin
            barrel_out = (right) ? barrel_in >>> 14 : barrel_in <<< 14;
        end else if (barrel == 15) begin
            barrel_out = (right) ? barrel_in >>> 15 : barrel_in <<< 15;
        end
    end
endmodule

module register #(size = 8) (clk, rst, ld, ld_val, val);
    input clk, rst, ld;
    input      signed [size-1:0] ld_val;
    output reg signed [size-1:0] val;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            val <= 0;
        end else if (ld) begin
            val <= ld_val;
        end
    end
endmodule

module cordic (clk, rst, s, angle, done, sine, cosine);
    input                   clk, rst, s;
    input   signed  [31:0]  angle;
    output  reg             done;
    output  signed  [31:0]  sine, cosine;
    
    reg              [1:0]  y, yn;
    wire                    z;
    wire             [3:0]  cntr_val0;
    
    wire    signed  [31:0]  atan [0:15];
    reg                     reg_ld_angle, reg_ld_sine, reg_ld_cosine, cntr_ld0, cntr_en0;
    wire    signed  [31:0]  reg_ld_val_angle, reg_ld_val_sine, reg_ld_val_cosine;
    wire    signed  [31:0]  reg_val_angle, reg_val_sine, reg_val_cosine, bshft_val_cosine, bshft_val_sine;
    
    assign atan[0]  = 450_000_000;
    assign atan[1]  = 265_650_512;
    assign atan[2]  = 140_362_435;
    assign atan[3]  = 071_250_163;
    assign atan[4]  = 035_763_344;
    assign atan[5]  = 017_899_106;
    assign atan[6]  = 008_951_737;
    assign atan[7]  = 004_476_142;
    assign atan[8]  = 002_381_050;
    assign atan[9]  = 001_119_057;
    assign atan[10] = 000_559_529;
    assign atan[11] = 000_279_765;
    assign atan[12] = 000_139_882;
    assign atan[13] = 000_069_941;
    assign atan[14] = 000_034_971;
    assign atan[15] = 000_017_485;
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            y <= 0;
        end else begin
            y <= yn;
        end
    end
    
    always @(y, s, z) begin
        case (y)
            0: begin
                if (~s) begin
                    yn <= 0;
                end else begin
                    yn <= 1;
                end
            end
            1: begin
                if (~z) begin
                    yn <= 1;
                end else begin
                    yn <= 2;
                end
            end
            2: begin
                if (s) begin
                    yn <= 2;
                end else begin
                    yn <= 0;
                end
            end
            default: yn <= 2'bxx;
        endcase
    end
    
    always @(y, s) begin
        reg_ld_angle = 0; reg_ld_sine = 0; reg_ld_cosine = 0; cntr_ld0 = 0; cntr_en0 = 0; done = 0;
        case (y)
            0: begin
                reg_ld_angle = 1;
                if (s) begin
                    reg_ld_sine = 1; reg_ld_cosine = 1; cntr_ld0 = 1;
                end
            end
            1: begin
                reg_ld_angle = 1; reg_ld_sine = 1; reg_ld_cosine = 1; cntr_en0 = 1;
            end
            2: begin
                done = 1;
            end
        endcase
    end
    
    assign reg_ld_val_angle = (y == 0) ? angle : (y == 1) ? (reg_val_angle >= 000_000_000) ? 
        reg_val_angle - atan[cntr_val0] : reg_val_angle + atan[cntr_val0] : 0;
    assign reg_ld_val_cosine = (y == 0) ? 006_073_000 : (y == 1) ? (reg_val_angle >= 000_000_000) ?
        reg_val_cosine - bshft_val_sine : reg_val_cosine + bshft_val_sine : 0;
    assign reg_ld_val_sine = (y == 0) ? 000_000_000 : (y == 1) ? (reg_val_angle >= 000_000_000) ?
        reg_val_sine + bshft_val_cosine : reg_val_sine - bshft_val_cosine : 0;
    
    assign z = (cntr_val0 == 15);
    
    counter   #(4) c0 (clk, rst, cntr_ld0, 0, cntr_en0, 1, cntr_val0);
    register #(32) r_angle (clk, rst, reg_ld_angle, reg_ld_val_angle, reg_val_angle);
    register #(32) r_cosine (clk, rst, reg_ld_cosine, reg_ld_val_cosine, reg_val_cosine);
    register #(32) r_sine (clk, rst, reg_ld_sine, reg_ld_val_sine, reg_val_sine);
    barrelshift #(32) b_cosine (reg_val_cosine, cntr_val0, 1, bshft_val_cosine);
    barrelshift #(32) b_sine (reg_val_sine, cntr_val0, 1, bshft_val_sine);
    
    assign sine = reg_val_sine;
    assign cosine = reg_val_cosine;
endmodule
