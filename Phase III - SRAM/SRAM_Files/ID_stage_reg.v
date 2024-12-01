module ID_stage_reg(clk, rst, flush, SRAM_freeze, WB_EN_id, MEM_R_EN_id, MEM_W_EN_id, Branch_id, S_id,
		    EXE_CMD_id, PC_in, Val_Rn_id, Val_Rm_id, imm_id, SR_sr, Shift_operand_id,
		    Signed_imm_24_id, Dest_id, src1_id, src2_id, WB_EN_exe, MEM_R_EN_exe,
		    MEM_W_EN_exe, Branch_if, S_sr, EXE_CMD, PC_out, Val_Rn, Val_Rm_exe, imm,
		    SR_exe, Shift_operand, Signed_imm_24, Dest_exe, src1_id_fu, src2_id_fu);

  input clk, rst, flush, SRAM_freeze;
  input WB_EN_id, MEM_R_EN_id, MEM_W_EN_id, Branch_id, S_id;
  input [3:0] EXE_CMD_id;
  input [31:0] PC_in;
  input [31:0] Val_Rn_id, Val_Rm_id;
  input imm_id;
  input [3:0] SR_sr;
  input [11:0] Shift_operand_id;
  input [23:0] Signed_imm_24_id; 
  input [3:0] Dest_id;
  //Adding forward
  input [3:0] src1_id, src2_id;

  output reg WB_EN_exe, MEM_R_EN_exe, MEM_W_EN_exe, Branch_if, S_sr;
  output reg [3:0] EXE_CMD;
  output reg [31:0] PC_out;
  output reg [31:0] Val_Rn, Val_Rm_exe;
  output reg imm;
  output reg [3:0] SR_exe;
  output reg [11:0] Shift_operand;
  output reg [23:0] Signed_imm_24;
  output reg [3:0] Dest_exe;
  ////Adding forward
  output reg [3:0] src1_id_fu, src2_id_fu;

  always@(posedge clk, posedge rst)begin
    if(rst) begin
      WB_EN_exe <= 1'b0;
      MEM_R_EN_exe <= 1'b0;
      MEM_W_EN_exe <= 1'b0;
      Branch_if <= 1'b0;
      S_sr <= 1'b0;
      EXE_CMD <= 4'b0;
      PC_out <= 32'b0;
      Val_Rn <= 32'b0;
      Val_Rm_exe <= 32'b0;
      imm <= 1'b0;
      SR_exe <= 4'b0;
      Shift_operand <= 12'b0;
      Signed_imm_24 <= 24'b0;
      Dest_exe <= 4'b0;
      src1_id_fu <= 4'b0;
      src2_id_fu <= 4'b0;
    end
    else if(flush) begin
      WB_EN_exe <= 1'b0;
      MEM_R_EN_exe <= 1'b0;
      MEM_W_EN_exe <= 1'b0;
      Branch_if <= 1'b0;
      S_sr <= 1'b0;
      EXE_CMD <= 4'b0;
      PC_out <= 32'b0;
      Val_Rn <= 32'b0;
      Val_Rm_exe <= 32'b0;
      imm <= 1'b0;
      SR_exe <= 4'b0;
      Shift_operand <= 12'b0;
      Signed_imm_24 <= 24'b0;
      Dest_exe <= 4'b0;
      src1_id_fu <= 4'b0;
      src2_id_fu <= 4'b0;
    end
    else if(SRAM_freeze) begin
      WB_EN_exe <= WB_EN_exe;
      MEM_R_EN_exe <= MEM_R_EN_exe;
      MEM_W_EN_exe <= MEM_W_EN_exe;
      Branch_if <= Branch_if;
      S_sr <= S_sr;
      EXE_CMD <= EXE_CMD;
      PC_out <= PC_out;
      Val_Rn <= Val_Rn;
      Val_Rm_exe <= Val_Rm_exe;
      imm <= imm;
      SR_exe <= SR_exe;
      Shift_operand <= Shift_operand;
      Signed_imm_24 <= Signed_imm_24;
      Dest_exe <= Dest_exe;
      src1_id_fu <= src1_id_fu;
      src2_id_fu <= src2_id_fu;
    end
    else begin
      WB_EN_exe <= WB_EN_id;
      MEM_R_EN_exe <= MEM_R_EN_id;
      MEM_W_EN_exe <= MEM_W_EN_id;
      Branch_if <= Branch_id;
      S_sr <= S_id;
      EXE_CMD <= EXE_CMD_id;
      PC_out <= PC_in;
      Val_Rn <= Val_Rn_id;
      Val_Rm_exe <= Val_Rm_id;
      imm <= imm_id;
      SR_exe <= SR_sr;
      Shift_operand <= Shift_operand_id;
      Signed_imm_24 <= Signed_imm_24_id;
      Dest_exe <= Dest_id;
      src1_id_fu <= src1_id;
      src2_id_fu <= src2_id;
    end  
  end

endmodule
