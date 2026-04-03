# Set a consistent 5ns target for ALL adders
create_clock -period 5.000 -name sys_clk [get_ports clk]

# Keep your realistic I/O delays
set_input_delay -clock clk 0.5 [get_ports {A_in[*] B_in[*] Cin_in}]
set_output_delay -clock clk 0.5 [get_ports {Sum[*] Cout}]
set_property KEEP_HIERARCHY TRUE [get_cells -hierarchical *]