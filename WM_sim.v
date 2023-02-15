`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/21 15:51:29
// Design Name: 
// Module Name: WM_sim
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


module WM_sim( );
reg clk, rst_n; 
reg i_start_n;
reg i_water_full_n;
reg mode;
reg choose_song;
wire [7:0] o_seg_n;
wire [7:0] o_lsb;
wire [1:0] en;
wire buzzer;
wire done;

washingmachine_top u1(clk, rst_n, i_start_n,i_water_full_n,mode,choose_song,o_seg_n,o_lsb,en,
buzzer,done);

initial begin
clk = 1'b0;rst_n = 1'b0; i_start_n = 1'b0;i_water_full_n = 1'b0;mode = 1'b0;
choose_song = 1'b0;
#10 rst_n = 1'b1;mode = 1'b1;
repeat(1000) #1 clk = ~clk;
#10 choose_song = 1'b1;
repeat(1000) #1 clk = ~clk;
#10 $finish;
end
endmodule
