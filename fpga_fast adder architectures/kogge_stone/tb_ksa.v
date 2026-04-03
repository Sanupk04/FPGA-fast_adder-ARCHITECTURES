`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 01:11:54 PM
// Design Name: 
// Module Name: Koggestone_8bit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module kogge_stone_8bit_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg [7:0] A_in, B_in;
    reg Cin_in;

    // Outputs
    wire [7:0] Sum;
    wire Cout;

    // Instantiate the Unit Under Test (UUT)
    kogge_stone_8bit_adder uut (
        .clk(clk),
        .rst_n(rst_n),
        .A_in(A_in),
        .B_in(B_in),
        .Cin_in(Cin_in),
        .Sum(Sum),
        .Cout(Cout)
    );

    // 1. Clock Generation: 100MHz clock (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // 2. Stimulus Block
    initial begin
        // Initialize VCD dumping for Vivado/GTKWave
        $dumpfile("kogge_stone_8bit.vcd");
        $dumpvars(0, kogge_stone_8bit_tb);

        // --- Initialize and Reset ---
        rst_n = 0; A_in = 0; B_in = 0; Cin_in = 0;
        #15 rst_n = 1; // Release reset after 1.5 clock cycles

        // --- Test Cases ---
        // Note: Use @(posedge clk) to ensure setup/hold times are met
        
        @(posedge clk); A_in = 8'd1;   B_in = 8'd1;   Cin_in = 0;
        @(posedge clk); A_in = 8'd100; B_in = 8'd28;  Cin_in = 0;
        @(posedge clk); A_in = 8'd255; B_in = 8'd1;   Cin_in = 0;
        @(posedge clk); A_in = 8'hAA;  B_in = 8'h55;  Cin_in = 0;
        @(posedge clk); A_in = 8'hFF;  B_in = 8'h00;  Cin_in = 1;
        
        // Wait a few more cycles to see the final result pass through the output registers
        repeat (3) @(posedge clk);

        $finish;
    end

endmodule