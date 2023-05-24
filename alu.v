module alu(
  input           [3:0]     alu_opr,
  input           [31:0]    operand1,
  input           [31:0]    operand2,
  output   reg    [31:0]    result,
  output   reg    [3:0]     flag
);

  localparam      ADD     = 4'b0000;
  localparam      SUB     = 4'b0001;
  localparam      AND     = 4'b0010;
  localparam      OR      = 4'b0011;
  localparam      XOR     = 4'b0100;
  localparam      SLL     = 4'b0101;
  localparam      SLT     = 4'b0110;
  localparam      SLTU    = 4'b0111;
  localparam      SRL     = 4'b1000;
  localparam      SRA     = 4'b1001;
  localparam      SUBU    = 4'b1010;

  reg           c_out;
  reg   [31:0]  temp;


  always @(*) begin
    case(alu_opr)
      ADD: begin
        result = operand1 + operand2;
      end
      SUB: begin
        {c_out, result} = {1'b0, operand1} + ~{1'b0, operand2} + 1'b1;
      end
      AND: begin
        result = operand1 & operand2; 
      end
      OR: begin
        result = operand1 | operand2; 
      end
      XOR: begin
        result = operand1 ^ operand2; 
      end
      SLL: begin
        result = operand1 << operand2[4:0]; 
      end
      SLT: begin
        {c_out, temp} = {1'b0, operand1} + ~{1'b0, operand2} + 1'b1;
        if(temp[31])begin
          result = 32'd1; 
        end
        else begin
          result = 32'd0; 
        end        
      end
      SLTU: begin
        if (operand1 < operand2) begin
          result = 32'd1; 
        end
        else begin
          result = 32'd0; 
        end    
      end
      SRL: begin
        result = operand1 >> operand2[4:0]; 
      end
      SRA: begin
        result = {operand1[31], (operand1[30:0] >> operand2[4:0])}; 
      end
      SUBU: begin
        result = operand1 - operand2;
      end
      default: begin
        result = operand1;
      end
    endcase
    flag = {result==32'b0, result[31], result[31]^result[30:0] == 31'b0, 1'b1};  // zero, negetive, overload, valid
  end
endmodule
