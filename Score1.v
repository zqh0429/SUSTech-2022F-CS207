`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/08/02 17:24:36
// Design Name: 
// Module Name: Score
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


module Score(
input clk,
output reg [3:0]seg_en,
output reg [7:0] seg_out
    );
reg[1:0] scan_cnt=0;
wire [3:0] thousand,hundred,ten,one;

reg[11:0] score=12'd 1234;

assign thousand=score/1000;
assign hundred=score/100%10;
assign ten=score/10%10;
assign one=score%10;
parameter period=200000;//500HZ
reg clkout=0;
reg[31:0]cnt;

 always@(posedge clk )
 begin 
           if(cnt==(period>>1)-1) begin
                clkout=~clkout;
                cnt<=0;
                end
                else
                   cnt<=cnt+1;
           end
 
 always@(posedge clkout)
             begin
                  if(scan_cnt==2'b11)
                       scan_cnt<=0;
                   else
                       scan_cnt<=scan_cnt+1;
             end
always@(scan_cnt)
                  begin 
                      case(scan_cnt)
                        2'b00: seg_en=4'b0001;
                        2'b01: seg_en=4'b0010;
                        2'b10: seg_en=4'b0100;
                        2'b11: seg_en=4'b1000;
                      endcase
                   end
always@(scan_cnt)
   begin
       if(scan_cnt==0)begin
             case(one)
             0: seg_out=8'b1111_1100;
             1: seg_out=8'b0110_0000;
             2: seg_out=8'b1101_1010;
             3: seg_out=8'b1111_0010;
             4: seg_out=8'b0110_0110;
             5: seg_out=8'b1011_0110;
             6: seg_out=8'b1011_1110;
             7: seg_out=8'b1110_0000;
             8: seg_out=8'b1111_1110;
             9: seg_out=8'b1110_0110;
            default: seg_out=8'b0000_0000;
            endcase
            end
          else if(scan_cnt==1) begin
          case(ten)
          0: seg_out=8'b1111_1100;
          1: seg_out=8'b0110_0000;
          2: seg_out=8'b1101_1010;
          3: seg_out=8'b1111_0010;
          4: seg_out=8'b0110_0110;
          5: seg_out=8'b1011_0110;
          6: seg_out=8'b1011_1110;
          7: seg_out=8'b1110_0000;
          8: seg_out=8'b1111_1110;
          9: seg_out=8'b1110_0110;
         default: seg_out=8'b0000_0000;
         endcase
         end
         else if(scan_cnt==2)begin
         case(hundred)
         0: seg_out=8'b1111_1100;
         1: seg_out=8'b0110_0000;
         2: seg_out=8'b1101_1010;
         3: seg_out=8'b1111_0010;
         4: seg_out=8'b0110_0110;
         5: seg_out=8'b1011_0110;
         6: seg_out=8'b1011_1110;
         7: seg_out=8'b1110_0000;
         8: seg_out=8'b1111_1110;
         9: seg_out=8'b1110_0110;
        default: seg_out=8'b0000_0000;
        endcase
        end
        else if(scan_cnt==3)begin
        case(thousand)
        0: seg_out=8'b1111_1100;
        1: seg_out=8'b0110_0000;
        2: seg_out=8'b1101_1010;
        3: seg_out=8'b1111_0010;
        4: seg_out=8'b0110_0110;
        5: seg_out=8'b1011_0110;
        6: seg_out=8'b1011_1110;
        7: seg_out=8'b1110_0000;
        8: seg_out=8'b1111_1110;
        9: seg_out=8'b1110_0110;
       default: seg_out=8'b0000_0000;
       endcase
       end
   end      
endmodule
