`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/23 10:45:31
// Design Name: 
// Module Name: Administrator
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


module Administrator(
input clk,rst_s,a,b,
input[3:0] sel,
output reg set_check

    );
     reg[2:0]set_state;
     reg[2:0]next_set_state;
     reg[1:0] mode;
    parameter
    RESTART = 3'b000,
    OPEN = 3'b001,
    RULE = 3'b010,
    EXCEED = 3'b011,
    INFO = 3'b100,
    RESET = 3'b101,
        //wash_state
    LARGE =2'b00,
    MIDDLE =2'b01, 
    SMALL = 2'b10,
    DRY = 2'b11;
    
    always@(posedge clk or negedge rst_s) 
        begin
           if(!rst_s)
            begin
                set_state <= RESTART;
                set_check <= 1'b0;
            end
            else
            begin
                set_state <= next_set_state;
                set_check <= 1'b1;
            end
        end
        
     always@(*)
     begin
     case(set_state)
     RESTART: next_set_state = OPEN;
     
    OPEN:
          if(a)
          next_set_state = RULE;
          else
          next_set_state = OPEN;
     
     RULE:
      if (b) begin
                        case(sel)
                           4'b1000: begin
                           mode = LARGE;
                           next_set_state = EXCEED;
                           end
                           4'b0100: begin
                           mode = MIDDLE;
                           next_set_state = EXCEED;
                           end
                           4'b0010: begin
                           mode = SMALL;
                           next_set_state = EXCEED;
                           end
                           4'b0001: begin
                           mode = DRY;
                           next_set_state = EXCEED;
                           end
                           default:next_set_state = RULE;
                           endcase
                           end
                    else next_set_state = RULE;
     
     EXCEED:
     if(a)
     next_set_state = INFO;
     else
     next_set_state = EXCEED;
     
     INFO:
     if(b)
     next_set_state = RESET;
     else
     next_set_state = INFO;
     
     RESET:
     if(a)
     next_set_state =OPEN;
     else
     next_set_state = RESET;
     
     endcase
     end
endmodule
