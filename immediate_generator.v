module immediate_generator(
  input           [31:0]    instruction,
  output   reg    [31:0]    immediate   
);


  localparam      I_TYPE_L     = 5'b00000;
  localparam      I_TYPE_A     = 5'b00100;
  localparam      S_TYPE       = 5'b01000;
  localparam      SB_TYPE      = 5'b11000;

  always @(*) begin
    case(instruction[6:2]) 
      I_TYPE_L: begin
        immediate = {{20{instruction[31]}}, instruction[31:20]};
      end
      I_TYPE_A: begin
        immediate = {{20{instruction[31]}}, instruction[31:20]};
      end
      S_TYPE: begin
        immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
      end
      SB_TYPE: begin
        immediate = {{19{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      end
      default: begin
        immediate = 32'b0;
      end
    endcase
  end
endmodule 