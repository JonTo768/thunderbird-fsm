# Thunderbird Tail-Light Finite State Machine (SystemVerilog)

## Overview 
Moore finite state machine that generates Thunderbird-style turn signals and hazard behavior. 

## Interface
**Inputs:** clk, reset, LEFT, RIGHT, HAZ
**Outputs:** L_lights[2:0], R_lights[2:0]

## Behavior/State Sequence 
- **IDLE:** L = 000, R = 000
- **LEFT:** L1 --> L2 --> L3 --> IDLE
  - L1: 001, L2: 011, L3: 111 (R stays 000)
- **RIGHT:** R1 --> R2 --> R3 --> IDLE 
  - R1: 001, R2: 011, R3: 111 (L stays 000)
- **HAZ or (LEFT && RIGHT) from IDLE:** LR3 --> IDLE
  - LR3: L = 111, R = 111
- **HAZ asserted during L1/L2/R1/R2:** transitions to LR3 on the next clock cycle, then returns to IDLE

## State Diagram
<img width="764" height="975" alt="image" src="https://github.com/user-attachments/assets/9b8743ea-57a4-41a4-a3c7-916feea4aefd" />

## Project Structure
- `thunderbirdFSM.sv` — RTL implementation (2-process FSM: 1. State Memory 2. Combinational Logic)
- `thunderbirdFSM_tb.sv` — testbench

## How to Simulate (ModelSim/Questa)
From the repo root:

```tcl
vlib work
vlog -sv thunderbirdFSM.sv thunderbirdFSM_tb.sv
vsim work.thunderbirdFSM_tb
add wave -r *
run -all
```

## Test Bench Coverage
- Left Sequence
- Right Sequence
- Hazard from IDLE
- Hazard interrupt during sequence
- LEFT + RIGHT simultaneous from IDLE
- Reset Behavior

## Note
Reset is active-high asynchronous

