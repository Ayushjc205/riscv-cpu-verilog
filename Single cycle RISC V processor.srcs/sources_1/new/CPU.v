module CPU(
    input clk, rst,
    input [7:0] switches,
    input step_mode,
    input step_trigger,
    output [7:0] leds,
    output [31:0] cycle_count,
    output [31:0] instr_count,
    output [31:0] current_pc,
    output halt_flag
);
    // Wires
    wire [31:0] pc, pc_next, pc_plus4, pc_branch, pc_jump;
    wire [31:0] instr;
    wire [31:0] rd1, rd2, imm, alu_a, alu_b, alu_result, mem_data, write_data;
    wire [3:0] alu_ctrl;
    wire [1:0] branch_type, mem_size;
    wire reg_write, mem_write, mem_read, alu_src, mem_to_reg;
    wire branch, jump, jalr, mem_sign_ext, auipc_sel;
    wire ecall, ebreak, halt;
    wire zero, less_than, branch_taken;
    
    // Halt on ECALL/EBREAK
    assign halt = ecall | ebreak;
    assign halt_flag = halt;
    
    // Branch logic
    reg branch_condition;
    always @(*) begin
        case(branch_type)
            2'b00: branch_condition = zero;         // BEQ
            2'b01: branch_condition = ~zero;        // BNE
            2'b10: branch_condition = less_than;    // BLT/BLTU
            2'b11: branch_condition = ~less_than;   // BGE/BGEU
        endcase
    end
    
    assign branch_taken = branch & branch_condition;
    
    // PC logic
    assign pc_plus4 = pc + 4;
    assign pc_branch = pc + imm;
    assign pc_jump = jalr ? (alu_result & 32'hFFFFFFFE) : (pc + imm);
    assign pc_next = (jump | jalr) ? pc_jump : (branch_taken ? pc_branch : pc_plus4);
    assign current_pc = pc;
    
    // Instantiate modules
    PC pc_reg(
        .clk(clk), .rst(rst), 
        .step_mode(step_mode), .step_trigger(step_trigger),
        .halt(halt),
        .pc_next(pc_next), .pc(pc)
    );
    
    InstructionMemory imem(.addr(pc), .instruction(instr));
    
    ControlUnit ctrl(
        .opcode(instr[6:0]), .funct3(instr[14:12]), .funct7(instr[31:25]),
        .imm12(instr[31:20]),
        .reg_write(reg_write), .mem_write(mem_write), .mem_read(mem_read),
        .alu_src(alu_src), .mem_to_reg(mem_to_reg), 
        .branch(branch), .jump(jump), .jalr(jalr),
        .branch_type(branch_type), .mem_size(mem_size),
        .mem_sign_ext(mem_sign_ext), .auipc_sel(auipc_sel),
        .ecall(ecall), .ebreak(ebreak),
        .alu_ctrl(alu_ctrl)
    );
    
    RegisterFile regfile(
        .clk(clk), .we(reg_write),
        .ra1(instr[19:15]), .ra2(instr[24:20]), .wa(instr[11:7]),
        .wd(write_data), .rd1(rd1), .rd2(rd2)
    );
    
    ImmGen immgen(.instr(instr), .imm(imm));
    
    // ALU input selection
    assign alu_a = auipc_sel ? pc : rd1;
    assign alu_b = alu_src ? imm : rd2;
    
    ALU alu(
        .a(alu_a), .b(alu_b), .alu_ctrl(alu_ctrl), 
        .result(alu_result), .zero(zero), .less_than(less_than)
    );
    
    DataMemory dmem(
        .clk(clk), .we(mem_write), .re(mem_read),
        .size(mem_size), .sign_ext(mem_sign_ext),
        .addr(alu_result), .wd(rd2), .rd(mem_data)
    );
    
    // Writeback logic
    assign write_data = (jump | jalr) ? pc_plus4 : (mem_to_reg ? mem_data : alu_result);
    
    // Performance Counter
    PerformanceCounter perf_counter(
        .clk(clk), .rst(rst), 
        .enable(!halt && (!step_mode || step_trigger)),
        .cycle_count(cycle_count), 
        .instr_count(instr_count)
    );
    
    // Simple I/O
    SimpleIO io_module(
        .clk(clk), .rst(rst),
        .switches(switches),
        .cpu_data(rd1),
        .write_enable(mem_write && (alu_result == 32'hFFFF0000)),
        .leds(leds)
    );
    
    // Monitor
    always @(posedge clk) begin
        if(!rst && (!step_mode || step_trigger) && !halt) begin
            if(ecall) $display(">>> ECALL at PC=%0d", pc);
            if(ebreak) $display(">>> EBREAK at PC=%0d", pc);
        end
    end
endmodule