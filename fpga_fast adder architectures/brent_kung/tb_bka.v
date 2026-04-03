`timescale 1ns / 1ps

module tb_adder;
    reg clk, rst_n;
    reg [7:0] A_in, B_in;
    reg Cin_in;
    wire [7:0] SUM;
    wire COUT;

    // Instantiate the module you are currently testing
    // Change the module name to test each architecture
    brent_kung_adder uut (
        .clk(clk), .rst_n(rst_n),
        .A_in(A_in), .B_in(B_in),
        .Cin_in(Cin_in),
        .SUM(SUM), .COUT(COUT)
    );

    always #5 clk = ~clk; // 10ns period clock

    initial begin
        clk = 0; rst_n = 0;
        A_in = 8'hAA; B_in = 8'h55; Cin_in = 1;
        #20 rst_n = 1; // Release reset
        
        // Add more test cases here
        #20 A_in = 8'hFF; B_in = 8'h01;
        #20 $finish;
    end
endmodule