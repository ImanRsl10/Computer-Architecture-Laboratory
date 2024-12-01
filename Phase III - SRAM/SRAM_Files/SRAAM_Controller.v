module SRAAM_Controller(clk, rst, write_en_mem, read_en_mem, SRAM_address_in, write_data, read_data, ready, SRAM_DQ, 
		       SRAM_ADDR, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
  input clk, rst;
  //From Mem stage
  input write_en_mem, read_en_mem;
  input [31:0] SRAM_address_in, write_data;
  //To next stage
  output [31:0] read_data;
  //for freeze other stages
  output ready;

  inout [15:0] SRAM_DQ;
  output reg [17:0] SRAM_ADDR;
  output reg SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;

  parameter [3:0] Idle = 4'b0000, write1 = 4'b0001, write2 = 4'b0010, read1=4'b0011, read2=4'b0100, read3=4'b0101, read4=4'b0110, read5=4'b0111;
				  
  reg [3:0] ps, ns;
  reg [15:0] high_data_temp,low_data_temp;

  always@* begin
    ns = Idle;
    case(ps)
	Idle: begin if (~write_en_mem & ~read_en_mem)
                    ns = Idle;
                else if (write_en_mem)
                    ns = write1;
                else
                    ns = read1;
	end
	write1: ns=write2;
	write2: ns=Idle;
	read1: ns=read2;
	read2: ns=read3;
	read3: ns=read4;
	read4: ns=read5;
	read5: ns=Idle;
    endcase
  end

  always@(ps)begin
     SRAM_ADDR = 18'b0; SRAM_WE_N = 1'b1;
        case (ps)
            write1: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b0};
                SRAM_WE_N = 1'b0;
            end
            write2: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b1};
                SRAM_WE_N = 1'b0;
            end
            read1: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b0};
            end
            read2: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b0};
                low_data_temp = SRAM_DQ;
            end
            read3: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b1};
                // readLSB = SRAM_DQ;
            end
            read4: begin
                SRAM_ADDR = {SRAM_address_in[18:2], 1'b1};
                high_data_temp = SRAM_DQ;
            end
            read5: begin
                // readMSB = SRAM_DQ;
            end
        endcase
  end

  always@(posedge clk)begin
    if(rst)
      ps <= Idle;
    else 
      ps <= ns;
  end
  
  assign SRAM_DQ = (ps == write1) ? write_data[15:0]:
                (ps == write2) ? write_data[31:16]:16'bz;
                
    assign ready = (ns == Idle) ? 1'b1:1'b0;
    // assign ready = (writeEn | readEn) ? 1'b1:1'b0;

    assign read_data = (ps == read5) ? {high_data_temp, low_data_temp}:32'bz;

endmodule
