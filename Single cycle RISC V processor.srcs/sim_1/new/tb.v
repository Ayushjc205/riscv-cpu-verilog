module tb;
    reg clk, rst;
    reg [7:0] switches;
    reg step_mode, step_trigger;
    wire [7:0] leds;
    wire [31:0] cycle_count, instr_count, current_pc;
    wire halt_flag;
    
    CPU cpu(
        .clk(clk), .rst(rst),
        .switches(switches),
        .step_mode(step_mode),
        .step_trigger(step_trigger),
        .leds(leds),
        .cycle_count(cycle_count),
        .instr_count(instr_count),
        .current_pc(current_pc),
        .halt_flag(halt_flag)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
        
        $display("\n========== Complete RV32I CPU Test ==========\n");
        
        rst = 1; step_mode = 0; step_trigger = 0; switches = 8'b10101010;
        #10 rst = 0;
        
        #500;
        
        $display("\n========== Performance Summary ==========");
        $display("Total Cycles:       %0d", cycle_count);
        $display("Instructions Exec:  %0d", instr_count);
        $display("CPI:                %.2f", $itor(cycle_count)/$itor(instr_count));
        $display("Halted:             %s", halt_flag ? "YES" : "NO");
        
        $display("\n========== Register Dump ==========");
        $display("x1  = %0d (x1 = JAL return)", cpu.regfile.regs[1]);
        $display("x3  = %0d (ADD)", cpu.regfile.regs[3]);
        $display("x4  = %0d (SUB)", cpu.regfile.regs[4]);
        $display("x5  = %0d (SLT)", cpu.regfile.regs[5]);
        $display("x8  = %0d (XOR)", cpu.regfile.regs[8]);
        $display("x9  = %0d (SLLI)", cpu.regfile.regs[9]);
        $display("x12 = %0d (SRAI)", cpu.regfile.regs[12]);
        $display("x13 = 0x%h (LUI)", cpu.regfile.regs[13]);
        $display("x14 = %0d (AUIPC)", cpu.regfile.regs[14]);
        $display("x15 = %0d (LW)", cpu.regfile.regs[15]);
        $display("x16 = %0d (LB)", cpu.regfile.regs[16]);
        $display("x17 = %0d (LBU)", cpu.regfile.regs[17]);
        $display("x19 = %0d (LH)", cpu.regfile.regs[19]);
        $display("x20 = 0x%h (LHU)", cpu.regfile.regs[20]);
        $display("x21 = %0d (after BLT)", cpu.regfile.regs[21]);
        $display("x22 = %0d (after JAL)", cpu.regfile.regs[22]);
        $display("x23 = %0d (after JALR)", cpu.regfile.regs[23]);
        
        $finish;
    end
endmodule