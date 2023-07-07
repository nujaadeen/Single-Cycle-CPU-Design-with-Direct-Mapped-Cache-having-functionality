module victim_cache #(
  parameter CACHE_LINE_WIDTH = 128,
  parameter ADDR_WIDTH       = 32,
  parameter DATA_WIDTH       = 32,
  parameter BLOCK_SIZE       = 4,
  parameter NUM_BLOCKS       = 4
) (
  input                                   clk,
  input                                   rst,
  input          [ADDR_WIDTH-1:0]         addr,
  input          [CACHE_LINE_WIDTH-1:0]   write_data,
  input                                   victim_enable,    // enable signal for victim cache write
  input                                   dirty_bit,        // currn dirty bit
  output  reg    [NUM_BLOCKS-1:0]         dirty,
  output  reg    [CACHE_LINE_WIDTH-1:0]   read_data,
  output  reg                             victim_hit,
  output  reg                             victim_dirty
);

  reg         [ADDR_WIDTH-1:0]  victim_addr    [0:NUM_BLOCKS-1];                  // victim cache-line address
  reg         [DATA_WIDTH-1:0]  victim_data    [0:NUM_BLOCKS-1][0:BLOCK_SIZE-1];  // victim cache memory array 
  reg         [1:0]             mru            [NUM_BLOCKS-1:0];                  // most recently used indication bits
  reg                           valid          [NUM_BLOCKS-1:0];
  reg         [NUM_BLOCKS-1:0]  block_idx;                                        // block index most recently used logic
  reg                           victim_read;                                      // enable read if mru block index is dirty
  
  // iterrating variables
  integer i;
  integer j;

  // mru logic
  always @(*) begin
    victim_dirty = 1'b0;
    for (i = 0; i < NUM_BLOCKS; i=i+1) begin
      if(mru[i] == 2'b00) begin
        if (~dirty[i]) begin
          victim_read = 1'b0;
          block_idx = i;
          case(mru[i])
            2'b01: begin
              mru[i] = 2'b00;
            end
            2'b10: begin
              mru[i] = 2'b01;
            end
            2'b11: begin
              mru[i] = 2'b10;
            end
            2'b00: begin
              mru[i] = 2'b11;
            end
          endcase
        end
        else begin
          victim_read = 1'b1;
          victim_dirty = 1'b1;
        end
      end
       
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < NUM_BLOCKS; i=i+1) begin
        valid[i] <= 0;
        for (j = 0; j < BLOCK_SIZE; j=j+1) begin
          victim_data[i][j] <= 0;
        end
      end
    end else begin
      if (victim_enable) begin     
        victim_addr[block_idx] <= (addr >> 2);
        valid[block_idx] <= 1;
        dirty[block_idx] <= dirty_bit;
        {victim_data[block_idx][3], victim_data[block_idx][2], victim_data[block_idx][1], victim_data[block_idx][0]}    <=    write_data;
      end
    end
  end
  always @(*) begin
    for (i = 0; i < NUM_BLOCKS; i=i+1) begin
      if (victim_addr[i] == (addr>>2)) begin
        read_data = {victim_data[i][3], victim_data[i][2], victim_data[i][1], victim_data[i][0]};
        victim_hit       = 1;
      end 
      if (victim_read) begin
        read_data = {victim_data[block_idx][3], victim_data[block_idx][2], victim_data[block_idx][1], victim_data[block_idx][0]};
        victim_hit       = 0;
      end
      else begin
        read_data = 0;
        victim_hit = 0;
      end
    end   
  end
endmodule