# FPGA Implementation of Fast Adder Architectures

##  Overview
This project implements and compares multiple high-speed adder architectures using **Verilog HDL** in **Xilinx Vivado**.

The goal is to analyze the trade-offs between:
- Speed (Timing / WNS)
- Area (LUT utilization)
- Power consumption


##  Tools & Technologies
- Verilog HDL
- Xilinx Vivado
- FPGA (Artix-7 / xc7k70t)


##  Implemented Adders

- Kogge-Stone Adder  
- Brent-Kung Adder  
- Carry Select Adder  
- Carry Lookahead Adder  


## Project Structure
├── kogge_stone/
├── brent_kung/
├── carry_select_adder/
├── carry_lookahead_adder/
└── README.md

Each folder contains:
- Verilog design file
- Testbench
- Timing report
- Power report
- Utilization report


##  Performance Comparison

| Adder               | WNS (ns) | Frequency | LUT | Power |
|--------------------|---------|----------|-----|-------|
| Kogge-Stone        | 0.657   | 200 MHz  | 67  | 0.073W |
| Brent-Kung         | 0.588   | 200 MHz  | 34  | 0.073W |
| Carry Select       | 0.084   | 125 MHz  | 23  | 0.068W |
| Carry Lookahead    | 0.735   | 111 MHz  | 16  | 0.067W |


##  Key Observations

- **Kogge-Stone Adder**
  - Fastest architecture
  - Higher area (more LUT usage)

- **Brent-Kung Adder**
  - Balanced design
  - Reduced wiring complexity

- **Carry Select Adder**
  - Moderate speed improvement
  - Extra hardware usage

- **Carry Lookahead Adder**
  - Minimum area usage
  - Lower performance for larger bit-widths

---

##  Timing Analysis

- Timing evaluated using **Worst Negative Slack (WNS)**
- Higher WNS → Better timing performance
- Kogge-Stone achieved highest frequency


##  Power Analysis

- Power estimated using Vivado Power Report
- Slight differences across architectures
- Trade-off observed between speed and power


##  Verification

- All adders verified using **testbenches**
- Multiple input combinations tested
- Functional correctness validated in simulation


## Key Learning

- Understood trade-offs between:
  - Speed
  - Area
  - Power

- Learned implementation of:
  - Parallel Prefix Adders
  - Carry Lookahead Logic


## Conclusion

- **Kogge-Stone → Fastest**
- **CLA → Lowest area**
- **Brent-Kung → Balanced**
- **Carry Select → Moderate performance**

Different applications require different architectures.


##  Future Scope

- Extend to 16-bit / 32-bit adders
- Implement hybrid adder architectures
- Compare with DSP-based implementations

---

## 👨‍💻 Author
**Sanu P K**  
B.Tech Electronics and Communication Engineering

---
