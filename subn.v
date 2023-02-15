`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 19:55:59
// Design Name: 
// Module Name: subn
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module subn(x, y, d,cin);
  parameter n=16;

  input [n-1:0] x;
  input [n-1:0] y;
  output reg[n-1:0] d; //diff
  output reg cin; //borrow from high bit
  reg [n:0] c;
  integer k;

  always @(x,y) begin
    c[0] = 1'b0;
	 for(k = 0; k < n; k = k + 1) begin
	   d[k] = x[k]^y[k]^c[k];
		c[k+1] = (~x[k]&(y[k]^c[k]))|(y[k]&c[k]);
	 end
	 cin = c[n];

  end

endmodule
