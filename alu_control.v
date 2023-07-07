module alu_control(
  input       [2:0] alu_op,
  input       [3:0] func,
  output reg  [3:0] alu_operation
);
  localparam      R_TYPE       = 3'b000;
  localparam      I_TYPE_L     = 3'b100;
  localparam      I_TYPE_A     = 3'b001;
  localparam      S_TYPE       = 3'b010;
  localparam      SB_TYPE      = 3'b011;
  always @(*) begin
    case(alu_op)
      R_TYPE: begin
        case(func)
          4'b0000: begin // add
            alu_operation = 4'b0000;
          end
          4'b1000: begin // sub
            alu_operation = 4'b0001;
          end
          4'b0001: begin // sll
            alu_operation = 4'b0101;
          end
          4'b0010: begin // slt
            alu_operation = 4'b0110;
          end
          4'b0011: begin // sltu
            alu_operation = 4'b0111;
          end
          4'b0100: begin // xor
            alu_operation = 4'b0100;
          end
          4'b0101: begin // srl
            alu_operation = 4'b1000;
          end
          4'b1101: begin // sra
            alu_operation = 4'b1001;
          end
          4'b0110: begin // or
            alu_operation = 4'b0011;
          end
          4'b0111: begin  // and
            alu_operation = 4'b0010;
          end
        endcase
      end
      I_TYPE_L: begin
        case(func[2:0])
          3'b000: begin // lb
            alu_operation = 4'b0000;
          end
          3'b001: begin // lh
            alu_operation = 4'b0000;
          end
          3'b010: begin // lw
            alu_operation = 4'b0000;
          end
          3'b100: begin // lbu
            alu_operation = 4'b0000;
          end
          3'b101: begin // lhu
            alu_operation = 4'b0000;
          end
        endcase
      end

      I_TYPE_A: begin
        case(func[2:0])
          3'b000: begin // addi
            alu_operation = 4'b0000;
          end
          3'b010: begin // slti
            alu_operation = 4'b0110;
          end
          3'b011: begin // sltiu
            alu_operation = 4'b0111;
          end
          3'b100: begin // xori
            alu_operation = 4'b0100;
          end
          3'b110: begin // ori
            alu_operation = 4'b0011;
          end
          3'b111: begin // andi
            alu_operation = 4'b0010;
          end
          3'b001: begin // slli
            alu_operation = 4'b0101;
          end
          3'b101: begin
            if(func[3]) begin // srai
              alu_operation = 4'b1001;
            end
            else begin        // srli
              alu_operation = 4'b1000;
            end
          end
        endcase
      end

      S_TYPE: begin
        case(func[2:0])
          3'b000: begin // sb
            alu_operation = 4'b0000;
          end
          3'b001: begin // sh
            alu_operation = 4'b0000;
          end
          3'b010: begin // sw
            alu_operation = 4'b0000;
          end
        endcase
      end

      SB_TYPE: begin
        case(func[2:0])
          3'b000: begin // beq
            alu_operation = 4'b0001;
          end
          3'b001: begin // bne
            alu_operation = 4'b0001;
          end
          3'b100: begin // blt
            alu_operation = 4'b0001;
          end
          3'b101: begin // bge
            alu_operation = 4'b0001;
          end
          3'b110: begin // bltu
            alu_operation = 4'b1010;
          end
          3'b111: begin // bgeu
            alu_operation = 4'b1010;
          end
        endcase
      end
    endcase
  end
endmodule