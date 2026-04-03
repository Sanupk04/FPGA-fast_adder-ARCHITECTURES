## 1. Clock Definition - Keep this identical for all adders
create_clock -period 8.000 -name sys_clk [get_ports clk]

## 2. Input/Output Delays (Fair I/O mapping)
# Setting these to 0.5ns (10% of clock) mimics realistic trace delays
set_input_delay -clock sys_clk 0.500 [get_ports {a_in[*] b_in[*] rst_n}]
set_output_delay -clock sys_clk 0.500 [get_ports {sum_out[*] cout_out}]

## 3. Preservation of Structural Logic
# This is VITAL. If you don't do this, Vivado might collapse your beautiful 
# Kogge-Stone tree into a generic ripple-carry adder.
set_property KEEP_HIERARCHY TRUE [get_cells -hierarchical *]