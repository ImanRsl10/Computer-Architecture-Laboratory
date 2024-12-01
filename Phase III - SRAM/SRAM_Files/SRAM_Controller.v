module SRAM_Controller (clk, rst, writeEn, readEn, address, WriteData, ReadData, ready, SRAM_DQ, SRAM_ADDR, 
			 SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N);
    input clk, rst;
    input writeEn, readEn;
    input [31:0] address, WriteData;

    output [31:0] ReadData;

    output ready;
    inout [15:0] SRAM_DQ;
    output reg [17:0] SRAM_ADDR;

    output  SRAM_UB_N;         //SRAM high byte Data Mask
    output  SRAM_LB_N;         // SRAM low byte Data Mask
    output reg SRAM_WE_N;         // SRAM write Enable
    output  SRAM_CE_N;         // SRAM chip Enable
    output  SRAM_OE_N;         // SRAM output ENable

    parameter [3:0] Idle = 0, write1 = 1, write2 = 2, read1 = 3, read2 = 4, read3 = 5, wait1 = 6, wait2 = 7;

    reg [3:0] ns, ps;
    reg [15:0] readLSB, readMSB;
	
    assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0000;

    always @* begin : next_state
        ns = Idle;
        case (ps)
            Idle: begin
                if (~writeEn & ~readEn)
                    ns = Idle;
                else if (writeEn)
                    ns = write1;
                else
                    ns = read1;
            end
            write1: ns = write2;
            write2: ns = wait1;
            read1: ns = read2;
            read2: ns = read3;
            read3: ns = wait1;
            wait1: ns = wait2;
            wait2: ns = Idle;
        endcase
    end

    always @(ps) begin : signals
        SRAM_ADDR = 18'b0; SRAM_WE_N = 1'b1;
        case (ps)
            write1: begin
                SRAM_ADDR = address[17:0] >> 1;
                SRAM_WE_N = 1'b0;
            end
            write2: begin
                SRAM_ADDR = (address[17:0] >> 1) + 1;
                SRAM_WE_N = 1'b0;
            end
            read1: begin
                SRAM_ADDR = address[17:0] >> 1;
            end
            read2: begin
                SRAM_ADDR = (address[17:0] >> 1) + 1;
                readLSB = SRAM_DQ;
            end
            read3: begin
                readMSB = SRAM_DQ;
            end
        endcase
    end

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= Idle;
        else
            ps <= ns;
    end

    assign SRAM_DQ = (ps == write1) ? WriteData[15:0] :
                     (ps == write2) ? WriteData[31:16] : 16'bz;
                
    assign ready = (ns == Idle) ? 1'b1 : 1'b0;

    assign ReadData = (ps == wait2) ? {readMSB, readLSB} : 32'bz;

endmodule