# 5-Stage Pipelined MIPS Processor Core

## Overview
[cite_start]This repository contains the register-transfer level (RTL) implementation and microarchitectural specification of a fully functional 32-bit pipelined MIPS processing core[cite: 26, 998]. [cite_start]Designed in SystemVerilog, the architecture resolves performance bottlenecks inherent in single-cycle datapathes by introducing temporal parallelism across a 5-stage pipeline[cite: 26, 30]. [cite_start]The design resolves structural, data, and control hazards dynamically, maintaining high-throughput steady-state instruction execution[cite: 35, 36, 1181].

## Toolchain & Synthesis
* [cite_start]**Hardware Description Language:** SystemVerilog[cite: 26].
* [cite_start]**Simulation & Verification:** QuestaSim / ModelSim (behavioral and timing analysis)[cite: 27, 1177].
* [cite_start]**Synthesis & Implementation:** Intel Quartus Prime (RTL mapping, place-and-route, Static Timing Analysis)[cite: 27].

## Microarchitectural Pipeline Stages
[cite_start]The processor pipeline is partitioned into five isolated processing steps separated by clock-edge triggered synchronization boundary registers[cite: 42, 80]:

* [cite_start]**Instruction Fetch (IF):** Queries memory and computes the sequential $PC+4$ address[cite: 47, 48].
* [cite_start]**Instruction Decode (ID):** Extracts opcodes, fetches operand values from the Multi-Port Register File, and handles 16-bit immediate sign-extension[cite: 49, 50, 51].
* [cite_start]**Execute (EX):** Evaluates arithmetic logic, shift operations, and computes effective memory addresses via the ALU[cite: 52, 53].
* [cite_start]**Memory (MEM):** Interfaces with synchronous byte-addressable data storage for load and store profiles[cite: 54, 509].
* [cite_start]**Write Back (WB):** Commits computed or retrieved data back to the target index in the Register File[cite: 56].

## Hazard Mitigation Subsystem
This core achieves continuous execution without relying entirely on compiler-inserted hardware stalls. [cite_start]It employs an interconnected top-level hazard control subsystem[cite: 90, 668]:

* [cite_start]**Data Hazards & Forwarding Unit:** Eliminates standard pipeline stalls by bypassing operands directly from the EX/MEM and MEM/WB boundary registers to the ALU inputs[cite: 83, 84, 93]. [cite_start]This logic includes a double-hazard override protocol to preserve microarchitectural state mapping[cite: 96].
* [cite_start]**Load-Use Dependencies:** A dedicated Hazard Detection Unit identifies immediate load-use conflicts and injects a single-cycle hardware bubble[cite: 187, 189]. [cite_start]This is achieved by freezing the PC and IF/ID registers while flushing the ID/EX control lines to zero[cite: 188].
* [cite_start]**Control Hazards & Early Branching:** Mitigates branch misprediction penalties by evaluating branch targets and equality conditions early in the ID stage[cite: 36, 241]. [cite_start]Invalidated instructions in the IF stage are flushed dynamically[cite: 242].

## Verification Firmware
[cite_start]The datapath integrity was validated against a custom MIPS assembly firmware sequence[cite: 1084]. [cite_start]This cross-compiled array indexing loop purposefully triggers heavy computational data dependencies and immediate branch hazard penalties, successfully proving the structural robustness and hazard recovery of the pipeline[cite: 1084, 1177].
