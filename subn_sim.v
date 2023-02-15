`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 19:56:29
// Design Name: 
// Module Name: subn_sim
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


module subn_sim();
reg[15:0] a,b;
wire [15:0] d;
wire cin;

subn s1(a,b,d,c);

initial begin
    a = 16'd200;b = 16'd100;
end
endmodule
