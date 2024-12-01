module WB_stage(alu_result, mem_result, MEM_R_EN, WB_WB_EN_mem, WB_Dest_mem, WB_EN_wb, Dest_wb,
		WB_Value);

  input [31:0] alu_result, mem_result;
  input MEM_R_EN, WB_WB_EN_mem;
  input [3:0] WB_Dest_mem;

  output WB_EN_wb;
  output [3:0] Dest_wb;
  output [31:0] WB_Value;

  assign WB_EN_wb = WB_WB_EN_mem;
  assign Dest_wb = WB_Dest_mem;
  assign WB_Value = (MEM_R_EN) ? mem_result : alu_result;

endmodule