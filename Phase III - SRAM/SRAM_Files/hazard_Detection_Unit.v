module hazard_Detection_Unit(src1_id, src2_id, Exe_Dest, Exe_WB_EN, move_id, Mem_Dest,
			     Mem_WB_EN, Two_src_id, fu_en,EXE_MEM_R, hazard);
  input [3:0] src1_id, src2_id;
  input [3:0] Exe_Dest;
  input Exe_WB_EN, move_id;
  input [3:0] Mem_Dest;
  input Mem_WB_EN;
  input Two_src_id;
  
  //Add Forwarding unit
  input fu_en;
  input EXE_MEM_R;
  output reg hazard;
  
  //hazard <= mem_read_mem && ((exe_dest == src1) || (two_src && exe_dest == src2));

  always@* begin
    hazard = 1'b0;
    if(fu_en)begin
     if(EXE_MEM_R & ((src1_id == Exe_Dest)|(src2_id == Exe_Dest))) begin
       hazard = 1'b1;
     end
   end
    else begin
     if(Two_src_id)begin
        if((Mem_Dest == src2_id & Mem_WB_EN) | (Exe_Dest == src2_id & Exe_WB_EN))begin
          hazard = 1'b1;
        end
     end
     if(~move_id)begin
        if((Mem_Dest == src1_id & Mem_WB_EN) | (Exe_Dest == src1_id & Exe_WB_EN))begin
	  hazard = 1'b1;
        end
     end
   end
   end

endmodule
