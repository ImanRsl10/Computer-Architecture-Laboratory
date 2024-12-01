module Forwarding_unit(src1_id_reg, src2_id_reg, WB_EN_exe_reg, WB_EN_mem_reg, Dest_exe_reg,
		       Dest_mem_reg, fu_en, Sel_src1, Sel_src2);

  input [3:0] src1_id_reg, src2_id_reg;
  input WB_EN_exe_reg, WB_EN_mem_reg;
  input [3:0] Dest_exe_reg, Dest_mem_reg;
  input fu_en;

  output reg [1:0] Sel_src1, Sel_src2;

  always@*begin
    Sel_src1 = 2'b00;
    Sel_src2 = 2'b00;
    if(fu_en)begin
      if((src1_id_reg == Dest_exe_reg) & WB_EN_exe_reg)begin
	       Sel_src1 = 2'b01;
	    end
      else if((src1_id_reg == Dest_mem_reg) & WB_EN_mem_reg)begin
          Sel_src1 = 2'b10;
      end 
      if((src2_id_reg == Dest_exe_reg) & WB_EN_exe_reg)begin
	        Sel_src2 = 2'b01;
	    end
      else if((src2_id_reg == Dest_mem_reg) & WB_EN_mem_reg)begin
          Sel_src2 = 2'b10;
      end
    end
      
  end


endmodule