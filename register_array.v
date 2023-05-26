module register_array(
  input                 clk,
  input                 rst,
  input         [4:0]   rs1_sel,
  input         [4:0]   rs2_sel,
  input         [31:0]  wr_data,
  input         [4:0]   rd_sel,
  input                 wr_en,
  output  reg   [31:0]  rs1_data,
  output  reg   [31:0]  rs2_data
);

  reg   [31:0]    reg_array   [31:0];
  integer         count;  

  always @(posedge clk) begin
    if(rst) begin
      for(count=0; count<32; count = count +1) begin
        reg_array[count] 	<= 	32'b0;
      end 
    end
    else if(wr_en) begin
        reg_array[rd_sel] <= wr_data;
    end
    else begin
        reg_array[rd_sel] <= reg_array[rd_sel];
    end   
	end

  always @(*) begin
    rs1_data  = reg_array[rs1_sel];
    rs2_data  = reg_array[rs2_sel];
  end

endmodule