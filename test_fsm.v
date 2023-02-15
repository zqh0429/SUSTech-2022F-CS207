`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/05 15:25:21
// Design Name: 
// Module Name: test_fsm
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


module test_fsm( 
clk,rst_n,
select,
btn,
en_light
);
input clk,rst_n;
input select;
input btn;
output reg[7:0] en_light;

reg[4:0] step_state,next_step_state;

parameter
RESTART = 5'd0;

always@(posedge clk or negedge rst_n) 
begin
   if(!rst_n)
    begin
        step_state <= RESTART;
    end
    else
    begin
        step_state <= next_step_state;
    end
end

always@(*) begin
case(step_state)

endcase
end

endmodule
