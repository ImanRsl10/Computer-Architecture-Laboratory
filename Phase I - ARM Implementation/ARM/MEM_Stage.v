module MEM_stage(clk, mem_read, mem_write, aluRes_address, Val_Rm, mem_result);
  input clk, mem_read, mem_write;
  input [31:0] aluRes_address, Val_Rm;
  output [31:0] mem_result;
  
  reg [31:0] memory [63:0];

  always@(posedge clk)begin
    if(mem_write)
      memory[(aluRes_address - 32'd1024) >> 2] = Val_Rm;
  end

  assign mem_result = (mem_read) ? memory[(aluRes_address - 32'd1024) >> 2] : 32'bz;

endmodule
