
# 2:1 Multiplexer (MUX) — Verilog HDL Implementation on Artix-7 FPGA

## Project Overview

This project implements a **2-to-1 Multiplexer** using Verilog HDL, simulated and synthesized on the **Xilinx Artix-7 FPGA (xc7a35tcpg236-1)** using **Xilinx Vivado Design Suite**.

A 2:1 MUX is a fundamental combinational logic circuit that selects one of two input data lines and routes it to a single output, based on the state of a select line.

---

## Truth Table

| Select (`s`) | Input A (`a`) | Input B (`b`) | Output (`y`) |
|:---:|:---:|:---:|:---:|
| 0 | 0 | 0 | 0 (→ a) |
| 0 | 1 | 0 | 1 (→ a) |
| 1 | 0 | 0 | 0 (→ b) |
| 1 | 0 | 1 | 1 (→ b) |

- When `s = 0` → `y = a`
- When `s = 1` → `y = b`

---

## Boolean Expression

```
y = s ? b : a
```

Or equivalently:

```
y = (s' · a) + (s · b)
```

---

## Project Files

```
mux2_1/
├── mux2_1.srcs/
│   ├── sources_1/new/
│   │   └── mux2_1.v          # Top-level design (RTL source)
│   └── sim_1/new/
│       └── tb_mux2_1.v       # Testbench
```

---

## RTL Source: `mux2_1.v`

```verilog
`timescale 1ns / 1ps

module mux2_1(
    input a,
    input b,
    input s,
    output y
);

    assign y = s ? b : a;

endmodule
```

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a`  | Input     | 1-bit | Data Input 0 (selected when s=0) |
| `b`  | Input     | 1-bit | Data Input 1 (selected when s=1) |
| `s`  | Input     | 1-bit | Select line |
| `y`  | Output    | 1-bit | MUX output |

---

## Testbench: `tb_mux2_1.v`

```verilog
`timescale 1ns / 1ps

module tb_mux2_1;
    reg a, b, s;
    wire y;

    mux2_1 uut (a, b, s, y);

    initial begin
        a=0; b=0; s=0; #10;
        a=0; b=1; s=0; #10;

        a=0; b=1; s=1; #10;
        a=1; b=0; s=1; #10;
    end
endmodule
```

### Test Cases Explained

| Time (ns) | `a` | `b` | `s` | Expected `y` | Reason |
|-----------|-----|-----|-----|--------------|--------|
| 0 – 10    | 0   | 0   | 0   | 0            | s=0, selects a=0 |
| 10 – 20   | 0   | 1   | 0   | 0            | s=0, selects a=0 |
| 20 – 30   | 0   | 1   | 1   | 1            | s=1, selects b=1 |
| 30 – 40   | 1   | 0   | 1   | 0            | s=1, selects b=0 |

---

## Elaborated Design (RTL Schematic)

The Vivado Elaborated Design view confirms correct RTL inference:

- **1 Cell**: `RTL_MUX` (inferred from the ternary assign statement)
- **4 I/O Ports**: `a`, `b`, `s` (inputs) and `y` (output)
- **4 Nets**: Connecting all ports through the MUX cell

The schematic shows:
- Input `b` is mapped to `I0` of the MUX (active when `S = 1'b1`)
- Input `a` is mapped to `I1` of the MUX (active when `S = default`)
- Select line `s` drives the `S` pin of `RTL_MUX`
- Output `y` is driven by the `O` pin

---

## Simulation Results

**Tool:** Vivado Behavioral Simulation (Functional)  
**Sim Time:** 1 µs total | Key activity observed in 0–40 ns window

### Waveform Analysis

| Signal | Behavior |
|--------|----------|
| `a`    | Transitions from 0 to 1 during simulation |
| `b`    | Pulses high between ~10–20 ns, then returns low |
| `s`    | Held high from ~20 ns onward |
| `y`    | Reflects correct MUX output at all time steps |

The simulation confirms that the output `y` correctly tracks either `a` or `b` based on the value of `s`, validating the expected truth table behavior.

---

## Tools & Environment

| Item | Details |
|------|---------|
| **HDL Language** | Verilog (IEEE 1364-2005) |
| **EDA Tool** | Xilinx Vivado Design Suite |
| **Target Device** | Artix-7 — `xc7a35tcpg236-1` |
| **Timescale** | `1ns / 1ps` |
| **Simulation Type** | Behavioral (Functional) |

---

## How to Reproduce

1. **Clone or create the project** in Xilinx Vivado.
2. **Add source file** `mux2_1.v` under `sources_1/new/`.
3. **Add testbench** `tb_mux2_1.v` under `sim_1/new/`.
4. **Run Simulation**: Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation.
5. **View Elaborated Design**: Flow Navigator → RTL Analysis → Open Elaborated Design → Schematic.
6. (Optional) **Run Synthesis** and **Implementation** to generate the bitstream for FPGA deployment.

---

## Key Concepts Demonstrated

- Combinational logic design in Verilog using `assign` and the ternary operator
- RTL-level simulation with stimulus-driven testbench
- Proper use of `reg` (for driven signals in testbench) and `wire` (for outputs)
- Vivado project structure, schematic viewer, and waveform analysis
- FPGA targeting on the Artix-7 device family



---

*Part of a series of Verilog HDL digital logic projects implemented on the Artix-7 FPGA.*
