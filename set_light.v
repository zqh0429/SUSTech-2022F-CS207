`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/23 14:26:22
// Design Name: 
// Module Name: set_light
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


module set_light(input rst_w,
                  input [15:0] set_state,
                  input clk,
                  input[3:0] sel,
                  input[3:0] thousand,hundred,ten,one,
                  input[1:0] mode,
                  output reg[3:0] seg_en1,seg_en2,
                  output reg [7:0] seg_out1,seg_out2);

parameter
RESTART = 3'b000,
RULE = 3'b001,
EXCEED = 3'b010,
INFO = 3'b011,
RESET = 3'b100;

reg[1:0] scan_cnt1 = 0;
reg[1:0] scan_cnt2 = 0;

parameter period = 200000;//500HZ
reg clkout       = 0;
reg[31:0]cnt;
always@(posedge clk)
begin
    if (cnt == (period>>1)-1) begin
        clkout = ~clkout;
        cnt <= 0;
    end
    else
        cnt <= cnt+1;
end

always@(posedge clkout)
begin
    if (scan_cnt1 == 2'b11)
        scan_cnt1 <= 0;
    else
        scan_cnt1 <= scan_cnt1+1;
end

always@(posedge clkout)
begin
    if (scan_cnt2 == 2'b11)
        scan_cnt2 <= 0;
    else
        scan_cnt2 <= scan_cnt2+1;
end

always@(scan_cnt1)
begin
    case(scan_cnt1)
        2'b00: seg_en1 = 4'b0001;
        2'b01: seg_en1 = 4'b0010;
        2'b10: seg_en1 = 4'b0100;
        2'b11: seg_en1 = 4'b1000;
    endcase
end

always@(scan_cnt2)
begin
    case(scan_cnt2)
        2'b00: seg_en2 = 4'b0001;
        2'b01: seg_en2 = 4'b0010;
        2'b10: seg_en2 = 4'b0100;
        2'b11: seg_en2 = 4'b1000;
    endcase
end

always@(scan_cnt1)
   begin
       if(scan_cnt1==0)begin
             case(set_state)
            RESTART:seg_out1=8'b0111_1110;
             RULE:seg_out1=8'b1111_1100;
             EXCEED:seg_out1=8'b0000_0000;
             INFO:seg_out1=8'b0000_0000;
             RESET:seg_out1=8'b0000_0000;
            default: seg_out1=8'b0000_0000;
            endcase
            end
          else if(scan_cnt1==1) begin
          case(set_state)
         RESTART:seg_out1=8'b0001_1110;
                      RULE:seg_out1=8'b1011_0110;
                      EXCEED:seg_out1=8'b0000_0000;
                      INFO:seg_out1=8'b0000_0000;
                      RESET:seg_out1=8'b0000_0000;
         default: seg_out1=8'b0000_0000;
         endcase
         end
         else if(scan_cnt1==2)begin
         case(set_state)
         RESTART:seg_out1=8'b1001_1100;
                     RULE:seg_out1=8'b1110_1100;
                     EXCEED:seg_out1=8'b0000_0000;
                     INFO:seg_out1=8'b0000_0000;
                     RESET:seg_out1=8'b0000_0000;
        default: seg_out1=8'b0000_0000;
        endcase
        end
        else if(scan_cnt1==3)begin
        case(set_state)
       RESTART:seg_out1=8'b1011_0110;
                    RULE:seg_out1=8'b0001_1100;
                    EXCEED:seg_out1=8'b0000_0000;
                    INFO:seg_out1=8'b0000_0000;
                    RESET:seg_out1=8'b0000_0000;
       default: seg_out1=8'b0000_0000;
       endcase
       end
   end
   
always@(scan_cnt2)
      begin
          if(scan_cnt2==0)begin
                case(set_state)
               RESTART:seg_out2=8'b0000_0000;
                RULE:seg_out2=8'b0000_0000;
                EXCEED:seg_out2=8'b0000_0000;
                INFO:seg_out2=8'b0000_0000;
                RESET:seg_out2=8'b0000_0000;
               default: seg_out2=8'b0000_0000;
               endcase
               end
             else if(scan_cnt1==1) begin
             case(set_state)
            RESTART:seg_out2=8'b0000_0000;
                         RULE:seg_out2=8'b0000_0000;
                         EXCEED:seg_out2=8'b0000_0000;
                         INFO:seg_out2=8'b0000_0000;
                         RESET:seg_out2=8'b0000_0000;
            default: seg_out1=8'b0000_0000;
            endcase
            end
            else if(scan_cnt2==2)begin
            case(set_state)
            RESTART:seg_out2=8'b0000_0000;
                        RULE:seg_out2=8'b0000_0000;
                        EXCEED:seg_out2=8'b0000_0000;
                        INFO:seg_out2=8'b0000_0000;
                        RESET:seg_out2=8'b0000_0000;
           default: seg_out1=8'b0000_0000;
           endcase
           end
           else if(scan_cnt2==3)begin
           case(set_state)
          RESTART:seg_out2=8'b0000_0000;
                       RULE:seg_out2=8'b0000_0000;
                       EXCEED:seg_out2=8'b0000_0000;
                       INFO:seg_out2=8'b0000_0000;
                       RESET:seg_out2=8'b0000_0000;
          default: seg_out2=8'b0000_0000;
          endcase
          end
      end
endmodule
