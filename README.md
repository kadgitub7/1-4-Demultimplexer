## 1:4 Demultiplexer | Verilog

A **Verilog implementation of a 1:4 demultiplexer (DEMUX)**, designed and simulated in **Xilinx Vivado**.  
This document explains:

- **What a demultiplexer is**
- **How a 1→4 DEMUX with enable works**
- The **truth table**, **Boolean equations**, and **signal assignments**
- How to **run the design and testbench in Vivado**

The project includes the **RTL design**, **testbench**, **simulation waveform**, and **console-style output** verifying correct behavior.

---

## Table of Contents

- [What Is a Demultiplexer?](#what-is-a-demultiplexer)
- [1:4 Demultiplexer Basics](#14-demultiplexer-basics)
- [Truth Table and Boolean Equations](#truth-table-and-boolean-equations)
- [Circuit Description](#circuit-description)
- [Waveform Diagram](#waveform-diagram)
- [Testbench Output](#testbench-output)
- [Running the Project in Vivado](#running-the-project-in-vivado)
- [Project Files](#project-files)

---

## What Is a Demultiplexer?

A **demultiplexer (DEMUX)** is a combinational logic circuit that routes **a single input** to **one of many outputs** based on the value of **select lines**.  
It is conceptually the **reverse of a multiplexer**:

- A **multiplexer (MUX)** selects **one of many inputs** and forwards it to a **single output**.  
- A **demultiplexer (DEMUX)** takes **one input** and sends it to **exactly one of several outputs** at a time.

DEMUXes are commonly used in:

- **Data routing** and **signal distribution**
- **Memory addressing** and **chip-select logic**
- **Time-division multiplexing/demultiplexing**

---

## 1:4 Demultiplexer Basics

This project implements a **1:4 demultiplexer with enable**. The signals are:

- **I** – data input  
- **E** – enable input  
- **S₁, S₀** – select lines (2 bits, since \(2^2 = 4\))  
- **Y₀, Y₁, Y₂, Y₃** – outputs

Behavior:

- When **E = 0**, the DEMUX is **disabled** and all outputs are **0**, regardless of `I`, `S₁`, or `S₀`.
- When **E = 1**, the DEMUX is **enabled** and the single input `I` is routed to **exactly one** of the four outputs:
  - If **S₁S₀ = 00**, then `Y₀ = I` and `Y₁ = Y₂ = Y₃ = 0`.
  - If **S₁S₀ = 01**, then `Y₁ = I` and `Y₀ = Y₂ = Y₃ = 0`.
  - If **S₁S₀ = 10**, then `Y₂ = I` and `Y₀ = Y₁ = Y₃ = 0`.
  - If **S₁S₀ = 11**, then `Y₃ = I` and `Y₀ = Y₁ = Y₂ = 0`.

---

## Truth Table and Boolean Equations

Using inputs **E**, **S₁**, **S₀**, and **I**, and outputs **Y₀**, **Y₁**, **Y₂**, **Y₃**, the complete truth table is:

| E | S₁ | S₀ | I | Y₀ | Y₁ | Y₂ | Y₃ |
|---|----|----|---|----|----|----|----|
| 0 |  X |  X | 0 | 0  | 0  | 0  | 0  |
| 0 |  X |  X | 1 | 0  | 0  | 0  | 0  |
| 1 |  0 |  0 | 0 | 0  | 0  | 0  | 0  |
| 1 |  0 |  0 | 1 | 1  | 0  | 0  | 0  |
| 1 |  0 |  1 | 0 | 0  | 0  | 0  | 0  |
| 1 |  0 |  1 | 1 | 0  | 1  | 0  | 0  |
| 1 |  1 |  0 | 0 | 0  | 0  | 0  | 0  |
| 1 |  1 |  0 | 1 | 0  | 0  | 1  | 0  |
| 1 |  1 |  1 | 0 | 0  | 0  | 0  | 0  |
| 1 |  1 |  1 | 1 | 0  | 0  | 0  | 1  |

From this table, the Boolean equations for the outputs are:

\[
Y_0 = E \cdot I \cdot \overline{S_1} \cdot \overline{S_0}
\]
\[
Y_1 = E \cdot I \cdot \overline{S_1} \cdot S_0
\]
\[
Y_2 = E \cdot I \cdot S_1 \cdot \overline{S_0}
\]
\[
Y_3 = E \cdot I \cdot S_1 \cdot S_0
\]

In more programming-style notation:

```text
Y0 = E & I & ~S1 & ~S0
Y1 = E & I & ~S1 &  S0
Y2 = E & I &  S1 & ~S0
Y3 = E & I &  S1 &  S0
```

These equations capture the key 1→4 DEMUX behavior:

- The **enable** `E` must be 1 for any output to be active.
- Exactly **one** of `Y0`, `Y1`, `Y2`, or `Y3` can be equal to `I` at a time, based on the select lines `S1` and `S0`.

---

## Circuit Description

The 1:4 DEMUX circuit uses basic logic gates to realize the Boolean expressions above:

- **AND gate** for `Y0`:
  - Inputs: `E`, `I`, `~S1`, `~S0`
  - Output: `Y0`
- **AND gate** for `Y1`:
  - Inputs: `E`, `I`, `~S1`, `S0`
  - Output: `Y1`
- **AND gate** for `Y2`:
  - Inputs: `E`, `I`, `S1`, `~S0`
  - Output: `Y2`
- **AND gate** for `Y3`:
  - Inputs: `E`, `I`, `S1`, `S0`
  - Output: `Y3`
- **NOT gates** to generate `~S1` and `~S0` (the complements of the select lines)

Conceptual view (textual logic diagram):

```text
               +---- AND ---- Y0
      E -------| 
      I -------| 
     ~S1 ------|
     ~S0 ------+

               +---- AND ---- Y1
      E -------| 
      I -------| 
     ~S1 ------|
      S0 ------+

               +---- AND ---- Y2
      E -------| 
      I -------| 
      S1 ------|
     ~S0 ------+

               +---- AND ---- Y3
      E -------| 
      I -------| 
      S1 ------|
      S0 ------+

~S1 and ~S0 are generated using inverters from S1 and S0.
```

In the Verilog implementation, these relationships are encoded directly using combinational logic assignments.

---

![1:4 Demultiplexer Circuit](imageAssets/demux14Circuit.png)

## Waveform Diagram

The behavioral simulation verifies operation by:

1. Keeping **E = 1** and **I = 1** during the key test cases.  
2. Sweeping through all **four select-line combinations** `(S1, S0) = 00, 01, 10, 11`.  
3. Observing that exactly one of `Y0–Y3` goes high in each case, matching the truth table.

Signals observed:

```text
Inputs :
  E, S1, S0, I
Outputs:
  Y0, Y1, Y2, Y3
```

---

## Testbench Output

A conceptual console-style view of the testbench results (matching the design’s intended behavior) is:

```text
E S1 S0 I | Y0 Y1 Y2 Y3
------------------------
1 0 0 1 | 1 0 0 0
1 0 1 1 | 0 1 0 0
1 1 0 1 | 0 0 1 0
1 1 1 1 | 0 0 0 1
```

These results confirm that **Y0–Y3** follow the expected 1:4 demultiplexer behavior with enable.

---

## Running the Project in Vivado

### 1. Launch Vivado

Open **Xilinx Vivado**.

### 2. Create a New RTL Project

- **Create Project**  
- Choose **RTL Project**  
- Enable **Do not specify sources at this time** (optional) or add them directly.

### 3. Add Design and Simulation Files

Design Sources (RTL):

```text
oneFourDemux.v
```

Simulation Sources (Testbench):

```text
oneFourDemux_tb.v
```

Set `oneFourDemux_tb.v` as the **simulation top module**.

### 4. Run Behavioral Simulation

In Vivado:

```text
Flow -> Run Simulation -> Run Behavioral Simulation
```

Observe the signals:

```text
Inputs : E, S1, S0, I
Outputs: Y0, Y1, Y2, Y3
```

Verify from the waveform that the outputs follow the **truth table** and match the console-style output listed above.

---

## Project Files

| File                | Description                                                |
|---------------------|------------------------------------------------------------|
| `oneFourDemux.v`    | RTL implementation of the 1:4 demultiplexer with enable   |
| `oneFourDemux_tb.v` | Testbench that stimulates the DEMUX and records waveforms |

---

**Author**: **Kadhir Ponnambalam**
