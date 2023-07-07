module data_mem#(
  parameter CACHE_LINE_WIDTH = 128,
  parameter ADDR_WIDTH       = 32,
  parameter DATA_WIDTH       = 32,
  parameter MEMORY_DEPTH     = 64
)(
    input                               clk, 
    input                               rst, 
    input                               mem_write,
    input       [ADDR_WIDTH-3:0]        addr,   // 30-bit block address
    input       [CACHE_LINE_WIDTH-1:0]  din,
    output reg  [CACHE_LINE_WIDTH-1:0]  dout
  );

    reg   [DATA_WIDTH-1:0] mem      [MEMORY_DEPTH-1:0];
    wire  [ADDR_WIDTH-1:0] addr_gen;

    assign  addr_gen = addr << 2;           // 32-bit extendtion for block address
    // initialize memory
    integer i;
    initial begin
        for (i = 1; i < 40; i = i + 1) begin
          if (i % 4) begin
            mem[i] <= 32'hF0;
          end
            
        end
        {mem[0]}     <= 32'h0000_0003;       //3 
        {mem[4]}     <= 32'h0000_0001;       //1
        {mem[8]}     <= 32'h0000_002C;       //44
        {mem[12]}    <= 32'hFFFF_FFB7;       //-73
        {mem[16]}    <= 32'h0000_0000;       //0
        {mem[20]}    <= 32'h0000_0041;       //65
        {mem[24]}    <= 32'h0000_0144;       //324
        {mem[28]}    <= 32'hFFFF_FFE1;       //-31
        {mem[32]}    <= 32'h0000_0004;       //4
        {mem[35]}    <= 32'hFFFF_FFF9;       //-7
        {mem[36]}    <= 32'hFFFF_FFF7;
        {mem[40]}    <= 32'h0000_0000;
        for (i = 44; i < 64; i = i + 1) begin
            mem[i] <= 32'hF0;
        end
    end   
    always @ (posedge clk) begin
        if (mem_write) begin
            {mem[addr_gen + 3], mem[addr_gen + 2], mem[addr_gen + 1], mem[addr_gen]} <= din;
        end
        else begin
            {mem[addr_gen + 3], mem[addr_gen + 2], mem[addr_gen + 1], mem[addr_gen]} <= {mem[addr_gen + 3], mem[addr_gen + 2], mem[addr_gen + 1], mem[addr_gen]};
        end
    end
    always @(*) begin
      dout = {mem[addr_gen + 3], mem[addr_gen + 2], mem[addr_gen + 1], mem[addr_gen]};
    end
endmodule

  