`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/16 13:55:16
// Design Name: 
// Module Name: alert_sim
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


module alert_sim( );
reg clk,rst,key,en;
wire buzzer;
alert u1(clk,rst,key,buzzer);
initial begin
clk = 1'b0;rst = 1'b0;key = 1'b0;en = 1'b0;
#10 rst = 1'b1;
#10 en = 1'b1;
repeat(100)  #10 clk = ~clk;
end
endmodule
 