`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2026 01:08:31 PM
// Design Name: 
// Module Name: koggestone_8bit_adder
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
(* DONT_TOUCH = "yes" *)

module kogge_stone_8bit_adder (
    input        clk,    // Clock for synchronization
    input        rst_n,  // Active-low asynchronous reset
    input  [7:0] A_in,
    input  [7:0] B_in,
    input        Cin_in,
    output reg [7:0] Sum, // Changed to 'reg' for registered output
    output reg       Cout // Changed to 'reg' for registered output
);

    // Internal Registers for Input Stage
    reg [7:0] A, B;
    reg       Cin;

    // Internal Wires for Combinational Logic
    wire [7:0] G, P;
    wire [7:0] G1, P1;
    wire [7:0] G2, P2;
    wire [7:0] G3, P3;
    wire [7:0] C;
    wire [7:0] Sum_comb; // Combinational Sum
    wire       Cout_comb; // Combinational Carry-out

    // --- 1. INPUT REGISTER STAGE ---
    // This snaps the input values on the rising edge of the clock.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A   <= 8'b0;
            B   <= 8'b0;
            Cin <= 1'b0;
        end else begin
            A   <= A_in;
            B   <= B_in;
            Cin <= Cin_in;
        end
    end

    // --- 2. COMBINATIONAL LOGIC (Kogge-Stone Tree) ---
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : GP
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // STAGE 1
    assign G1[0] = G[0];
    assign P1[0] = P[0];
    generate
        for (i = 1; i < 8; i = i + 1) begin : STAGE1
            black_cell BC1 (G[i], P[i], G[i-1], P[i-1], G1[i], P1[i]);
        end
    endgenerate

    // STAGE 2
    assign G2[0] = G1[0];
    assign G2[1] = G1[1];
    assign P2[0] = P1[0];
    assign P2[1] = P1[1];
    generate
        for (i = 2; i < 8; i = i + 1) begin : STAGE2
            black_cell BC2 (G1[i], P1[i], G1[i-2], P1[i-2], G2[i], P2[i]);
        end
    endgenerate

    // STAGE 3
    assign G3[0] = G2[0];
    assign G3[1] = G2[1];
    assign G3[2] = G2[2];
    assign G3[3] = G2[3];
    assign P3[0] = P2[0];
    assign P3[1] = P2[1];
    assign P3[2] = P2[2];
    assign P3[3] = P2[3];
    generate
        for (i = 4; i < 8; i = i + 1) begin : STAGE3
            black_cell BC3 (G2[i], P2[i], G2[i-4], P2[i-4], G3[i], P3[i]);
        end
    endgenerate

    // CARRY GENERATION
    assign C[0] = Cin;
    gray_cell GC1 (G[0],   P[0],   Cin, C[1]);
    gray_cell GC2 (G1[1],  P1[1],  Cin, C[2]);
    gray_cell GC3 (G2[2],  P2[2],  Cin, C[3]);
    gray_cell GC4 (G2[3],  P2[3],  Cin, C[4]);
    gray_cell GC5 (G3[4],  P3[4],  Cin, C[5]);
    gray_cell GC6 (G3[5],  P3[5],  Cin, C[6]);
    gray_cell GC7 (G3[6],  P3[6],  Cin, C[7]);
    gray_cell GC8 (G3[7],  P3[7],  Cin, Cout_comb);

    // SUM GENERATION
    generate
        for (i = 0; i < 8; i = i + 1) begin : SUM_LOGIC
            assign Sum_comb[i] = P[i] ^ C[i];
        end
    endgenerate

    // --- 3. OUTPUT REGISTER STAGE ---
    // This holds the stable result for the next clock cycle.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Sum  <= 8'b0;
            Cout <= 1'b0;
        end else begin
            Sum  <= Sum_comb;
            Cout <= Cout_comb;
        end
    end

endmodule

// Helper Modules (Remain purely combinational)
module black_cell (
    input  Gik, Pik, Gkj, Pkj,
    output Gij, Pij
);
    assign Gij = Gik | (Pik & Gkj);
    assign Pij = Pik & Pkj;
endmodule

module gray_cell (
    input  Gik, Pik, Gkj,
    output Gij
);
    assign Gij = Gik | (Pik & Gkj);
endmodule