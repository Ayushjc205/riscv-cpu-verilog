module InstructionMemory(
    input [31:0] addr,
    output [31:0] instruction
);

    reg  [31:0] mem [0:127];
    
    initial begin
        
        // Comprehensive test program with ALL RV32I instructions
        
        // Basic arithmetic & logical
        mem[0]  = 32'h00500093; // addi x1, x0, 5     (x1 = 5)
        mem[1]  = 32'h00300113; // addi x2, x0, 3     (x2 = 3)
        mem[2]  = 32'h002081B3; // add  x3, x1, x2    (x3 = 8)
        mem[3]  = 32'h40208233; // sub  x4, x1, x2    (x4 = 2)
        mem[4]  = 32'h0020A2B3; // slt  x5, x1, x2    (x5 = 0)
        mem[5]  = 32'h0020F333; // and  x6, x1, x2    (x6 = 1)
        mem[6]  = 32'h0020E3B3; // or   x7, x1, x2    (x7 = 7)
        mem[7]  = 32'h0020C433; // xor  x8, x1, x2    (x8 = 6)
        
        // Shifts
        mem[8]  = 32'h00209493; // slli x9, x1, 2     (x9 = 20)
        mem[9]  = 32'h0010D513; // srli x10, x1, 1    (x10 = 2)
        mem[10] = 32'hFFF00593; // addi x11, x0, -1   (x11 = -1)
        mem[11] = 32'h4015D613; // srai x12, x11, 1   (x12 = -1, arith shift)
        
        // Upper immediate instructions
        mem[12] = 32'h123456B7; // lui  x13, 0x12345  (x13 = 0x12345000)
        mem[13] = 32'h00000717; // auipc x14, 0       (x14 = PC = 52)
        
        // Memory operations - Word
        mem[14] = 32'h00412223; // sw   x4, 4(x2)     (mem[7] = 2)
        mem[15] = 32'h00412783; // lw   x15, 4(x2)    (x15 = 2)
        
        // Memory operations - Byte
        mem[16] = 32'h00410823; // sb   x4, 16(x2)    (mem[19] byte = 2)
        mem[17] = 32'h01010803; // lb   x16, 16(x2)   (x16 = 2, sign-ext)
        mem[18] = 32'h01014883; // lbu  x17, 16(x2)   (x17 = 2, zero-ext)
        
        // Memory operations - Halfword  
        mem[19] = 32'hFFE00913; // addi x18, x0, -2   (x18 = -2)
        mem[20] = 32'h01211923; // sh   x18, 18(x2)   (mem[21] half = -2)
        mem[21] = 32'h01211983; // lh   x19, 18(x2)   (x19 = -2, sign-ext)
        mem[22] = 32'h01215A03; // lhu  x20, 18(x2)   (x20 = 0xFFFE, zero-ext)
        
        // Branch instructions
        mem[23] = 32'h00208863; // beq  x1, x2, 16    (not taken)
        mem[24] = 32'h00209463; // bne  x1, x2, 8     (taken, skip next)
        mem[25] = 32'h00000013; // nop (skipped)
        mem[26] = 32'h00114A63; // blt  x2, x1, 20    (taken, 3 < 5)
        mem[27] = 32'h00000013; // nop (skipped)
        mem[28] = 32'h00000013; // nop (skipped)
        mem[29] = 32'h00000013; // nop (skipped)
        mem[30] = 32'h00115463; // bge  x2, x1, 8     (not taken)
        mem[31] = 32'h00A00A93; // addi x21, x0, 10   (x21 = 10)
        
        // Jump instructions
        mem[32] = 32'h008000EF; // jal  x1, 8         (x1 = PC+4=132, jump to 136)
        mem[33] = 32'h00000013; // nop (skipped)
        mem[34] = 32'h00C00B13; // addi x22, x0, 12   (x22 = 12, at PC=136)
        mem[35] = 32'h00008067; // jalr x0, x1, 0     (jump to x1=132, return)
        mem[36] = 32'h00D00B93; // addi x23, x0, 13   (x23 = 13, back at 140)
        
        // System calls
        mem[37] = 32'h00000073; // ecall              (environment call)
        mem[38] = 32'h00100073; // ebreak             (breakpoint)
        
        // End program
        mem[39] = 32'h00000013; // nop
        mem[40] = 32'h00000013; // nop
        
     end
     
   assign instruction = mem[addr[31:2]];


endmodule  