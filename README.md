# 5-Stage Pipelined MIPS Processor Core

## Overview
This repository contains the register-transfer level (RTL) implementation and microarchitectural specification of a fully functional 32-bit pipelined MIPS processing core. Designed in SystemVerilog, the architecture resolves performance bottlenecks inherent in single-cycle datapathes by introducing temporal parallelism across a 5-stage pipeline. The design resolves structural, data, and control hazards dynamically, maintaining high-throughput steady-state instruction execution.

## Toolchain & Synthesis
* **Hardware Description Language:** SystemVerilog
* **Simulation & Verification:** QuestaSim / ModelSim (behavioral and timing analysis)
* **Synthesis & Implementation:** Intel Quartus Prime (RTL mapping, place-and-route, Static Timing Analysis)

## Microarchitectural Pipeline Stages
The processor pipeline is partitioned into five isolated processing steps separated by clock-edge triggered synchronization boundary registers:

* **Instruction Fetch (IF):** Queries memory and computes the sequential PC+4 address.
* **Instruction Decode (ID):** Extracts opcodes, fetches operand values from the Multi-Port Register File, and handles 16-bit immediate sign-extension.
* **Execute (EX):** Evaluates arithmetic logic, shift operations, and computes effective memory addresses via the ALU.
* **Memory (MEM):** Interfaces with synchronous byte-addressable data storage for load and store profiles.
* **Write Back (WB):** Commits computed or retrieved data back to the target index in the Register File.

## Hazard Mitigation Subsystem
This core achieves continuous execution without relying entirely on compiler-inserted hardware stalls. It employs an interconnected top-level hazard control subsystem:

* **Data Hazards & Forwarding Unit:** Eliminates standard pipeline stalls by bypassing operands directly from the EX/MEM and MEM/WB boundary registers to the ALU inputs. This logic includes a double-hazard override protocol to preserve microarchitectural state mapping.
* **Load-Use Dependencies:** A dedicated Hazard Detection Unit identifies immediate load-use conflicts and injects a single-cycle hardware bubble. This is achieved by freezing the PC and IF/ID registers while flushing the ID/EX control lines to zero.
* **Control Hazards & Early Branching:** Mitigates branch misprediction penalties by evaluating branch targets and equality conditions early in the ID stage. Invalidated instructions in the IF stage are flushed dynamically.

## Verification Firmware
The datapath integrity was validated against a custom MIPS assembly firmware sequence. This cross-compiled array indexing loop purposefully triggers heavy computational data dependencies and immediate branch hazard penalties, successfully proving the structural robustness and hazard recovery of the pipeline.
