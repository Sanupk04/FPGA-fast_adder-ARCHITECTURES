# Create a 2.0ns clock (500 MHz)

create_clock -period 5.000 -name sys_clk [get_ports clk]



# Apply input/output delays to ensure accurate path analysis

set_input_delay -clock clk 0.5 [get_ports {A_in[*] B_in[*] Cin_in}]

set_output_delay -clock clk 0.5 [get_ports {SUM[*] COUT}] 
set_property KEEP_HIERARCHY TRUE [get_cells -hierarchical *]

