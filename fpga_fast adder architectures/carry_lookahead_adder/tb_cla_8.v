`timescale 1ns / 1ps

module tb_CLA8_Top;

    // Inputs
    reg clk;
    reg rst_n;
    reg [7:0] a_in;
    reg [7:0] b_in;

    // Outputs
    wire [7:0] sum_out;
    wire cout_out;

    // Instantiate UUT
    CLA8_Top uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .a_in(a_in), 
        .b_in(b_in), 
        .sum_out(sum_out), 
        .cout_out(cout_out)
    );

    // Clock Generation (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        a_in = 0;
        b_in = 0;

        // Reset
        #20 rst_n = 1;

        // Test Case 1: Standard Addition
        #10 a_in = 8'd15; b_in = 8'd25; // Result: 40
        
        // Test Case 2: Maximum value (No carry)
        #10 a_in = 8'd200; b_in = 8'd50; // Result: 250
        
        // Test Case 3: Overflow (Carry Out)
        #10 a_in = 8'd200; b_in = 8'd100; // Result: 44, Cout: 1
        
        // Test Case 4: All zeros
        #10 a_in = 8'h00; b_in = 8'h00;

        #100;
        $stop;
    end

    initial begin
        $monitor("Time=%0t | A=%d B=%d | Sum=%d Cout=%b", 
                 $time, a_in, b_in, sum_out, cout_out);
    end

endmodule