module EXE_stage(clk, EXE_CMD, MEM_R_EN, MEM_W_EN, PC, Val_Rn, Val_Rm, imm, SR_in,
		 Shift_operand, Signed_immediate, Sel_src1, Sel_src2, alu_result_exe_reg,
		 WB_val_wb, alu_result, branch_address, status, Val_Rm_exe);

  input clk;
  input [3:0] EXE_CMD;
  input MEM_R_EN, MEM_W_EN;
  input [31:0] PC;
  input [31:0] Val_Rn, Val_Rm;
  input imm;
  input [3:0] SR_in;
  input [11:0] Shift_operand;
  input [23:0] Signed_immediate;
  //Adding forward
  input [1:0] Sel_src1, Sel_src2;
  input [31:0] alu_result_exe_reg, WB_val_wb;

  output [31:0] alu_result, branch_address;
  output [3:0] status;
  //Adding forward
  output [31:0] Val_Rm_exe;

  wire [31:0] alu_in1, val2_gen_in, alu_in2;
  //Adding forward
   //assign alu_in1 = Val_Rn;
  assign alu_in1 = (Sel_src1 == 2'b00) ? Val_Rn :
		   (Sel_src1 == 2'b01) ? alu_result_exe_reg :
		   (Sel_src1 == 2'b10) ? WB_val_wb : 32'b0;

  assign val2_gen_in = (Sel_src2 == 2'b00) ? Val_Rm :
		   (Sel_src2 == 2'b01) ? alu_result_exe_reg :
		   (Sel_src2 == 2'b10) ? WB_val_wb : 32'b0;

  Val2Gen v2g(Shift_operand, imm, MEM_R_EN, MEM_W_EN, val2_gen_in, alu_in2);

  ALU alu(alu_in1, alu_in2, SR_in, EXE_CMD, alu_result, status);

  assign branch_address = PC + ({{8{Signed_immediate[23]}}, Signed_immediate} << 2);

  assign Val_Rm_exe = val2_gen_in;

endmodule
