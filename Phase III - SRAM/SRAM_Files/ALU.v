module ALU(in1, in2, SR_in, cmd, result, status);

  input [31:0] in1, in2;
  input [3:0] SR_in, cmd;

  output reg [31:0] result;
  output [3:0] status;

  wire neg_in, zer_in, cin, ov_in;
  wire neg, zer;
  reg ov, cout;

  assign {neg_in, zer_in, cin, ov_in} = SR_in;
  assign neg = result[31];
  assign zer = ~(|result);

  always @(in1, in2, cmd, SR_in)begin
    result = 32'bx;
    cout = cin;
    ov = ov_in;
    case(cmd)
      4'b0001: result = in2;
      4'b1001: result = ~in2;
      4'b0010: begin
 		 {cout, result} = in1 + in2;
		 ov = ((in1[31] & in2[31]) & ~result[31]) | ((~in1[31] & ~in2[31]) & result[31]);
	       end
      4'b0011: begin
		 {cout, result} = in1 + in2 + cin;
		 ov = ((in1[31] & in2[31]) & ~result[31]) | ((~in1[31] & ~in2[31]) & result[31]);
	       end
      4'b0100: begin
		 {cout, result} = in1 - in2;
		 ov = ((~in1[31] & in2[31]) & result[31]) | ((in1[31] & ~in2[31]) & ~result[31]);
	       end
      4'b0101: begin 
		 {cout, result} = in1 - in2 - {31'b0, ~cin};
		 ov = ((~in1[31] & in2[31]) & result[31]) | ((in1[31] & ~in2[31]) & ~result[31]);
	       end
      4'b0110: result = in1 & in2;
      4'b0111: result = in1 | in2;
      4'b1000: result = in1 ^ in2;
      default: result = 32'b0;
    endcase
  end

  assign status = {neg, zer, cout, ov};

endmodule
