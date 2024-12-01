module IF_stage_reg(clk, rst, freeze, flush, PC_in, Instruction_if, PC_out, Instruction_id);

  input clk, rst, freeze, flush;
  input [31:0] PC_in, Instruction_if;
  output reg [31:0] PC_out, Instruction_id;

  always@(posedge clk, posedge rst)begin
    if(rst)begin
      PC_out <= 32'b0;
      Instruction_id <= 32'b0;
    end
    else if(flush)begin
      PC_out <= 32'b0;
      Instruction_id <= 32'b0;
    end 
    else if(freeze) begin
      PC_out <= PC_out;
      Instruction_id <= Instruction_id;
    end
    else begin
      PC_out <= PC_in;
      Instruction_id <= Instruction_if;
    end    
  end

endmodule