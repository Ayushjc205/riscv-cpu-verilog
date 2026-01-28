# Single-Cycle RISC-V Processor in Verilog

This project implements a simple **single-cycle RV32I RISC-V processor** using Verilog HDL. The design is intended for learning and demonstration of basic CPU microarchitecture and datapath/control design.

The processor executes one instruction per clock cycle and is simulated using **Xilinx Vivado**.
---
Features
- Single-cycle RISC-V (RV32I, partial)
- Modular Verilog design
- Instruction fetch, decode, execute, memory access, and write-back in one cycle
- Register file, ALU, control unit, immediate generator, and memories
- Simple memory-mapped I/O
- Performance counter for debugging
- Synthesizable design with testbench
---

Modules

- `CPU.v` – Top-level processor
- `PC.v` – Program counter
- `InstructionMemory.v` – Instruction storage
- `RegisterFile.v` – Register file
- `ALU.v` – Arithmetic Logic Unit
- `ControlUnit.v` – Control and decode logic
- `ImmGen.v` – Immediate generator
- `DataMemory.v` – Data memory for load/store
- `SimpleIO.v` – Memory-mapped I/O
- `PerformanceCounter.v` – Cycle/instruction counter

Tools

- Verilog HDL  
- Xilinx Vivado


