(* DONT_TOUCH = "yes" *)
module brent_kung_adder #(
    parameter WIDTH = 8
)(
    input clk, rst_n,
    input [WIDTH-1:0] A_in, B_in,
    input Cin_in,
    output reg [WIDTH-1:0] SUM,
    output reg COUT
);
    // --- 1. Input Registers ---
    reg [WIDTH-1:0] A, B; reg Cin;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) {A, B, Cin} <= 0;
        else {A, B, Cin} <= {A_in, B_in, Cin_in};
    end

    // --- 2. Logic Internal to Tree ---
    localparam STAGES = $clog2(WIDTH);
    wire [WIDTH-1:0] G, P;
    wire [WIDTH:0]   C;
    assign G = A & B;
    assign P = A ^ B;
    assign C[0] = Cin;

    // Intermediate wires for stages
    wire [WIDTH-1:0] G_stage [0:STAGES-1];
    wire [WIDTH-1:0] P_stage [0:STAGES-1];

    genvar i, s;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin
            assign G_stage[0][i] = G[i];
            assign P_stage[0][i] = P[i];
        end
        // Build Reduce Tree using Black Cells
        for (s = 1; s < STAGES; s = s + 1) begin : reduce_stages
            for (i = 0; i < WIDTH; i = i + 1) begin : reduce_level
                if (i >= (1 << s)) begin
                    black_cell bc (G_stage[s-1][i], P_stage[s-1][i], 
                                   G_stage[s-1][i - (1 << (s-1))], P_stage[s-1][i - (1 << (s-1))], 
                                   G_stage[s][i], P_stage[s][i]);
                end else begin
                    assign G_stage[s][i] = G_stage[s-1][i];
                    assign P_stage[s][i] = P_stage[s-1][i];
                end
            end
        end
    endgenerate

    // Fan-out using Grey Cells
    generate
        for (i = 1; i < WIDTH; i = i + 1) begin : carries
            grey_cell gc (G_stage[STAGES-1][i], P_stage[STAGES-1][i], C[i-1], C[i]);
        end
        assign C[WIDTH] = G_stage[STAGES-1][WIDTH-1] | (P_stage[STAGES-1][WIDTH-1] & C[WIDTH-1]);
    endgenerate

    // --- 3. Output Register Stage ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) {SUM, COUT} <= 0;
        else {SUM, COUT} <= {P ^ C[WIDTH-1:0], C[WIDTH]};
    end
endmodule

// Helper modules (Keep these unchanged)
module black_cell(input Gk, Pk, Gj, Pj, output Gout, Pout);
    assign Gout = Gk | (Pk & Gj);
    assign Pout = Pk & Pj;
endmodule

module grey_cell(input Gk, Pk, Gj, output Gout);
    assign Gout = Gk | (Pk & Gj);
endmodule