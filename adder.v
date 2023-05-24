module adder(
  input     [31:0]    operand1,
  input     [31:0]    operand2,
  output    [31:0]    out_data
);

  assign  out_data = operand1 + operand2;

endmodule