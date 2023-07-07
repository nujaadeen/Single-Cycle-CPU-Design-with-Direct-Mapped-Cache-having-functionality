module width_sel(
    input               [2:0]     func,
    input               [31:0]    inp_word,
    output      reg     [31:0]    out_word
  );
    
  localparam      BYTE         = 3'b000;
  localparam      HALFWORD     = 3'b001;
  localparam      WORD         = 3'b010;
  localparam      BYTE_U       = 3'b100;
  localparam      HALFWORD_U   = 3'b101;

  reg signed [31:0] singed_word;
    
  reg signed [31:0] singed_byte;
  reg signed [31:0] singed_halfword;
    
  always @(*) begin
    singed_word = inp_word;

    singed_byte = (singed_word << 24) >>> 24;
    singed_halfword = (singed_word << 16) >>> 16;

    case(func)
      BYTE: begin
        out_word = singed_byte;
      end
      HALFWORD: begin
        out_word = singed_halfword;
      end
      WORD: begin
        out_word = inp_word;
      end
      BYTE_U: begin
        out_word = {24'b0, inp_word[7:0]};
      end
      HALFWORD_U: begin
        out_word = {16'b0, inp_word[15:0]};
      end
      default: begin
        out_word = inp_word;
      end
    endcase
  end 
endmodule