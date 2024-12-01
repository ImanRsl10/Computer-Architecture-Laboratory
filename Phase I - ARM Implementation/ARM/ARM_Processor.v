module ARM_Processor(input clk, rst, fu_en);

  //IF interconnects
  wire freeze; //freeze --> hazard , branch comes from ID reg
  wire [31:0] branch_address, PC_if, Instruction_if; //branch address comes from exe part
  //IF reg
  wire flush; //assign to branch
  wire [31:0] PC_id, Instruction_id;
  //ID
  //wire [31:0] WB_val; //comes from WB stage
  //wire WB_WB_EN; //comes from WB
  //wire [3:0] WB_Dest; //comes from WB
  //**hazard signal
  //SR --> status register output
  wire WB_EN_id, MEM_R_EN_id, MEM_W_EN_id, Branch_id, S_id;
  wire [3:0] EXE_CMD_id;
  wire [31:0] Val_Rn_id, Val_Rm_id;
  wire imm_id;
  wire [11:0] Shift_operand_id;
  wire [23:0] Signed_imm_24_id; 
  wire [3:0] Dest_id, src1_id, src2_id;
  wire Two_src_id, move_id;
  //ID reg
  //**SRcin comes from status register --> SR[?] (assign)
  wire WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe, Branch_if, S_sr;
  wire [3:0] EXE_CMD;
  wire [31:0] PC_exe, Val_Rn_exe, Val_Rm_exe;
  wire imm_exe;
  wire [3:0] status_exe_in;
  wire [11:0] Shift_operand_exe;
  wire [23:0] Signed_imm_24_exe;
  wire [3:0] Dest_exe;
  wire [3:0] src1_id_fu, src2_id_fu;
  //Exe
  wire [31:0] alu_result_exe, branch_address_if;
  wire [3:0] status_exe;
  wire [31:0] Val_Rm_exe_reg;
  //Exe Reg
  wire WB_EN_mem, MEM_R_EN_mem, MEM_W_EN_mem;
  wire [31:0] alu_result_mem, Val_Rm_mem;
  wire [3:0] Dest_mem;
  //MEM
  wire [31:0] mem_result_mem;
  //MEM Reg
  wire WB_EN_wb, MEM_R_EN_wb;
  wire [31:0] alu_result_wb, mem_result_wb;
  wire [3:0] Dest_wb;
  //WB
  wire WB_EN;
  wire [3:0] Dest;
  wire [31:0] WB_Value;
  //Status Reg
  wire [3:0] status_sr;
  //Hazard Unit
  wire hazard;
  //Forwarding Unit
  wire [1:0] Sel_src1, Sel_src2;
  //**********assign***********//
  assign freeze = hazard;
  assign flush = Branch_if;
  assign SR_cin = status_sr[1];
  assign SR_ov_in = status_sr[0];

  IF_stage IF(clk, rst, freeze, Branch_if, branch_address_if, PC_if, Instruction_if);

  IF_stage_reg IF_Reg(clk, rst, freeze, flush, PC_if, Instruction_if, PC_id, Instruction_id);

  ID_stage ID(clk, rst, Instruction_id, WB_Value, WB_EN, Dest, hazard, status_sr, 
	      WB_EN_id, MEM_R_EN_id, MEM_W_EN_id, Branch_id, S_id, EXE_CMD_id,
	      Val_Rn_id, Val_Rm_id, imm_id, Shift_operand_id, Signed_imm_24_id,
              Dest_id, src1_id, src2_id, Two_src_id, move_id);

  ID_stage_reg ID_Reg(clk, rst, flush, WB_EN_id, MEM_R_EN_id, MEM_W_EN_id, Branch_id,
                      S_id, EXE_CMD_id, PC_id, Val_Rn_id, Val_Rm_id, imm_id, status_sr,
                      Shift_operand_id, Signed_imm_24_id, Dest_id, src1_id, src2_id,
		      WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe, Branch_if, S_sr, EXE_CMD,
		      PC_exe, Val_Rn_exe, Val_Rm_exe, imm_exe, status_exe_in, Shift_operand_exe,
	              Signed_imm_24_exe, Dest_exe, src1_id_fu, src2_id_fu);

  EXE_stage EXE(clk, EXE_CMD, MEM_R_EN_exe, MEM_W_EN_exe, PC_exe, Val_Rn_exe, Val_Rm_exe,
		imm_exe, status_exe_in, Shift_operand_exe, Signed_imm_24_exe, Sel_src1, Sel_src2,
		alu_result_mem, WB_Value, alu_result_exe, branch_address_if, status_exe, Val_Rm_exe_reg);

  EXE_stage_reg EXE_Reg(clk, rst, WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe, alu_result_exe,
	                Val_Rm_exe_reg, Dest_exe, WB_EN_mem, MEM_R_EN_mem, MEM_W_EN_mem,
			alu_result_mem, Val_Rm_mem, Dest_mem);

  MEM_stage MEM(clk, MEM_R_EN_mem, MEM_W_EN_mem, alu_result_mem, Val_Rm_mem, mem_result_mem);

  MEM_stage_reg MEM_Reg(clk, rst, WB_EN_mem, MEM_R_EN_mem, alu_result_mem, mem_result_mem,
	                Dest_mem, WB_EN_wb, MEM_R_EN_wb, alu_result_wb, mem_result_wb, Dest_wb);

  WB_stage WB(alu_result_wb, mem_result_wb, MEM_R_EN_wb, WB_EN_wb, Dest_wb, WB_EN, Dest, WB_Value);

  status_register SR(clk, rst, S_sr, status_exe, status_sr);

  hazard_Detection_Unit HU(src1_id, src2_id, Dest_exe, WB_EN_exe, move_id, Dest_mem,
			   WB_EN_mem, Two_src_id, fu_en,MEM_R_EN_exe, hazard);

  Forwarding_unit FU(src1_id_fu, src2_id_fu, WB_EN_mem, WB_EN_wb, Dest_mem,
		     Dest_wb, fu_en, Sel_src1, Sel_src2);
  
endmodule