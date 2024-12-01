module RegisterFile(clk, rst, src1, src2, writeBack_dest, writeBack_result, writeBack_en, reg_val1, reg_val2);
  input clk, rst;
  input [3:0] src1, src2, writeBack_dest;
  input [31:0] writeBack_result;
  input writeBack_en;
  output [31:0] reg_val1, reg_val2;
  
  reg [31:0] reg_file[0:14];
  
  assign reg_val1 = reg_file[src1];
  assign reg_val2 = reg_file[src2];

  integer i;
  
  always @(negedge clk, posedge rst)begin
      if(rst)
	for(i = 0; i < 15; i = i + 1)
          reg_file[i] <= i;
      else if(writeBack_en)
        reg_file[writeBack_dest] <= writeBack_result;
  end 

endmodule 
