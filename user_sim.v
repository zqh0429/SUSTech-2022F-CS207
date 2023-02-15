`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 20:08:53
// Design Name: 
// Module Name: user_sim
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


module user_sim();
reg[2:0] id;
reg[15:0] price;
wire state;
wire[15:0] change;

user u1(id,price,state,change);

initial begin
id = 001; price = 15'd15;
#10
id = 010;
#10
id = 011;
#10
id = 111;
#10 $finish();
end
endmodule
