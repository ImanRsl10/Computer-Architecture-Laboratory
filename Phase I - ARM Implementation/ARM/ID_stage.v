module ID_stage(clk, rst, Instruction, WB_Value, WB_WB_EN, WB_DEST, hazard, SR, 
		WB_EN, MEM_R_EN, MEM_W_EN, Branch, S, EXE_CMD, Val_Rn, Val_Rm, imm,
		Shift_operand, Signed_imm_24, Dest, src1, src2, Two_src, move);

  input clk, rst;
  input [31:0] Instruction;
  input [31:0] WB_Value;
  input WB_WB_EN;
  input [3:0] WB_DEST;
  input hazard;
  input [3:0] SR;

  output WB_EN, MEM_R_EN, MEM_W_EN, Branch, S;
  output [3:0] EXE_CMD;
  output [31:0] Val_Rn, Val_Rm;
  output imm;
  output [11:0] Shift_operand;
  output [23:0] Signed_imm_24;
  output [3:0] Dest;
  output [3:0] src1, src2;
  output Two_src, move;

  wire wb_en, mem_read, mem_write, branch, s_in;
  wire [3:0] exe_cmd;
  wire [3:0] opcode, cond, dest;
  wire [1:0] mode;
  wire s_out, cond_check_out, ctrl_sel;

  assign opcode = Instruction[24:21];
  assign cond = Instruction[31:28];
  assign mode = Instruction[27:26];
  assign s_in = Instruction[20];

  assign src1 = Instruction[19:16];
  assign src2 = (MEM_W_EN) ? Instruction[15:12] : Instruction[3:0];

  assign ctrl_sel = ~cond_check_out | hazard;

  RegisterFile RF(clk, rst, src1, src2, WB_DEST, WB_Value, WB_WB_EN, Val_Rn, Val_Rm);

  Condition_Check Cond_check(cond, SR, cond_check_out);

  Control_Unit CU(mode, opcode, s_in, exe_cmd, mem_read, mem_write, wb_en, branch, s_out, move);
  
  assign imm = Instruction[25];  
  assign Dest = Instruction[15:12];
  assign Signed_imm_24 = Instruction[23:0];
  assign Shift_operand = Instruction[11:0];

  assign WB_EN = ctrl_sel ? 1'b0 : wb_en;
  assign MEM_R_EN = ctrl_sel ? 1'b0 : mem_read;
  assign MEM_W_EN = ctrl_sel ? 1'b0 : mem_write;
  assign EXE_CMD = ctrl_sel ? 4'b0 : exe_cmd;
  assign Branch = ctrl_sel ? 1'b0 : branch;
  assign S = ctrl_sel ? 1'b0 : s_out;

  assign Two_src = (~imm & (Instruction[27:26] == 2'b0)) | mem_write;

endmodule