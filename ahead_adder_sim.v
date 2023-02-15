`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 19:45:03
// Design Name: 
// Module Name: ahead_adder_sim
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


module ahead_adder_sim();
reg [15:0] a,b;
reg cin;
wire [15:0] s;
wire cout;

ahead_adder a1(a,b,cin,s,cout);

initial begin
#10 a = 15'd10; b = 15'd20; cin = 15'd0;
#10 $finish();
end
endmodule
