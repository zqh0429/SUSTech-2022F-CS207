`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/13 18:08:11
// Design Name:
// Module Name: mode_light
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


module mode_light(input rst_w,
                  input [5:0] step_state,
                  input clk,
                  input[3:0] sel,
                  input[3:0] hundred,ten,one,
                  input[15:0] lp,np,sp,dp,exceed,min,income,work_time,leave_time,
                  input[15:0] price,
                  input[15:0] change,
                  output reg [3:0] seg_en,
                  output [3:0] seg_en2,
                  output reg [7:0] seg_out,
                  output [7:0] seg_out2,
//                  input [2:0] step,
                  input [7:0] minute_wire,
                  input [7:0] second_wire,
                  input [3:0] second_p_wire
                  );
//wire [15:0]lp_d,np_d,sp_d,dp_d,exceed_d;

display_time d (
                      .rst(rst_w),
                      .clk(clk),
                      .i_minute(minute_wire),
                      .i_second(second_wire),
                      .i_second_p(second_p_wire),
//                      .i_step(step),
//                      .o_seg_n(seg_out1_wire),
                      .o_lsb(seg_out2),
//                      .en1(seg_en1_wire),
                      .en2(seg_en2)
                  );
//setting s1(.lp_d(lp_d),.np_d(np_d),.sp_d(sp_d),.dp_d(dp_d),.exceed_d(exceed_d));                  
wire[3:0] p_one,p_ten;
wire[3:0] c_one,c_ten;
wire[1:0] c_hun;
wire[3:0] lp_one,np_one,sp_one,dp_one,exceed_one,min_ten,min_one,income_one,work_one,leave_one,income_ten,work_ten,leave_ten;

reg rst_work;                 
bin_dec d1(.clk(clk),.bin(price),.rst_n(rst_w),.one(p_one),.ten(p_ten));//price
bin_dec d2(.clk(clk),.bin(change),.rst_n(rst_w),.one(c_one),.ten(c_ten),.hun(c_hun));//change
bin_dec d31(.clk(clk),.bin(lp),.rst_n(rst_w),.one(lp_one));//lp
bin_dec d32(.clk(clk),.bin(np),.rst_n(rst_w),.one(np_one));//np
bin_dec d33(.clk(clk),.bin(sp),.rst_n(rst_w),.one(sp_one));//sp
bin_dec d34(.clk(clk),.bin(dp),.rst_n(rst_w),.one(dp_one));//dp
bin_dec d4(.clk(clk),.bin(exceed),.rst_n(rst_w),.one(exceed_one));//exceed
bin_dec d5(.clk(clk),.bin(min),.rst_n(rst_w),.one(min_one),.ten(min_ten));//min
bin_dec d61(.clk(clk),.bin(income),.rst_n(rst_w),.one(income_one),.ten(income_ten));//income
bin_dec d62(.clk(clk),.bin(work_time),.rst_n(rst_w),.one(work_one),.ten(work_ten));//work_time
bin_dec d63(.clk(clk),.bin(leave_time),.rst_n(rst_w),.one(leave_one),.ten(leave_ten));//leave_time


parameter
    //step_state
RESTART = 6'd0,
OPEN = 6'd1,
CARD = 6'd2,
WASH = 6'd3,
UNCOVER = 6'd4,
WEIGHT = 6'd5,
COVER = 6'd6,
LEGAL = 6'd7,
WORK = 6'd8,
PAY = 6'd9,
PRICE = 6'd10,
CHECK = 6'd11,
SAVE = 6'd21,
//set_state
BEGIN = 6'd12,
RULE = 6'd13,
ADJUST = 6'd14,
INCOME_INFO = 6'd15,
WORK_INFO = 6'd16,
LEAVE_INFO = 6'd17,
EXCEED = 6'd18,
EXCEED_A = 6'd33,
INFO = 6'd19,
RESET = 6'd20,
SAVE_test = 6'd32,
CARD_test = 6'd22,
WASH_test = 6'd23,
UNCOVER_test = 6'd24,
WEIGHT_test = 6'd25,
COVER_test = 6'd26,
LEGAL_test = 6'd27,
WORK_test = 6'd28,
PAY_test = 6'd29,
PRICE_test = 6'd30,
CHECK_test = 6'd31;
reg[1:0] scan_cnt = 0;

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
    if (scan_cnt == 2'b11)
        scan_cnt <= 0;
    else
        scan_cnt <= scan_cnt+1;
end
always@(scan_cnt)
begin
    case(scan_cnt)
        2'b00: seg_en = 4'b0001;
        2'b01: seg_en = 4'b0010;
        2'b10: seg_en = 4'b0100;
        2'b11: seg_en = 4'b1000;
    endcase
end

always@(*)
begin
    if (scan_cnt == 0)begin
        case(step_state)
//            RESTART:seg_out = 8'b1110_1100;
            OPEN: seg_out = 8'b0110_1110;//seg_out = 8'b0111_1100;
            CARD :
            case(one)
                0: seg_out       = 8'b1111_1100;
                1: seg_out       = 8'b0110_0000;
                2: seg_out       = 8'b1101_1010;
                3: seg_out       = 8'b1111_0010;
                4: seg_out       = 8'b0110_0110;
                5: seg_out       = 8'b1011_0110;
                6: seg_out       = 8'b1011_1110;
                7: seg_out       = 8'b1110_0000;
                8: seg_out       = 8'b1111_1110;
                9: seg_out       = 8'b1111_0110;
                default: seg_out = 8'b0000_0000;
            endcase
            CARD_test:
             case(one)
                           0: seg_out       = 8'b1111_1100;
                           1: seg_out       = 8'b0110_0000;
                           2: seg_out       = 8'b1101_1010;
                           3: seg_out       = 8'b1111_0010;
                           4: seg_out       = 8'b0110_0110;
                           5: seg_out       = 8'b1011_0110;
                           6: seg_out       = 8'b1011_1110;
                           7: seg_out       = 8'b1110_0000;
                           8: seg_out       = 8'b1111_1110;
                           9: seg_out       = 8'b1111_0110;
                           default: seg_out = 8'b0000_0000;
                       endcase
            WASH : seg_out    = 8'b1111_1100;//D
            WASH_test:  seg_out    = 8'b1111_1100;//D
            UNCOVER : seg_out = 8'b1111_1100;
            UNCOVER_test:seg_out = 8'b1111_1100;
            WEIGHT :
            case(sel)
                4'b0001,4'b1011:seg_out = 8'b0110_0000;
                4'b0010,4'b1100:seg_out = 8'b1101_1010;
                4'b0011,4'b1101:seg_out = 8'b1111_0010;
                4'b0100,4'b1110:seg_out = 8'b0110_0110;
                4'b0101,4'b1111:seg_out = 8'b1011_0110;
                4'b0110:seg_out         = 8'b1011_1110;
                4'b0111:seg_out         = 8'b1110_0000;
                4'b1000:seg_out         = 8'b1111_1110;
                4'b1001:seg_out         = 8'b1110_0110;
                4'b1010:seg_out         = 8'b1111_1100;
                default:
                seg_out                           = 8'b1111_1100;
            endcase
            WEIGHT_test:
            case(sel)
                            4'b0001,4'b1011:seg_out = 8'b0110_0000;
                            4'b0010,4'b1100:seg_out = 8'b1101_1010;
                            4'b0011,4'b1101:seg_out = 8'b1111_0010;
                            4'b0100,4'b1110:seg_out = 8'b0110_0110;
                            4'b0101,4'b1111:seg_out = 8'b1011_0110;
                            4'b0110:seg_out         = 8'b1011_1110;
                            4'b0111:seg_out         = 8'b1110_0000;
                            4'b1000:seg_out         = 8'b1111_1110;
                            4'b1001:seg_out         = 8'b1110_0110;
                            4'b1010:seg_out         = 8'b1111_1100;
                            default:
                            seg_out                           = 8'b1111_1100;
                        endcase 
            COVER : seg_out  = 8'b1001_1110;
            COVER_test: seg_out  = 8'b1001_1110;
            LEGAL : seg_out  = 8'b1001_1110;
            LEGAL_test: seg_out  = 8'b1001_1110;
            WORK :  seg_out  = 8'b0000_1110;
            WORK_test: seg_out  = 8'b0000_1110;
            SAVE:  case(min_one)
                           4'b0000: seg_out       = 8'b1111_1100;
                           4'b0001: seg_out       = 8'b0110_0000;
                           4'b0010: seg_out       = 8'b1101_1010;
                           4'b0011: seg_out       = 8'b1111_0010;
                           4'b0100: seg_out       = 8'b0110_0110;
                           4'b0101: seg_out       = 8'b1011_0110;
                           4'b0110: seg_out       = 8'b1011_1110;
                           4'b0111: seg_out       = 8'b1110_0000;
                           4'b1000: seg_out       = 8'b1111_1110;
                           4'b1001: seg_out       = 8'b1111_0110;
                           default: seg_out       = 8'b0000_0000;
                       endcase
            SAVE_test:case(min_one)
                                                  4'b0000: seg_out       = 8'b1111_1100;
                                                  4'b0001: seg_out       = 8'b0110_0000;
                                                  4'b0010: seg_out       = 8'b1101_1010;
                                                  4'b0011: seg_out       = 8'b1111_0010;
                                                  4'b0100: seg_out       = 8'b0110_0110;
                                                  4'b0101: seg_out       = 8'b1011_0110;
                                                  4'b0110: seg_out       = 8'b1011_1110;
                                                  4'b0111: seg_out       = 8'b1110_0000;
                                                  4'b1000: seg_out       = 8'b1111_1110;
                                                  4'b1001: seg_out       = 8'b1111_0110;
                                                  default: seg_out       = 8'b0000_0000;
                                              endcase
            PAY : 
            case(p_one)
                4'b0000: seg_out       = 8'b1111_1100;
                4'b0001: seg_out       = 8'b0110_0000;
                4'b0010: seg_out       = 8'b1101_1010;
                4'b0011: seg_out       = 8'b1111_0010;
                4'b0100: seg_out       = 8'b0110_0110;
                4'b0101: seg_out       = 8'b1011_0110;
                4'b0110: seg_out       = 8'b1011_1110;
                4'b0111: seg_out       = 8'b1110_0000;
                4'b1000: seg_out       = 8'b1111_1110;
                4'b1001: seg_out       = 8'b1111_0110;
                default: seg_out       = 8'b0000_0000;
            endcase
            PAY_test:
            case(p_one)
                            4'b0000: seg_out       = 8'b1111_1100;
                            4'b0001: seg_out       = 8'b0110_0000;
                            4'b0010: seg_out       = 8'b1101_1010;
                            4'b0011: seg_out       = 8'b1111_0010;
                            4'b0100: seg_out       = 8'b0110_0110;
                            4'b0101: seg_out       = 8'b1011_0110;
                            4'b0110: seg_out       = 8'b1011_1110;
                            4'b0111: seg_out       = 8'b1110_0000;
                            4'b1000: seg_out       = 8'b1111_1110;
                            4'b1001: seg_out       = 8'b1111_0110;
                            default: seg_out       = 8'b0000_0000;
                        endcase
            PRICE: case(c_one)
                           4'b0000: seg_out       = 8'b1111_1100;
                           4'b0001: seg_out       = 8'b0110_0000;
                           4'b0010: seg_out       = 8'b1101_1010;
                           4'b0011: seg_out       = 8'b1111_0010;
                           4'b0100: seg_out       = 8'b0110_0110;
                           4'b0101: seg_out       = 8'b1011_0110;
                           4'b0110: seg_out       = 8'b1011_1110;
                           4'b0111: seg_out       = 8'b1110_0000;
                           4'b1000: seg_out       = 8'b1111_1110;
                           4'b1001: seg_out       = 8'b1111_0110;
                           default: seg_out       = 8'b0000_0000;
                       endcase
            PRICE_test: case(c_one)
                                                  4'b0000: seg_out       = 8'b1111_1100;
                                                  4'b0001: seg_out       = 8'b0110_0000;
                                                  4'b0010: seg_out       = 8'b1101_1010;
                                                  4'b0011: seg_out       = 8'b1111_0010;
                                                  4'b0100: seg_out       = 8'b0110_0110;
                                                  4'b0101: seg_out       = 8'b1011_0110;
                                                  4'b0110: seg_out       = 8'b1011_1110;
                                                  4'b0111: seg_out       = 8'b1110_0000;
                                                  4'b1000: seg_out       = 8'b1111_1110;
                                                  4'b1001: seg_out       = 8'b1111_0110;
                                                  default: seg_out       = 8'b0000_0000;
                                              endcase
            CHECK : seg_out  = 8'b0000_0000;
            CHECK_test: seg_out  = 8'b0000_0000;
            default: seg_out = 8'b0000_0000;
            BEGIN:seg_out=8'b0111_1100;
            RULE:seg_out=8'b1111_1100;
            ADJUST:
            case(sel)
            4'b1000: case(lp_one)0: seg_out       = 8'b1111_1100;
                                   1: seg_out       = 8'b0110_0000;
                                   2: seg_out       = 8'b1101_1010;
                                   3: seg_out       = 8'b1111_0010;
                                   4: seg_out       = 8'b0110_0110;
                                   5: seg_out       = 8'b1011_0110;
                                   6: seg_out       = 8'b1011_1110;
                                   7: seg_out       = 8'b1110_0000;
                                   8: seg_out       = 8'b1111_1110;
                                   9: seg_out       = 8'b1111_0110;
                                   default: seg_out = 8'b0000_0000;
                                   endcase
            4'b0100:case(np_one) 0: seg_out       = 8'b1111_1100;
                                   1: seg_out       = 8'b0110_0000;
                                   2: seg_out       = 8'b1101_1010;
                                   3: seg_out       = 8'b1111_0010;
                                   4: seg_out       = 8'b0110_0110;
                                   5: seg_out       = 8'b1011_0110;
                                   6: seg_out       = 8'b1011_1110;
                                   7: seg_out       = 8'b1110_0000;
                                   8: seg_out       = 8'b1111_1110;
                                   9: seg_out       = 8'b1111_0110;
                                   default: seg_out = 8'b0000_0000;
                                   endcase
            4'b0010:case(sp_one) 0: seg_out       = 8'b1111_1100;
                                   1: seg_out       = 8'b0110_0000;
                                   2: seg_out       = 8'b1101_1010;
                                   3: seg_out       = 8'b1111_0010;
                                   4: seg_out       = 8'b0110_0110;
                                   5: seg_out       = 8'b1011_0110;
                                   6: seg_out       = 8'b1011_1110;
                                   7: seg_out       = 8'b1110_0000;
                                   8: seg_out       = 8'b1111_1110;
                                   9: seg_out       = 8'b1111_0110;
                                   default: seg_out = 8'b0000_0000;
                                   endcase
            4'b0001:case(dp_one)
                        0: seg_out       = 8'b1111_1100;
                        1: seg_out       = 8'b0110_0000;
                        2: seg_out       = 8'b1101_1010;
                        3: seg_out       = 8'b1111_0010;
                        4: seg_out       = 8'b0110_0110;
                        5: seg_out       = 8'b1011_0110;
                        6: seg_out       = 8'b1011_1110;
                        7: seg_out       = 8'b1110_0000;
                        8: seg_out       = 8'b1111_1110;
                        9: seg_out       = 8'b1111_0110;
                        default: seg_out = 8'b0000_0000;
                        endcase
            default: seg_out = 8'b0000_0000;
                        endcase
            EXCEED: seg_out       = 8'b1001_1110;
            EXCEED_A:case(exceed_one)
                                                0: seg_out       = 8'b1111_1100;
                                                1: seg_out       = 8'b0110_0000;
                                                2: seg_out       = 8'b1101_1010;
                                                3: seg_out       = 8'b1111_0010;
                                                4: seg_out       = 8'b0110_0110;
                                                5: seg_out       = 8'b1011_0110;
                                                6: seg_out       = 8'b1011_1110;
                                                7: seg_out       = 8'b1110_0000;
                                                8: seg_out       = 8'b1111_1110;
                                                9: seg_out       = 8'b1111_0110;
                                                default: seg_out = 8'b0000_0000;
                                                endcase
            INCOME_INFO: case(income_one)
                                                                                     4'b0000: seg_out       = 8'b1111_1100;
                                                                                     4'b0001: seg_out       = 8'b0110_0000;
                                                                                     4'b0010: seg_out       = 8'b1101_1010;
                                                                                     4'b0011: seg_out       = 8'b1111_0010;
                                                                                     4'b0100: seg_out       = 8'b0110_0110;
                                                                                     4'b0101: seg_out       = 8'b1011_0110;
                                                                                     4'b0110: seg_out       = 8'b1011_1110;
                                                                                     4'b0111: seg_out       = 8'b1110_0000;
                                                                                     4'b1000: seg_out       = 8'b1111_1110;
                                                                                     4'b1001: seg_out       = 8'b1111_0110;
                                                                                     default: seg_out       = 8'b0000_0000;
                                                                                 endcase
                                                           WORK_INFO: case(work_one)
                                                                                                           4'b0000: seg_out       = 8'b1111_1100;
                                                                                                           4'b0001: seg_out       = 8'b0110_0000;
                                                                                                           4'b0010: seg_out       = 8'b1101_1010;
                                                                                                           4'b0011: seg_out       = 8'b1111_0010;
                                                                                                           4'b0100: seg_out       = 8'b0110_0110;
                                                                                                           4'b0101: seg_out       = 8'b1011_0110;
                                                                                                           4'b0110: seg_out       = 8'b1011_1110;
                                                                                                           4'b0111: seg_out       = 8'b1110_0000;
                                                                                                           4'b1000: seg_out       = 8'b1111_1110;
                                                                                                           4'b1001: seg_out       = 8'b1111_0110;
                                                                                                           default: seg_out       = 8'b0000_0000;
                                                                                                       endcase
                                                           LEAVE_INFO:  case(leave_one)
                                                                         4'b0000: seg_out       = 8'b1111_1100;
                                                                        4'b0001: seg_out       = 8'b0110_0000;
                                                                         4'b0010: seg_out       = 8'b1101_1010;
                                                                         4'b0011: seg_out       = 8'b1111_0010;
                                                                         4'b0100: seg_out       = 8'b0110_0110;
                                                                         4'b0101: seg_out       = 8'b1011_0110;
                                                                         4'b0110: seg_out       = 8'b1011_1110;
                                                                         4'b0111: seg_out       = 8'b1110_0000;
                                                                        4'b1000: seg_out       = 8'b1111_1110;
                                                                          4'b1001: seg_out       = 8'b1111_0110;
                                                                         default: seg_out       = 8'b0000_0000;
                                                                        endcase
            INFO:seg_out=8'b1111_1100;
            RESET:seg_out=8'b1001_1110;
        endcase
    end
    else if (scan_cnt == 1) begin
        case(step_state)
//            RESTART:seg_out = 8'b1001_1110;
            OPEN: seg_out = 8'b1011_0110;//seg_out = 8'b0001_1110;
            CARD :
            case(ten)
                0: seg_out       = 8'b1111_1100;
                1: seg_out       = 8'b0110_0000;
                2: seg_out       = 8'b1101_1010;
                3: seg_out       = 8'b1111_0010;
                4: seg_out       = 8'b0110_0110;
                5: seg_out       = 8'b1011_0110;
                6: seg_out       = 8'b1011_1110;
                7: seg_out       = 8'b1110_0000;
                8: seg_out       = 8'b1111_1110;
                9: seg_out       = 8'b1111_0110;
                default: seg_out = 8'b0000_0000;
            endcase
            CARD_test:
             case(ten)
                           0: seg_out       = 8'b1111_1100;
                           1: seg_out       = 8'b0110_0000;
                           2: seg_out       = 8'b1101_1010;
                           3: seg_out       = 8'b1111_0010;
                           4: seg_out       = 8'b0110_0110;
                           5: seg_out       = 8'b1011_0110;
                           6: seg_out       = 8'b1011_1110;
                           7: seg_out       = 8'b1110_0000;
                           8: seg_out       = 8'b1111_1110;
                           9: seg_out       = 8'b1111_0110;
                           default: seg_out = 8'b0000_0000;
                       endcase
            WASH : seg_out    = 8'b1011_0110;//S
            WASH_test: seg_out    = 8'b1011_0110;//S
            UNCOVER : seg_out = 8'b1001_1100;
            UNCOVER_test:seg_out = 8'b1001_1100;
            WEIGHT :
            case(sel)
                4'b1010,4'b1011,4'b1100,4'b1101,4'b1110,4'b1111:
                seg_out = 8'b0110_0000;
                4'b0001,4'b0010,4'b0011,4'b0100,4'b0101,4'b0110,4'b0111,4'b1000,4'b1001:
                seg_out = 8'b1111_1100;
                default:
                seg_out                   = 8'b1111_1100;
                //             0: seg_out = 8'b1111_1100;
                //             1: seg_out = 8'b0110_0000;
            endcase
            WEIGHT_test:
             case(sel)
                           4'b1010,4'b1011,4'b1100,4'b1101,4'b1110,4'b1111:
                           seg_out = 8'b0110_0000;
                           4'b0001,4'b0010,4'b0011,4'b0100,4'b0101,4'b0110,4'b0111,4'b1000,4'b1001:
                           seg_out = 8'b1111_1100;
                           default:
                           seg_out                   = 8'b1111_1100;
                           //             0: seg_out = 8'b1111_1100;
                           //             1: seg_out = 8'b0110_0000;
                       endcase
            COVER : seg_out  = 8'b0111_1100;
            COVER_test: seg_out  = 8'b0111_1100;
            LEGAL : seg_out  = 8'b0001_1110;
             LEGAL_test:seg_out  = 8'b0001_1110;
            WORK :seg_out  = 8'b1110_1110;
            WORK_test:seg_out  = 8'b1110_1110;
            SAVE:
             case(min_ten)
                           4'b0000: seg_out       = 8'b1111_1100;
                           4'b0001: seg_out       = 8'b0110_0000;
                           4'b0010: seg_out       = 8'b1101_1010;
                           4'b0011: seg_out       = 8'b1111_0010;
                           4'b0100: seg_out       = 8'b0110_0110;
                           4'b0101: seg_out       = 8'b1011_0110;
                           4'b0110: seg_out       = 8'b1011_1110;
                           4'b0111: seg_out       = 8'b1110_0000;
                           4'b1000: seg_out       = 8'b1111_1110;
                           4'b1001: seg_out       = 8'b1111_0110;
                           default: seg_out       = 8'b0000_0000;
                       endcase
            SAVE_test:
            case(min_ten)
                                       4'b0000: seg_out       = 8'b1111_1100;
                                       4'b0001: seg_out       = 8'b0110_0000;
                                       4'b0010: seg_out       = 8'b1101_1010;
                                       4'b0011: seg_out       = 8'b1111_0010;
                                       4'b0100: seg_out       = 8'b0110_0110;
                                       4'b0101: seg_out       = 8'b1011_0110;
                                       4'b0110: seg_out       = 8'b1011_1110;
                                       4'b0111: seg_out       = 8'b1110_0000;
                                       4'b1000: seg_out       = 8'b1111_1110;
                                       4'b1001: seg_out       = 8'b1111_0110;
                                       default: seg_out       = 8'b0000_0000;
                                   endcase
            PAY : 
            case(p_ten)
                4'b0000: seg_out       = 8'b1111_1100;
                4'b0001: seg_out       = 8'b0110_0000;
                4'b0010: seg_out       = 8'b1101_1010;
                4'b0011: seg_out       = 8'b1111_0010;
                4'b0100: seg_out       = 8'b0110_0110;
                4'b0101: seg_out       = 8'b1011_0110;
                4'b0110: seg_out       = 8'b1011_1110;
                4'b0111: seg_out       = 8'b1110_0000;
                4'b1000: seg_out       = 8'b1111_1110;
                4'b1001: seg_out       = 8'b1111_0110;
                default: seg_out       = 8'b0000_0000;
            endcase
             PAY_test:
              case(p_ten)
                            4'b0000: seg_out       = 8'b1111_1100;
                            4'b0001: seg_out       = 8'b0110_0000;
                            4'b0010: seg_out       = 8'b1101_1010;
                            4'b0011: seg_out       = 8'b1111_0010;
                            4'b0100: seg_out       = 8'b0110_0110;
                            4'b0101: seg_out       = 8'b1011_0110;
                            4'b0110: seg_out       = 8'b1011_1110;
                            4'b0111: seg_out       = 8'b1110_0000;
                            4'b1000: seg_out       = 8'b1111_1110;
                            4'b1001: seg_out       = 8'b1111_0110;
                            default: seg_out       = 8'b0000_0000;
                        endcase
            PRICE:  case(c_ten)
                           4'b0000: seg_out       = 8'b1111_1100;
                           4'b0001: seg_out       = 8'b0110_0000;
                           4'b0010: seg_out       = 8'b1101_1010;
                           4'b0011: seg_out       = 8'b1111_0010;
                           4'b0100: seg_out       = 8'b0110_0110;
                           4'b0101: seg_out       = 8'b1011_0110;
                           4'b0110: seg_out       = 8'b1011_1110;
                           4'b0111: seg_out       = 8'b1110_0000;
                           4'b1000: seg_out       = 8'b1111_1110;
                           4'b1001: seg_out       = 8'b1111_0110;
                           default: seg_out       = 8'b0000_0000;
                       endcase
            PRICE_test:case(c_ten)
                                                  4'b0000: seg_out       = 8'b1111_1100;
                                                  4'b0001: seg_out       = 8'b0110_0000;
                                                  4'b0010: seg_out       = 8'b1101_1010;
                                                  4'b0011: seg_out       = 8'b1111_0010;
                                                  4'b0100: seg_out       = 8'b0110_0110;
                                                  4'b0101: seg_out       = 8'b1011_0110;
                                                  4'b0110: seg_out       = 8'b1011_1110;
                                                  4'b0111: seg_out       = 8'b1110_0000;
                                                  4'b1000: seg_out       = 8'b1111_1110;
                                                  4'b1001: seg_out       = 8'b1111_0110;
                                                  default: seg_out       = 8'b0000_0000;
                                              endcase
            CHECK : seg_out  = 8'b1111_1100;
            CHECK_test:seg_out  = 8'b1111_1100;
            BEGIN:seg_out=8'b0001_1110;
            RULE:seg_out=8'b1011_0110;
            ADJUST: seg_out = 8'b0000_0000;
            EXCEED:seg_out = 8'b1001_1100;
            EXCEED_A:seg_out = 8'b0000_0000;
            INCOME_INFO: case(income_ten)
                                      4'b0000: seg_out       = 8'b1111_1100;
                                      4'b0001: seg_out       = 8'b0110_0000;
                                      4'b0010: seg_out       = 8'b1101_1010;
                                      4'b0011: seg_out       = 8'b1111_0010;
                                      4'b0100: seg_out       = 8'b0110_0110;
                                      4'b0101: seg_out       = 8'b1011_0110;
                                      4'b0110: seg_out       = 8'b1011_1110;
                                      4'b0111: seg_out       = 8'b1110_0000;
                                      4'b1000: seg_out       = 8'b1111_1110;
                                      4'b1001: seg_out       = 8'b1111_0110;
                                      default: seg_out       = 8'b0000_0000;
                                  endcase
            WORK_INFO: case(work_ten)
                                                            4'b0000: seg_out       = 8'b1111_1100;
                                                            4'b0001: seg_out       = 8'b0110_0000;
                                                            4'b0010: seg_out       = 8'b1101_1010;
                                                            4'b0011: seg_out       = 8'b1111_0010;
                                                            4'b0100: seg_out       = 8'b0110_0110;
                                                            4'b0101: seg_out       = 8'b1011_0110;
                                                            4'b0110: seg_out       = 8'b1011_1110;
                                                            4'b0111: seg_out       = 8'b1110_0000;
                                                            4'b1000: seg_out       = 8'b1111_1110;
                                                            4'b1001: seg_out       = 8'b1111_0110;
                                                            default: seg_out       = 8'b0000_0000;
                                                        endcase
            LEAVE_INFO:  case(leave_ten)
                          4'b0000: seg_out       = 8'b1111_1100;
                         4'b0001: seg_out       = 8'b0110_0000;
                          4'b0010: seg_out       = 8'b1101_1010;
                          4'b0011: seg_out       = 8'b1111_0010;
                          4'b0100: seg_out       = 8'b0110_0110;
                          4'b0101: seg_out       = 8'b1011_0110;
                          4'b0110: seg_out       = 8'b1011_1110;
                          4'b0111: seg_out       = 8'b1110_0000;
                         4'b1000: seg_out       = 8'b1111_1110;
                           4'b1001: seg_out       = 8'b1111_0110;
                          default: seg_out       = 8'b0000_0000;
                         endcase
            INFO:seg_out=8'b1000_1110;
            RESET:seg_out=8'b1011_0110;
            default: seg_out = 8'b0000_0000;
        endcase
    end
        else if (scan_cnt == 2)begin
        case(step_state)
//            RESTART:seg_out = 8'b1100_1110;
            OPEN: seg_out = 8'b1110_1110;//seg_out = 8'b1001_1110;
            CARD : seg_out = 8'b0001_0010;
            CARD_test:seg_out = 8'b0001_0010;
        WASH : seg_out    = 8'b1110_1100;//N
        WASH_test: seg_out    = 8'b1110_1100;//N
        UNCOVER : seg_out = 8'b1110_1100;
         UNCOVER_test: seg_out = 8'b1110_1100;
        WEIGHT : seg_out  = 8'b0001_0010;//  = 
        WEIGHT_test:seg_out  = 8'b0001_0010;//  = 
        COVER : seg_out   = 8'b1111_1100;
         COVER_test: seg_out   = 8'b1111_1100;
        LEGAL : seg_out   = 8'b1110_1100;
         LEGAL_test:seg_out   = 8'b1110_1100;
        WORK : seg_out    = 8'b1111_1100;
         WORK_test: seg_out    = 8'b1111_1100;
        SAVE : seg_out   = 8'b0001_0010;
        SAVE_test:seg_out   = 8'b0001_0010;
        PAY : seg_out   = 8'b0001_0010;
        PAY_test:seg_out   = 8'b0001_0010;
        PRICE: seg_out   = 8'b0001_0010;
         PRICE_test:seg_out   = 8'b0001_0010;
        CHECK : seg_out   = 8'b1110_1100;
        CHECK_test:seg_out   = 8'b1110_1100;
        BEGIN:seg_out=8'b1001_1110;
        RULE:seg_out=8'b1110_1100;
        ADJUST:seg_out=8'b0001_0010;
        EXCEED:seg_out = 8'b0110_1110;
        EXCEED_A:seg_out=8'b0001_0010;
        INCOME_INFO:seg_out=8'b0001_0010;
        WORK_INFO:seg_out=8'b0001_0010;
        LEAVE_INFO:seg_out=8'b0001_0010;
        INFO:seg_out=8'b1110_1100;
        RESET:seg_out=8'b1001_1110;
        default: seg_out  = 8'b0000_0000;
        endcase
        end
        else if (scan_cnt == 3)begin
        case(step_state)
//            RESTART:seg_out = 8'b1111_1100;
            OPEN: seg_out = 8'b0111_1110;//seg_out = 8'b1011_0110;
            CARD : seg_out = 8'b1001_1100;
            CARD_test:seg_out = 8'b1001_1100;
        WASH : seg_out    = 8'b0001_1100;//L
        WASH_test: seg_out    = 8'b0001_1100;//L
        UNCOVER : seg_out = 8'b0111_1100;
        UNCOVER_test: seg_out = 8'b0111_1100; 
        WEIGHT : seg_out  = 8'b0111_1110;
        WEIGHT_test:seg_out  = 8'b0111_1110;
        COVER : seg_out   = 8'b1001_1100;
        COVER_test: seg_out   = 8'b1001_1100;
        LEGAL : seg_out   = 8'b1001_1110;//enter
         LEGAL_test:seg_out   = 8'b1001_1110;//enter
        WORK : seg_out    = 8'b0111_1110;
         WORK_test:  seg_out    = 8'b0111_1110;
        SAVE: seg_out   = 8'b0001_1110;
        SAVE_test:seg_out   = 8'b0001_1110;
        PAY : seg_out   = 8'b1100_1110;//pay
        PAY_test:seg_out   = 8'b1100_1110;
        PRICE: seg_out = 8'b1001_1100;
        PRICE_test:seg_out = 8'b1001_1100;
        CHECK : seg_out   = 8'b1001_1110;//end
         CHECK_test:seg_out   = 8'b1001_1110;//end
          BEGIN:seg_out=8'b1011_0110;
            RULE:seg_out=8'b0001_1100;
            ADJUST:
            case(sel)
            4'b1000:seg_out=8'b0001_1100;
            4'b0100:seg_out=8'b1110_1100;
            4'b0010:seg_out=8'b1011_0110;
            4'b0001:seg_out=8'b1111_1100;
            default:seg_out=8'b0000_0000;
            endcase
            EXCEED:seg_out=8'b1001_1110;
            EXCEED_A:seg_out=8'b1001_1110;
            INCOME_INFO:seg_out=8'b0000_1100;
            WORK_INFO :seg_out=8'b0111_1110;
            LEAVE_INFO :seg_out=8'b0001_1100;
            INFO:seg_out=8'b0000_1100;
            RESET:seg_out=8'b1110_1110;
        default: seg_out  = 8'b0000_0000;
        endcase
        end
        end
        endmodule
        