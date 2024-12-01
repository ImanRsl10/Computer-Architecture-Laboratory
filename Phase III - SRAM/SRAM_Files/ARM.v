module ARM(clk, rst);
  input clk, rst;
  wire [31:0] WB_Value;
  wire WB_WB_EN;
  //input [3:0] WB_DEST;
  wire [3:0] SR;
  //output WB_EN, MEM_R_EN, MEM_W_EN;
  wire [31:0] ALU_result, Val_Rm_EXE;
  wire [3:0] WB_DEST;

  //IF
  wire freeze, Branch_taken;
  wire [31:0] BranchAddr, IF_PC, IF_Instruction;

  //assign freeze = 1'b0;
  //assign Brach_taken = 1'b0;
  //assign BranchAddr = 32'b0;

  wire flush;
  wire hazard;
  wire [31:0] IF_Reg_PC, IF_Reg_Instruction;

  //assign flush = 1'b0;
  //assign hazard = 1'b0;
  //ID
  wire ID_WB_EN_out, ID_MEM_R_EN_out, ID_MEM_W_EN_out, ID_B_out, ID_S_out;
  wire [3:0] ID_EXE_CMD_out;
  wire [31:0] ID_Val_Rn_out, ID_Val_Rm_out;
  wire ID_imm_out;
  wire [11:0] ID_Shift_operand_out;
  wire [23:0] ID_Signed_imm_24_out;
  wire [3:0] ID_Dest_out;
  wire [3:0] src1, src2;
  wire Two_src;
  //ID Reg
  wire IDreg_WB_EN_out, IDreg_MEM_R_EN_out, IDreg_MEM_W_EN_out, B, S;
  wire [3:0] EXE_CMD;
  wire [31:0] Val_Rn, Val_Rm;
  wire imm;
  wire [11:0] Shift_operand;
  wire [23:0] Signed_imm_24;
  wire [3:0] IDreg_Dest;
  //EXE
  wire [31:0] ALU_Res;
  wire [3:0] status;
  wire cin;
  //EXE Reg
  //MEM
  wire [31:0] address;
  assign address = ALU_result;
  //MEM reg
  wire WB_EN_MEM, MEM_R_EN_MEM;
  wire [31:0] ALU_res_MEM, Mem_read_val_MEM;
  wire [3:0] Dest_MEM;
  //wire [31:0] ALU_Result;
  //wire [31:0] ST_val;
  //WB
  wire [31:0] MEM_result;
  //Status Register
  wire S_reg_out;
  //assign MEM_result = 32'd999;
  //assign cin = SR[1];
  //hazard unit
  wire Exe_WB_EN, Mem_WB_EN;
  wire [3:0] Exe_Dest, Mem_Dest;
  assign Exe_Dest = IDreg_Dest;
  assign Exe_WB_EN = IDreg_WB_EN_out;
  assign Mem_Dest = WB_DEST;
  assign Mem_WB_EN = WB_WB_EN;
  wire hazard_Detected;
  wire [31:0] PC;
  wire move;
  assign flush = B;

  IF_stage IF(clk, rst, hazard_Detected, B, BranchAddr, IF_PC, IF_Instruction);

  IF_stage_reg IF_Reg(clk, rst, hazard_Detected, flush, IF_PC, IF_Instruction, IF_Reg_PC, IF_Reg_Instruction);

  ID_stage ID(clk, rst, IF_Reg_Instruction, WB_Value, WB_EN_MEM, Dest_MEM, hazard_Detected, SR, 
	      ID_WB_EN_out, ID_MEM_R_EN_out, ID_MEM_W_EN_out, ID_B_out, ID_S_out,
	      ID_EXE_CMD_out, ID_Val_Rn_out, ID_Val_Rm_out, ID_imm_out, ID_Shift_operand_out,
	      ID_Signed_imm_24_out, ID_Dest_out, src1, src2, Two_src, move);

  ID_stage_reg ID_Reg(clk, rst, flush, ID_WB_EN_out, ID_MEM_R_EN_out, ID_MEM_W_EN_out,
		      ID_B_out, ID_S_out, ID_EXE_CMD_out, IF_Reg_PC, ID_Val_Rn_out,
		      ID_Val_Rm_out, ID_imm_out, SR[1], ID_Shift_operand_out, ID_Signed_imm_24_out,
		      ID_Dest_out, IDreg_WB_EN_out, IDreg_MEM_R_EN_out, IDreg_MEM_W_EN_out,
		      B, S, EXE_CMD, PC, Val_Rn, Val_Rm, imm, cin, Shift_operand, Signed_imm_24, IDreg_Dest);
  

  EXE_stage EXE(clk, EXE_CMD, IDreg_MEM_R_EN_out, IDreg_MEM_W_EN_out, PC, Val_Rn, Val_Rm, imm, cin,
		Shift_operand, Signed_imm_24, ALU_Res, BranchAddr, status);

  EXE_stage_reg EXE_Reg(clk, rst, IDreg_WB_EN_out, IDreg_MEM_R_EN_out, IDreg_MEM_W_EN_out, ALU_Res,
	       		Val_Rm, IDreg_Dest, WB_WB_EN, MEM_R_EN, MEM_W_EN, ALU_result,
               		Val_Rm_EXE, WB_DEST);

  MEM_stage MEM(clk, MEM_R_EN, MEM_W_EN, ALU_result, Val_Rm_EXE, MEM_result);

  MEM_stage_reg MEM_Reg(clk, rst, WB_WB_EN, MEM_R_EN, ALU_result, MEM_result, WB_DEST, WB_EN_MEM,
			MEM_R_EN_MEM, ALU_res_MEM, Mem_read_val_MEM, Dest_MEM);

  WB_stage WB(ALU_res_MEM, Mem_read_val_MEM, MEM_R_EN_MEM, WB_Value);

  status_register status_reg(clk, rst, S, status[3], status[2], status[1], status[0], S_reg_out, SR);

  hazard_Detection_Unit hazard_unit(src1, src2, Exe_Dest, Exe_WB_EN, move, Mem_Dest,
			     	    Mem_WB_EN, Two_src, hazard_Detected);

endmodule
