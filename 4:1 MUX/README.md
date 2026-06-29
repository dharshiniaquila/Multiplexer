# 4:1 Multiplexer (MUX) — Verilog HDL Implementation on Artix-7 FPGA

## Project Overview

This project implements a **4-to-1 Multiplexer** using Verilog HDL, simulated and synthesized on the **Xilinx Artix-7 FPGA (xc7a35tcpg236-1)** using **Xilinx Vivado Design Suite**.

A 4:1 MUX is a combinational logic circuit that selects one of four input data lines and routes it to a single output, based on a 2-bit select signal. It is a key building block in data routing, arithmetic units, and function generation on FPGAs.

---

## Truth Table

| S1 | S0 | Output Y |
|:--:|:--:|:--------:|
| 0  | 0  | I0       |
| 0  | 1  | I1       |
| 1  | 0  | I2       |
| 1  | 1  | I3       |

---

## Boolean Expression

```
Y = (S1' · S0' · I0) + (S1' · S0 · I1) + (S1 · S0' · I2) + (S1 · S0 · I3)
```

Or equivalently using a `case` statement on the 2-bit select `{S1, S0}`:

```
case({S1, S0}):
  2'b00 → Y = I0
  2'b01 → Y = I1
  2'b10 → Y = I2
  2'b11 → Y = I3
```

---

## Project Files

```
4_1mux/
├── 4_1mux.srcs/
│   ├── sources_1/new/
│   │   └── MUX4_1.v          # Top-level design (RTL source)
│   └── sim_1/new/
│       └── tb_MUX4_1.v       # Testbench
```

---

## RTL Source: `MUX4_1.v`

```verilog
`timescale 1ns / 1ps

module MUX4_1(
    input I0, I1, I2, I3,
    input S0, S1,
    output reg Y
);

    always @(*) begin
        case ({S1, S0})
            2'b00: Y = I0;
            2'b01: Y = I1;
            2'b10: Y = I2;
            2'b11: Y = I3;
        endcase
    end

endmodule
```

### Port Description

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `I0` | Input     | 1-bit | Data Input 0 (selected when S1=0, S0=0) |
| `I1` | Input     | 1-bit | Data Input 1 (selected when S1=0, S0=1) |
| `I2` | Input     | 1-bit | Data Input 2 (selected when S1=1, S0=0) |
| `I3` | Input     | 1-bit | Data Input 3 (selected when S1=1, S0=1) |
| `S0` | Input     | 1-bit | Select line bit 0 (LSB) |
| `S1` | Input     | 1-bit | Select line bit 1 (MSB) |
| `Y`  | Output    | 1-bit | MUX output (declared as `reg` for `always` block) |

> **Note:** `Y` is declared as `output reg` because it is driven inside an `always` block. Vivado correctly infers this as combinational logic (no flip-flop) since the sensitivity list is `@(*)`.

---

## Testbench: `tb_MUX4_1.v`

```verilog
`timescale 1ns / 1ps

module tb_MUX4_1;
    reg I0, I1, I2, I3, S0, S1;
    wire Y;

    MUX4_1 uut (I0, I1, I2, I3, S0, S1, Y);

    initial begin
        I0=1; I1=0; I2=1; I3=0;

        S0=0; S1=0; #10;   // Select I0 → Y = 1
        S0=1; S1=0; #10;   // Select I1 → Y = 0
        S0=0; S1=1; #10;   // Select I2 → Y = 1
        S0=1; S1=1; #10;   // Select I3 → Y = 0

        $finish;
    end
endmodule
```

### Test Cases Explained

| Time (ns) | S1 | S0 | Selected Input | Input Value | Expected Y |
|-----------|----|----|----------------|-------------|------------|
| 0 – 10    | 0  | 0  | I0             | 1           | 1          |
| 10 – 20   | 0  | 1  | I1             | 0           | 0          |
| 20 – 30   | 1  | 0  | I2             | 1           | 1          |
| 30 – 40   | 1  | 1  | I3             | 0           | 0          |

Fixed input values for the entire simulation: `I0=1, I1=0, I2=1, I3=0`. Only the select lines `S0` and `S1` cycle through all 4 combinations.

---

## Elaborated Design (RTL Schematic)

The Vivado Elaborated Design view confirms correct RTL inference:

- **1 Cell**: `RTL_MUX` — inferred from the `case` statement in the `always @(*)` block
- **7 I/O Ports**: `I0`, `I1`, `I2`, `I3`, `S0`, `S1` (inputs) and `Y` (output)
- **7 Nets**: Connecting all ports through the MUX cell

### Schematic Observations

| MUX Pin  | Connected To | Active When        |
|----------|--------------|--------------------|
| `I0`     | Port `I0`    | `{S1,S0} = 2'b00`  |
| `I1`     | Port `I1`    | `{S1,S0} = 2'b01`  |
| `I2`     | Port `I2`    | `{S1,S0} = 2'b10`  |
| `I3`     | Port `I3`    | `{S1,S0} = 2'b11`  |
| `S[1:0]` | `{S1, S0}`   | 2-bit select bus   |
| `O`      | Port `Y`     | Output from selected input |

The select lines `S0` and `S1` are concatenated into a 2-bit bus `S[1:0]` before driving the `RTL_MUX` select pin — matching the `{S1, S0}` concatenation used in the `case` statement.

---

## Simulation Results

**Tool:** Vivado Behavioral Simulation (Functional)  
**Sim Time:** 40 ns active window (terminated by `$finish`)

### Waveform Analysis

| Signal | Behavior During Simulation |
|--------|---------------------------|
| `I0`   | Held HIGH (1) throughout |
| `I1`   | Held LOW (0) throughout |
| `I2`   | Held HIGH (1) throughout |
| `I3`   | Held LOW (0) throughout |
| `S0`   | Cycles: 0 → 1 → 0 → 1 (every 10 ns) |
| `S1`   | Cycles: 0 → 0 → 1 → 1 (changes at 20 ns) |
| `Y`    | Follows: 1 → 0 → 1 → 0, correctly mirroring I0, I1, I2, I3 |

The output `Y` correctly tracks the selected input at every time step, validating all four select combinations.

---

## Design Notes

### Why `always @(*)` and `output reg`?

The `always @(*)` sensitivity list makes the block combinational — it re-evaluates whenever **any** input changes. Using `output reg` is required syntax in Verilog when assigning to an output inside an `always` block. Vivado correctly infers this as a **pure combinational MUX**, not a register, because there is no clock edge triggering.

### Why `case` instead of `assign` with ternary?

For a 4:1 MUX, the `case` statement is cleaner and more readable than a nested ternary:
```verilog
// Equivalent but less readable
assign Y = (S1==0 && S0==0) ? I0 :
           (S1==0 && S0==1) ? I1 :
           (S1==1 && S0==0) ? I2 : I3;
```
Both approaches synthesize to the same `RTL_MUX` cell in Vivado.

---

## Tools & Environment

| Item | Details |
|------|---------|
| **HDL Language** | Verilog (IEEE 1364-2005) |
| **EDA Tool** | Xilinx Vivado Design Suite |
| **Target Device** | Artix-7 — `xc7a35tcpg236-1` |
| **Timescale** | `1ns / 1ps` |
| **Simulation Type** | Behavioral (Functional) |
| **Modeling Style** | `always @(*)` with `case` statement |

---

## How to Reproduce

1. **Create a new Vivado project** targeting `xc7a35tcpg236-1`.
2. **Add source file** `MUX4_1.v` under `sources_1/new/`.
3. **Add testbench** `tb_MUX4_1.v` under `sim_1/new/`.
4. **Run Simulation**: Flow Navigator → Simulation → Run Simulation → Run Behavioral Simulation.
5. **View Elaborated Design**: Flow Navigator → RTL Analysis → Open Elaborated Design → Schematic.
6. (Optional) **Run Synthesis** and **Implementation** to generate the bitstream for FPGA deployment.

---

## Key Concepts Demonstrated

- 4:1 MUX design using `always @(*)` and `case` statement in Verilog
- 2-bit select line concatenation using `{S1, S0}` in case expressions
- `output reg` declaration for combinational outputs driven from `always` blocks
- Proper use of `$finish` in testbench to terminate simulation cleanly
- RTL-level schematic analysis in Vivado (1 Cell RTL_MUX, 7 I/O Ports, 7 Nets)
- Behavioral simulation with fixed data inputs and sweeping select lines

---


*Part of a series of Verilog HDL digital logic projects implemented on the Artix-7 FPGA.*
