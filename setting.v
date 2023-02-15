`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 19:19:42
// Design Name: 
// Module Name: setting
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


module setting(
input clk,
//input def,
input[1:0] mode,
input p,
input[15:0] balance,
input[3:0] sel,
//input [15:0] value,
input [4:0] step_state,
input [15:0] price,
output reg state,
output[15:0] change,
input [4:0] lp,np,sp,dp,exceed
//output reg[15:0]  lp_d,np_d,sp_d,dp_d,exceed_d
//output lp_d,np_d,sp_d,dp_d,exceed_d
    );
    parameter
//set_state
    BEGIN = 5'd12,
    RULE = 5'd13,
    ADJUST = 5'd14,
    EXCEED = 5'd18,
    INFO = 5'd19,
    RESET = 5'd20;
//wire[15:0] lp_wire,np_wire,sp_wire,dp_wire;
//assign lp_wire = lp;

//    always @(*) begin
//    if(p)
//        case(mode)
//        2'b00: price = lp+exceed;
//        2'b01: price = np+exceed;
//        2'b10: price = sp+exceed;
//        2'b11: price = dp+exceed;
//        endcase
//        else
//        price = 16'd0;
//    end

     subn s1(balance,price,change);

     always @(*) begin
        if (balance == 16'd0)
            state = 0;
        else
            state = 1;
    end

endmodule
