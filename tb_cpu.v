`timescale 1ns/1ns

module tb_cpu();
  reg                   clk;
  reg                   rst;
  reg                   mem_ready;     

    

  top_cpu dut(
    .clk              (clk),
    .rst              (rst),
    .mem_ready        (mem_ready)
  );
    

  initial begin
    clk = 1'b0;
    forever begin
      #1 clk = ~clk;
    end
  end


  initial begin
    rst = 1'b1;  mem_ready = 1'b1;      
    repeat (2) @ (posedge clk);

    rst = 0;
    repeat (60) @ (posedge clk);

    $finish;       
  end

  initial begin
    $monitor( $realtime, ", clk = %b, rst = %b",clk, rst);
    #200 $finish;
  end
endmodule