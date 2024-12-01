module status_register(clk, rst, S, SR_in, SR);

  input clk, rst;
  input S;
  input [3:0] SR_in;
  output reg [3:0] SR;

  always@(negedge clk, posedge rst)begin
    if(rst)
      SR <= 4'b0;
    else if(S)
      SR <= SR_in;
  end

endmodule