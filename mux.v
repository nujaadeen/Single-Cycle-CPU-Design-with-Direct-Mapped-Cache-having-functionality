module mux(
  input   [31:0]    input1,
  input   [31:0]    input2,
  input             sel,
  output  [31:0]    out_data
);

  assign  out_data = (sel == 0) ? input1 : input2;

endmodule