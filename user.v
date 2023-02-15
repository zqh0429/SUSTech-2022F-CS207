`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/13 20:27:10
// Design Name:
// Module Name: user
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


module user(input[2:0] id,
            // input[15:0] price,
            input [15:0] wash_state,
            output reg state,
            output[15:0] change);
    
    reg[15:0] balance;
    setting s1(wash_state,price);
    parameter//账户上限1000
    bal1 = 10'd0,
    bal2 = 10'd10,
    bal3 = 10'd100,
    bal4 = 10'd1000;
    
    always @(id) begin
        case(id)
            3'b001: balance  = bal1;
            3'b010: balance  = bal2;
            3'b011: balance  = bal3;
            default: balance = bal1;
        endcase
    end
    
    // ahead_adder a1()
    subn s1(balance,price,change);
    
    always @(*) begin
        if (balance == 15'd0 || balance<price)
            state = 0;
        else
            state = 1;
    end
    
    // always @(*) begin
    //     if (balance<price)
    //     begin
    //         state  = 0;
    //     end
    //     else
    //         state = 1;
    // end
    
endmodule
    
