`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 15:56:03
// Design Name: 
// Module Name: mode_light_sim
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
`define CLK_PRIOD 1

module mode_light_sim();
reg[15:0] step_mode;
reg clk;
wire [3:0] seg_en;
wire [7:0] seg_out;

mode_light m1(step_mode,seg_en,clk,seg_out);

initial clk = 1;
always #(`CLK_PRIOD/2) clk = ~clk;

initial begin
step_mode = 16'b0000_0000_0000_0010;
#10 step_mode = 16'b0000_0000_0000_0100;
#10 step_mode = 16'b0000_0000_0000_1000;
#10 step_mode = 16'b0000_0000_0001_0000;
#10 step_mode = 16'b0000_0000_0010_0000;
#10 step_mode = 16'b0000_0000_0100_0000;
#10 step_mode = 16'b0000_0000_1000_0000;
#10 step_mode = 16'b0000_0010_0000_0000;
#10 step_mode = 16'b0000_0100_0000_0000;
#10 $finish();
end
endmodule
