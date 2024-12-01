module EXE_stage_reg(clk, rst, SRAM_freeze, WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe, alu_result_exe,
	             Val_Rm_exe, Dest_exe, WB_EN_mem, MEM_R_EN_mem, MEM_W_EN, alu_result,
                     Val_Rm, Dest_mem);

  input clk, rst, SRAM_freeze, WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe;
  input [31:0] alu_result_exe, Val_Rm_exe;
  input [3:0] Dest_exe;

  output reg WB_EN_mem, MEM_R_EN_mem, MEM_W_EN;
  output reg [31:0] alu_result, Val_Rm;
  output reg [3:0] Dest_mem;
 
  always@(posedge clk, posedge rst)begin
    if(rst) begin
      WB_EN_mem <= 1'b0;
      MEM_R_EN_mem <= 1'b0;
      MEM_W_EN <= 1'b0;
      alu_result <= 32'b0;
      Val_Rm <= 32'b0;
      Dest_mem <= 4'b0;
    end
    else if(SRAM_freeze)begin
      WB_EN_mem <= WB_EN_mem;
      MEM_R_EN_mem <= MEM_R_EN_mem;
      MEM_W_EN <= MEM_W_EN;
      alu_result <= alu_result;
      Val_Rm <= Val_Rm;
      Dest_mem <= Dest_mem;
    end
    else begin
      WB_EN_mem <= WB_EN_exe;
      MEM_R_EN_mem <= MEM_R_EN_exe;
      MEM_W_EN <= MEM_W_EN_exe;
      alu_result <= alu_result_exe;
      Val_Rm <= Val_Rm_exe;
      Dest_mem <= Dest_exe;
    end  
  end

endmodule
