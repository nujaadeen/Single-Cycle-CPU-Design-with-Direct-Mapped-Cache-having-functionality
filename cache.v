`timescale 1ns/1ns

module cache #(
  parameter CACHE_LINE_WIDTH = 128,
  parameter ADDR_WIDTH       = 32,
  parameter DATA_WIDTH       = 32,
  parameter BLOCK_SIZE       = 4,
  parameter NUM_BLOCKS       = 8
) (
  input                                   clk,      
  input                                   rst,
  input                                   write_enable,         // enable signal for cache write
  input                                   dirty_down,           // signal to makr curr dirty bit from 1->0
  input                                   wr_mem,               // cpu control signal
  input                                   rd_en,                // write back read enable signal
  input         [ADDR_WIDTH-1:0]          addr,
  input         [CACHE_LINE_WIDTH-1:0]    write_data_from_mem,
  input         [DATA_WIDTH-1:0]          write_data_from_cpu,
  output reg    [NUM_BLOCKS-1:0]          valid,              
  output reg    [CACHE_LINE_WIDTH-1:0]    read_data,
  output reg    [NUM_BLOCKS-1:0]          dirty,
  output reg                              hit
);

  reg           [ADDR_WIDTH-1:0]  cache_addr          [NUM_BLOCKS-1:0];                       // cache-line address
  reg           [DATA_WIDTH-1:0]  cache_data          [NUM_BLOCKS-1:0][BLOCK_SIZE-1:0];       // cache memory array
  reg           [ADDR_WIDTH-1:0]  tag                 [NUM_BLOCKS-1:0];                       // tag array
  reg           [NUM_BLOCKS-1:0]  block_idx;                                                  // direct mapped block index

  // iterrating variables
  integer i;
  integer j;
  
  // cal block index
  always @(*) begin
    block_idx = (addr >> 2) % NUM_BLOCKS;
  end 

  always @(posedge clk) begin
    // reset cache
    if (rst) begin                  
      for (i = 0; i < NUM_BLOCKS; i=i+1) begin
        valid[i]                  <=    0;
        tag[i]                    <=    0;
        dirty[i]                  <=    0;
        for (j = 0; j < BLOCK_SIZE; j=j+1) begin
          cache_data[i][j]        <=    0;
        end
      end
    end else begin
      if (write_enable) begin
        // writing to the cache from the data of data memory
        if(~wr_mem) begin
          tag[block_idx]           <=    addr[ADDR_WIDTH-1:2];
          cache_addr[block_idx]    <=    addr[ADDR_WIDTH-1:2] << 2;
          valid[block_idx]         <=    1;
          dirty[block_idx]         <=    0;
          {cache_data[block_idx][3], cache_data[block_idx][2], cache_data[block_idx][1], cache_data[block_idx][0]}    <=    write_data_from_mem;         
        end
        // writing to the cache from the data of cpu
        else begin
          cache_data[block_idx][addr[1:0]]    <=    write_data_from_cpu;
          dirty[block_idx]                    <=    1;
        end
      end
    end
  end

  always @(*) begin
    // cache read if cache hit
    if (valid[block_idx] && tag[block_idx] == addr[ADDR_WIDTH-1:2]) begin
      read_data           =   {cache_data[block_idx][3], cache_data[block_idx][2], cache_data[block_idx][1], cache_data[block_idx][0]};
      hit                 =   1;
      // dirty bit 1->0
      if(dirty_down) begin
        dirty[block_idx]  =   0;
      end
      else begin
        dirty[block_idx]  = dirty[block_idx];
      end
    end
    // cache read for write back
    else if(rd_en) begin
      read_data           =   {cache_data[block_idx][3], cache_data[block_idx][2], cache_data[block_idx][1], cache_data[block_idx][0]};
      hit                 =   0;
    end   
    else begin
      read_data           =   0;
      hit                 =   0;
    end
  end
endmodule