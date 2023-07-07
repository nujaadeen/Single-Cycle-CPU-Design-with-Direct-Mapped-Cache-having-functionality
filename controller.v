module controller(
  input              [6:0]      opcode,
  output      reg               mem_to_reg,
  output      reg               mem_write,
  output      reg               mem_read,
  output      reg               alu_src,
  output      reg    [2:0]      alu_op,
  output      reg               reg_write,
  output      reg               branch
);

  localparam      R_TYPE       = 5'b01100;
  localparam      I_TYPE_L     = 5'b00000;
  localparam      I_TYPE_A     = 5'b00100;
  localparam      S_TYPE       = 5'b01000;
  localparam      SB_TYPE      = 5'b11000;

  always @(*) begin
    case(opcode[6:2])
      R_TYPE: begin
        mem_to_reg =  1'b0;
        mem_write  =  1'b0;
        mem_read   =  1'b0;
        alu_src    =  1'b0;
        alu_op     =  3'b000;
        reg_write  =  1'b1;
        branch     =  1'b0;
      end 
      I_TYPE_L: begin
        mem_to_reg =  1'b1;
        mem_write  =  1'b0;
        mem_read   =  1'b1;
        alu_src    =  1'b1;
        alu_op     =  3'b100;
        reg_write  =  1'b1;
        branch     =  1'b0;
      end
      I_TYPE_A: begin
        mem_to_reg =  1'b0;
        mem_write  =  1'b0;
        mem_read   =  1'b0;
        alu_src    =  1'b1;
        alu_op     =  3'b001;
        reg_write  =  1'b1;
        branch     =  1'b0;
      end
      S_TYPE: begin
        mem_to_reg =  1'b0;
        mem_write  =  1'b1;
        mem_read   =  1'b0;
        alu_src    =  1'b1;
        alu_op     =  3'b010;
        reg_write  =  1'b0;
        branch     =  1'b0;
      end
      SB_TYPE: begin
        mem_to_reg =  1'b0;
        mem_write  =  1'b0;
        mem_read   =  1'b0;
        alu_src    =  1'b0;
        alu_op     =  3'b011;
        reg_write  =  1'b0;
        branch     =  1'b1;
      end
      default: begin
        mem_to_reg =  1'b0;
        mem_write  =  1'b0;
        mem_read   =  1'b0;
        alu_src    =  1'b0;
        alu_op     =  3'b000;
        reg_write  =  1'b0;
        branch     =  1'b0;
      end
    endcase
  end
endmodule