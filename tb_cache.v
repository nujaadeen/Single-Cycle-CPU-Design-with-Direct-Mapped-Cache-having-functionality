

module cache_tb();
  reg                   clk;
  reg                   rst;
  reg         [31:0]    addr;
  reg         [31:0]    write_data;
  reg                   write_enable;
  reg                   dirty_down;
  wire        [31:0]    read_data;
  wire        [31:0]    dirty;
  wire                  hit;


    

  cache dut(
    .clk              (clk),
    .rst              (rst),
    .addr             (addr),
    .write_data       (write_data),
    .write_enable     (write_enable),
    .dirty_down       (dirty_down),
    .read_data        (read_data),
    .dirty            (dirty),
    .hit              (hit)
  );
    

  initial begin
    clk = 1'b0;
    forever begin
      #1 clk = ~clk;
    end
  end


  initial begin
    rst = 1'b1; addr=32'b0; write_data=32'd23; write_enable=1'b1;dirty_down = 1'b0;      
    repeat (2) @ (posedge clk);

    rst = 0;
    repeat (20) @ (posedge clk);

    write_enable=1'b0;
    addr = 0;
    repeat (14) @ (posedge clk);

    dirty_down = 1'b1;       
    repeat (10) @ (posedge clk);

    dirty_down = 1'b0;
    repeat (10) @ (posedge clk);

    $finish;       
  end

  always @(posedge clk) begin
    write_data <= write_data + 32'd10;
    addr<= addr + 1;
  end

  initial begin
    $monitor( $realtime, ", clk = %b, rst = %b, addr=%b, write_data=%b, write_enable=%b",clk, rst, addr, write_data, write_enable);
    #200 $finish;
  end
endmodule