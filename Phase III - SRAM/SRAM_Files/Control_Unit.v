module Control_Unit(mode, opcode, S, EXE_CMD, mem_read, mem_write, WB_en, branch, status, move);
  input [1:0] mode;
  input [3:0] opcode;
  input S;
  output reg [3:0] EXE_CMD;
  output reg mem_read, mem_write, WB_en, branch, status, move;

  always@(mode, opcode, S)begin
    {EXE_CMD, mem_read, mem_write, WB_en, branch, status, move} = 10'b0;
    case(mode)
      2'b00 : begin
                status = S;
	        case(opcode)
        	  4'b1101: {EXE_CMD, WB_en, move} = {4'b0001, 1'b1, 1'b1};
         	  4'b1111: {EXE_CMD, WB_en, move} = {4'b1001, 1'b1, 1'b1};
        	  4'b0100: {EXE_CMD, WB_en} = {4'b0010, 1'b1};
        	  4'b0101: {EXE_CMD, WB_en} = {4'b0011, 1'b1};
        	  4'b0010: {EXE_CMD, WB_en} = {4'b0100, 1'b1};
        	  4'b0110: {EXE_CMD, WB_en} = {4'b0101, 1'b1};
        	  4'b0000: {EXE_CMD, WB_en} = {4'b0110, 1'b1};
        	  4'b1100: {EXE_CMD, WB_en} = {4'b0111, 1'b1};
        	  4'b0001: {EXE_CMD, WB_en} = {4'b1000, 1'b1};
        	  4'b1010: EXE_CMD = 4'b0100;
        	  4'b1000: EXE_CMD = 4'b0110;
                endcase
              end
      2'b01 : begin
	        status = 0;
                if(opcode == 4'b0100)begin
		  case(S)
		    0 : {EXE_CMD, mem_write} = {4'b0010, 1'b1};
		    1 : {EXE_CMD, WB_en, mem_read} = {4'b0010, 1'b1, 1'b1};
		  endcase 
		end
	      end
      2'b10 : begin
		status = 1'b0;
		branch = 1'b1;
	      end
    endcase
  end
endmodule
