module MEM_stage(clk, rst, mem_read, mem_write, aluRes_address, Val_Rm, mem_result, SRAM_DQ, SRAM_ADDR,
		 SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N, SRAM_freeze);
  input clk, rst, mem_read, mem_write;
  input [31:0] aluRes_address, Val_Rm;
  output [31:0] mem_result;
  output [15:0] SRAM_DQ;
  output [17:0] SRAM_ADDR;
  output SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N, SRAM_freeze;

  wire ready;
  
  wire [31:0] address;
  
  assign address = (aluRes_address - 32'd1024);

  SRAM_Controller SRAM_CU(clk, rst, mem_write, mem_read, address, Val_Rm, mem_result, ready,
			  SRAM_DQ, SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);

  assign SRAM_freeze = ~ready;
  
  //reg [31:0] memory [63:0];

  /*always@(posedge clk)begin
    if(mem_write)
      memory[(aluRes_address - 32'd1024) >> 2] = Val_Rm;
  end

  assign mem_result = (mem_read) ? memory[(aluRes_address - 32'd1024) >> 2] : 32'bz;*/

endmodule
