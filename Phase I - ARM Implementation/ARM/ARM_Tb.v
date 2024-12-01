`timescale 1ns/1ns
module ARM_Tb();
  reg clk, rst;

  ARMss ARM_inst(clk, rst);

  initial begin
    clk = 1'b0;
    rst = 1'b1;
  end
  
  always #5 clk = ~clk;
  
  initial begin
    #12 rst = 1'b0;
    #3000 $stop;
  end

endmodule