`timescale 1ns / 1ps

module tb_CSelA8_Top;

    // Inputs
    reg clk;
    reg rst_n;
    reg [7:0] a_in;
    reg [7:0] b_in;

    // Outputs
    wire [7:0] sum_out;
    wire cout_out;

    // Instantiate the Unit Under Test (UUT)
    CSelA8_Top uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .a_in(a_in), 
        .b_in(b_in), 
        .sum_out(sum_out), 
        .cout_out(cout_out)
    );

    // Clock generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        a_in = 0;
        b_in = 0;

        // Release Reset after 20ns
        #20 rst_n = 1;

        // Test Case 1: Simple Addition
        // Input logic at 25ns, result expected at 45ns (2 clock cycles)
        #5 a_in = 8'd10; b_in = 8'd20; 
        
        // Test Case 2: Maximum value without Carry
        #10 a_in = 8'd100; b_in = 8'd50;

        // Test Case 3: Addition with Carry Out
        #10 a_in = 8'd200; b_in = 8'd100;

        // Test Case 4: All ones
        #10 a_in = 8'hFF; b_in = 8'h01;

        // Wait and Finish
        #50;
        $stop;
    end

    // Monitor for verification
    initial begin
        $monitor("Time=%0t | rst_n=%b | A=%d B=%d | Sum=%d Cout=%b", 
                 $time, rst_n, a_in, b_in, sum_out, cout_out);
    end
      
endmodule