module MEM_stage_reg(clk, rst, SRAM_freeze, WB_EN_mem, MEM_R_EN_mem, alu_result_mem, mem_result_mem,
	             Dest_mem, WB_EN_wb, MEM_R_EN_wb, alu_result_wb, mem_result_wb, Dest_wb);

  input clk, rst, SRAM_freeze, WB_EN_mem, MEM_R_EN_mem;
  input [31:0] alu_result_mem, mem_result_mem;
  input [3:0] Dest_mem;
  output reg WB_EN_wb, MEM_R_EN_wb;
  output reg [31:0] alu_result_wb, mem_result_wb;
  output reg [3:0] Dest_wb;

  always@(posedge clk, posedge rst)begin
    if(rst) begin
      WB_EN_wb <= 1'b0;
      MEM_R_EN_wb <= 1'b0;
      alu_result_wb <= 32'b0;
      mem_result_wb <= 32'b0;
      Dest_wb <= 4'b0;
    end
    else if(SRAM_freeze)begin
      WB_EN_wb <= WB_EN_wb;
      MEM_R_EN_wb <= MEM_R_EN_wb;
      alu_result_wb <= alu_result_wb;
      mem_result_wb <= mem_result_wb;
      Dest_wb <= Dest_wb;
    end
    else begin
      WB_EN_wb <= WB_EN_mem;
      MEM_R_EN_wb <= MEM_R_EN_mem;
      alu_result_wb <= alu_result_mem;
      mem_result_wb <= mem_result_mem;
      Dest_wb <= Dest_mem;
    end  
  end

endmodule