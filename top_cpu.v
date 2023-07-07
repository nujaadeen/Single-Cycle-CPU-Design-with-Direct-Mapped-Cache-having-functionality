module top_cpu#(
  parameter ADDR_WIDTH       = 32,
  parameter DATA_WIDTH       = 32
)(
  input       clk,
  input       rst,
  input       mem_ready
);
  // program counter wires
  wire [ADDR_WIDTH-1:0] next_address;
  wire [ADDR_WIDTH-1:0] pc;
  wire [ADDR_WIDTH-1:0] next_pc;
  wire                  out_ready;

  // branch wires
  wire                  en_branch;
  wire [ADDR_WIDTH-1:0] branch_address;

  // immediate wire
  wire [DATA_WIDTH-1:0] immediate;
  
  // instruc wire
  wire [DATA_WIDTH-1:0] instruction;

  // alu wires
  wire [3:0]            flag; 
  wire [3:0]            alu_operation;
  wire [DATA_WIDTH-1:0] alu_operand2;
  wire [DATA_WIDTH-1:0] alu_result;

  // control signal wires
  wire                  mem_to_reg;
  wire                  mem_write;
  wire                  mem_read;
  wire                  alu_src;             
  wire [2:0]            alu_op;        
  wire                  reg_write;
  wire                  branch;

  // register array wires
  wire [DATA_WIDTH-1:0] read_data1;
  wire [DATA_WIDTH-1:0] read_data2;
  wire [DATA_WIDTH-1:0] WriteData;
  wire [DATA_WIDTH-1:0] StoreData;
  wire [DATA_WIDTH-1:0] write_data;

  // memory wires
  wire [DATA_WIDTH-1:0] mem_read_data;
  wire [DATA_WIDTH-1:0] mem_read_data_width;
  wire [DATA_WIDTH-1:0] write_data_width;

  

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  // Next PC = PC + 4
  adder pc_adder(
    .operand1         (pc), 
    .operand2         (32'd4), 
    .out_data         (next_address)
    );

  // instruction memory instant
  instruc_mem instruc_mem(
    .addr             (pc), 
    .dout             (instruction)
    );

  // Immediate generator instant
  immediate_generator immediate_gen(
    .instruction      (instruction), 
    .immediate        (immediate)
    );

  // Control Unit instant
  controller controller(
    .opcode           (instruction[6:0]), 
    .mem_to_reg       (mem_to_reg), 
    .mem_write        (mem_write), 
    .mem_read         (mem_read), 
    .alu_src          (alu_src), 
    .alu_op           (alu_op), 
    .reg_write        (reg_write), 
    .branch           (branch)
  );

  // ALU control instant
  alu_control alu_control(
    .alu_op           (alu_op), 
    .func             ({instruction[30], instruction[14:12]}), 
    .alu_operation    (alu_operation)
  );
  
  // ALU operand 2 select mux instant
  mux alu_mux(
    .input1           (read_data2), 
    .input2           (immediate), 
    .sel              (alu_src), 
    .out_data         (alu_operand2)
    );

  // ALU instant
  alu alu(
    .alu_opr          (alu_operation),
    .operand1         (read_data1), 
    .operand2         (alu_operand2), 
    .result           (alu_result), 
    .flag             (flag)
  );

   // Register load select mux instant
  mux reg_mux(
    .input1           (alu_result), 
    .input2           (mem_read_data_width), 
    .sel              (mem_to_reg), 
    .out_data         (write_data)
    );
  // Register array instant
  register_array register_array(
    .clk              (clk), 
    .rst              (rst),
    .rs1_sel          (instruction[19:15]), 
    .rs2_sel          (instruction[24:20]),
    .wr_data          (write_data), 
    .rd_sel           (instruction[11:7]), 
    .wr_en            (reg_write), 
    .rs1_data         (read_data1), 
    .rs2_data         (read_data2)
  );

  // branch select instant
  branch_sel branch_sel(
    .branch           (branch),
    .flag             (flag),
    .func             (instruction[14:12]),
    .en_branch        (en_branch)
  ); 

  // Branch PC = PC + Immediate
  adder branch_adder(
    .operand1         (pc), 
    .operand2         (immediate), 
    .out_data         (branch_address)
    );

  // next pc select mux instant
  mux pc_mux(
    .input1           (next_address), 
    .input2           (branch_address), 
    .sel              (en_branch), 
    .out_data         (next_pc)
    );

  // PC instant
  program_counter PC(
    .clk              (clk), 
    .rst              (rst),
    .mem_out_ready    (out_ready), 
    .next_pc          (next_pc), 
    .pc               (pc)
  );

  // Width select instant for Data Memory Write Data
  width_sel mem_store_width_sel(
    .func             (instruction[14:12]), 
    .inp_word         (read_data2), 
    .out_word         (write_data_width)
  );

  // cache control module instant 
  cache_control cache_control(
    .clk              (clk), 
    .rst              (rst), 
    .wr_mem           (mem_write),
    .rd_mem           (mem_read),
    .mem_ready        (mem_ready), 
    .addr             (alu_result), 
    .wr_data          (write_data_width), 
    .out_data         (mem_read_data),
    .out_ready        (out_ready)
  );
    
  // Width select instant for Register File Write Data
  width_sel mem_load_width_sel(
    .func             (instruction[14:12]), 
    .inp_word         (mem_read_data), 
    .out_word         (mem_read_data_width)
  );
endmodule