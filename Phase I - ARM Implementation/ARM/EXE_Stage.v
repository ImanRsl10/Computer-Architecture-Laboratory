module EXE_stage(clk, EXE_CMD, MEM_R_EN, MEM_W_EN, PC, Val_Rn, Val_Rm, imm, SR_in,
		 Shift_operand, Signed_immediate, alu_result, branch_address, status);

  input clk;
  input [3:0] EXE_CMD;
  input MEM_R_EN, MEM_W_EN;
  input [31:0] PC;
  input [31:0] Val_Rn, Val_Rm;
  input imm;
  input [3:0] SR_in;
  input [11:0] Shift_operand;
  input [23:0] Signed_immediate;

  output [31:0] alu_result, branch_address;
  output [3:0] status;

  wire [31:0] alu_in1, alu_in2;
  
  assign alu_in1 = Val_Rn;

  Val2Gen v2g(Shift_operand, imm, MEM_R_EN, MEM_W_EN, Val_Rm, alu_in2);

  ALU alu(alu_in1, alu_in2, SR_in, EXE_CMD, alu_result, status);

  assign branch_address = PC + ({{8{Signed_immediate[23]}}, Signed_immediate} << 2);

endmodule
