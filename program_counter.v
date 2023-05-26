module program_counter(
  input                    clk,
  input                    rst,
  input                    mem_out_ready,
  input           [31:0]   next_pc,
  output    reg   [31:0]   pc 
);

  always @(posedge clk or negedge rst) begin
    if (rst) begin
      pc <= 32'b0;
    end
    else if (~mem_out_ready) begin
      pc <= pc;
    end
    else begin
      pc <= next_pc;
    end 
  end
endmodule