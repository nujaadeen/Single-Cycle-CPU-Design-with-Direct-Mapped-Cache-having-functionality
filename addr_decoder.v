module addr_decoder #(
  parameter CACHE_LINE_WIDTH = 128,
  parameter ADDR_WIDTH       = 32,
  parameter DATA_WIDTH       = 32
)(
  input           [CACHE_LINE_WIDTH-1:0]    input_data,
  input           [ADDR_WIDTH-1:0]          addr,
  output   reg    [DATA_WIDTH-1:0]          output_data
);
  always @(*) begin
    case (addr[1:0])
      2'b00: begin 
        output_data = input_data[31:0]; 
      end
      2'b01: begin 
        output_data = input_data[63:32]; 
      end
      2'b10: begin 
        output_data = input_data[95:64]; 
      end
      2'b11: begin 
        output_data = input_data[127:96]; 
      end
    endcase 
  end
endmodule