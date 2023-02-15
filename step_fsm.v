`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/12/12 20:06:27
// Design Name:
// Module Name: step_fsm
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


module step_fsm(clk,
                rst_n,select,
                rst_bt1,rst_bt2,rst_bt3,rst_bt4,rst_bt5,
//                rst_bt6,
                btn1,btn2,
                a_key,b_key,c,
                sel,open,childlock,
//                work_check,
                open_lid,
                test,next_key,
                seg_out1,seg_out2,
                seg_en1,seg_en2,
                large_light,normal_light,small_light,dry_light,
                choose_song,fault,buzzer,en_light,
                work_light,default_fee
                );
    input clk,rst_n,select;
    input rst_bt1,rst_bt2,rst_bt3,rst_bt4,rst_bt5,btn1,btn2;
    input a_key,b_key,c,next_key;
    input[3:0] sel;
    input open;
    input choose_song,fault;
    input test;
    input childlock;
    
    output reg open_lid;
    output [7:0] seg_out1,seg_out2;
    output [3:0] seg_en1,seg_en2; 
    output reg large_light,normal_light,small_light,dry_light;
    output buzzer;
    output [7:0] en_light;
    output reg work_light;
    output reg default_fee;
    //info
    reg[15:0] income= 16'd0;
    reg[15:0] work_time= 16'd0;
    reg[15:0] leave_time= 16'd0;
//    wire[15:0] income,work_time,leave_time;
    wire a,b,next;
    //counter
    wire[4:0] bps;
    reg ch;
    reg save,leave;
    reg[15:0] min;
   //state
    reg[5:0] next_step_state;
    reg[3:0] mode;  reg l,p;
    reg[5:0] step_state;
    reg[4:0] step_state_test;
    reg[4:0] next_step_state_test;
    reg en_alert_flag;
    //button
   wire[4:0]hundred,ten,one;
   wire[4:0] lp_wire,np_wire,sp_wire,dp_wire,exceed_wire;
   wire[4:0] lp,np,sp,dp,exceed;
//   assign lp_wire = lp[4:0];
//   assign np_wire = np[4:0];
//   assign sp_wire = sp[4:0];
//   assign dp_wire = dp[4:0];
//   assign exceed_wire = exceed[4:0];
   reg isw,iss;
    btncounter b0(clk,sel[3],btn1,btn2,lp);
    btncounter b1(clk,sel[2],btn1,btn2,np);
    btncounter b3(clk,rst_bt1,btn1,btn2,ten);
    btncounter b4(clk,rst_bt2,btn1,btn2,one);
    btncounter b5(clk,sel[1],btn1,btn2,sp);
    btncounter b6(clk,sel[0],btn1,btn2,dp);
    btncounter b7(clk,c,btn1,btn2,exceed); 
    //setting
//    input[15:0] balance;
    reg[15:0] balance;
//    output [15:0] price;
    reg [15:0]price;
    wire state;
//    output [15:0] change;
    wire[15:0] change;

    setting u4(clk,mode,p,balance,sel,step_state,price,state,change,lp,np,sp,dp,exceed);
    counter u5(clk,save,bps);

//    input work_finish;
    wire work_finish_wire;
    reg work_finish; 
    assign work_finish_wire = work_finish;
    reg i_start_n;
    reg test_flag;
    reg childlock_flag;
//    wire [2:0] step;
    wire [7:0] minute_wire;
    wire [7:0] second_wire;
    wire [3:0] second_p_wire;
//    output light;
    reg work_begin;
    reg en_alert;
    washingmachine_top u0(.clk(clk),.rst_n(work_begin), .i_start_n(i_start_n),  .mode(mode),.done(work_finish_wire),.next(next),.test(test_flag),
        .fault(fault), .en_light(en_light), .minute_wire(minute_wire),.second_wire(second_wire),.second_p_wire(second_p_wire)); 
        
     mode_light u1(rst_n,step_state,clk,sel,hundred,ten,one,lp,np,sp,dp,exceed,min,income,work_time,leave_time,price,change,
     seg_en1,seg_en2,seg_out1,seg_out2 ,minute_wire,second_wire,second_p_wire);
    alert a1(clk,en_alert,choose_song,buzzer);
    debounce_button d1(clk,rst_n,a_key,a);
    debounce_button d2(clk,rst_n,b_key,b);
    //next
    debounce_button d3(clk,rst_n,next_key,next);
    //adder
//    ahead_adder aa1(.A(income_d),.B(price),.S(income));
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
    
    //wash_state
    LARGE =4'b0001,
    MIDDLE =4'b0010, 
    SMALL = 4'b0100,
    DRY = 4'b1000;
    
    parameter    
    //step_state
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
    
always@(*)begin
if((min > 16'd0 && min < 16'd2) || (min > 16'd22 && min < 16'd24) ||en_alert_flag) en_alert = 1;
else en_alert = 0;
end

always@(*)begin
if(test) test_flag = 1;
else test_flag = 0;
end

always@(*)begin
if(childlock) childlock_flag = 1;
else childlock_flag = 0;
end

    always@(posedge clk or negedge rst_n) 
    begin
       if(!rst_n)
        begin
            step_state <= RESTART;
//            min <= 16'd0;
//            work_check <= 1'b0;
//            work_begin <= 1'b0;
//            i_start_n <= 1'b0;
//            mode <= 4'b0;
        end
        else
        begin
            step_state <= next_step_state;
//            work_check <= 1'b1;
        end
    end
    
    always@(posedge bps or negedge save) 
    begin
       if(!save) min<=0;
       else
        begin
        if(!leave)
            if(min!=16'd24)
            min<=min+16'd1;
            else
            min<=min;
        else min<=min;
        end
    end
    
    always@(*)
    begin
        case(step_state)
        RESTART:next_step_state = OPEN;
                    
            OPEN:begin
            open_lid = 0;
            if(childlock_flag) begin
                en_alert_flag = 0;
                work_begin = 0;
                save = 0;
                if(select) begin
                  if(test_flag) next_step_state = CARD_test;
                  else next_step_state = BEGIN;
                end
                else if (a)begin
                 next_step_state = CARD;
                 end
                else next_step_state   = OPEN;
            end
            end
            
            CARD:begin
            open_lid = 0;
                        if(childlock_flag) begin
                if (b&&state) begin
             
                next_step_state = WASH;
                end
                else if(b&&!state) next_step_state= OPEN;
                else next_step_state   = CARD;
            end
            end
            
            WASH: begin
            open_lid = 1;
                        if(childlock_flag) begin
                if (c) begin
                    case(sel)
                       4'b1000: begin
                       mode = LARGE;
                       next_step_state = UNCOVER;
                       large_light = 1;
                       normal_light = 0;
                       small_light = 0;
                       dry_light = 0;
                       end
                       4'b0100: begin
                       mode = MIDDLE;
                       next_step_state = UNCOVER;
                       large_light = 0;
                       normal_light = 1;
                       small_light = 0;
                       dry_light = 0;
                       end
                       4'b0010: begin
                       mode = SMALL;
                       next_step_state = UNCOVER;
                       large_light = 0;
                       normal_light = 0;
                       small_light = 1;
                       dry_light = 0;
                       end
                       4'b0001: begin
                       mode = DRY;
                       next_step_state = UNCOVER;
                       large_light = 0;
                       normal_light = 0;
                       small_light = 0;
                       dry_light = 1;
                       end
                       default:next_step_state = WASH;
                       endcase
                       end
                else next_step_state = WASH;
            end
            end
            
            UNCOVER:begin
             open_lid = 1;
                        if(childlock_flag) begin

                if (open) next_step_state = WEIGHT;
                else next_step_state   = UNCOVER;
            end
            end
            
            WEIGHT:begin
            open_lid = 1;
                        if(childlock_flag) begin

                if (b)  begin
//                               work_light = 1;

                    case(mode)
                        LARGE:begin
                            case(sel)
                                4'b1011,4'b1100,4'b1101,4'b1110,4'b1111:
                                begin
                                    l = 1;
                                    next_step_state = COVER;
                                end
                                default:
                                next_step_state = WASH;
                            endcase
                        end
                        
                        MIDDLE:begin
                            case(sel)
                                4'b0110,4'b0111,4'b1000,4'b1001,4'b1010:
                                begin
                                    l = 1;
                                    next_step_state = COVER;
                                end
                                default:
                                    next_step_state = WASH;
                            endcase
                        end
                        
                        SMALL:begin
                            case(sel)
                                4'b0001,4'b0010,4'b0011,4'b0100,4'b0101:
                                begin
                                    l = 1;
                                    next_step_state = COVER;
                                end
                                default:
                                next_step_state = WASH;
                            endcase
                        end
                        
                        DRY:begin
                        l = 1;
                        next_step_state = COVER;
                        end
                        
                        default:next_step_state = WEIGHT;
                    endcase
                end
                else next_step_state = WEIGHT;
            end
            end
            
            COVER:begin 
            open_lid = 1;
                        if(childlock_flag) begin

                if (open) begin
//               work_light = 1;
               next_step_state = LEGAL;
                end
                else next_step_state  = COVER;
            end
            end
            
            LEGAL:begin
            open_lid =0; //°´È·¶¨
                        if(childlock_flag) begin

                if (b&&l==1)begin
//                work_begin = 1;
//                work_light = 1;
//                open_lid = 0; 
                next_step_state = WORK;
//                l = 0;
                end
                else next_step_state  = LEGAL;
             end
             end
            
            WORK:begin
            open_lid = 0;
                        if(childlock_flag) begin

            work_begin = 1;
            work_light = 1;
            leave = 0;
             save = 0;
             if(open || select) en_alert_flag = 1;
             else en_alert_flag = 0;
                if (work_finish)
                begin
                p = 1;
                en_alert_flag = 1;
//                open_lid = 1;
               
                next_step_state = SAVE;
                end
                else next_step_state = WORK;
            end
            end
            
            SAVE:begin
            open_lid = 0;
             save=1;
                        if(childlock_flag) begin
            en_alert_flag = 0;
            work_begin = 0;
//            income = income + price;
//            leave_time = leave_time + min;
            if(a) 
            next_step_state = PAY;
            else
            next_step_state = SAVE;
            end
            end

            PAY:begin
            leave = 1;
            save = 1;
           open_lid = 0;
                        if(childlock_flag) begin
                         
                if (b) begin
                
                en_alert_flag = 0;
                work_begin = 0;
                open_lid = 1;
                next_step_state = PRICE;
                end
                else next_step_state = PAY;
            end
            end
            
             PRICE:begin
             leave = 1;
                         save = 1;
             open_lid = 1;
                         if(childlock_flag) begin
                       
                if (a) begin
                income = price;
                leave_time =  min;
              
                work_begin = 0;
                large_light = 0;
                normal_light = 0;
                small_light = 0;
                dry_light = 0;
                next_step_state = CHECK;
                case(mode)
                LARGE: work_time = 16'd31;
                MIDDLE: work_time = 16'd20;
                SMALL: work_time = 16'd15;
                DRY: work_time = 16'd13;
                endcase
                end
                else next_step_state = PRICE;
            end
            end
            
            CHECK:begin
            open_lid = 1;
                        if(childlock_flag) begin
                if (b) begin
//                leave = 2'b00;
                next_step_state = OPEN;
                end
                else next_step_state = CHECK;
            end
            end
            
             BEGIN:begin
             work_begin = 0;
                         if(childlock_flag) begin

             if(!select)
             next_step_state = OPEN;
             else begin
                if(test_flag) next_step_state = CARD_test;
                 else if(b) next_step_state = RULE;
                  else next_step_state = BEGIN;
                   end
                   end
             end
                  
            CARD_test:begin
             if(next)begin
              
              next_step_state = WASH_test;
              end
             else next_step_state = CARD_test;
            end
            
            WASH_test:begin
//            open_lid = 1;
              if (next) begin
                case(sel)
                   4'b1000: begin
                   mode = LARGE;
                   next_step_state = UNCOVER_test;
                   large_light = 1;
                   normal_light = 0;
                   small_light = 0;
                   dry_light = 0;
                   end
                   4'b0100: begin
                   mode = MIDDLE;
                   next_step_state = UNCOVER_test;
                   large_light = 0;
                   normal_light = 1;
                   small_light = 0;
                   dry_light = 0;
                   end
                   4'b0010: begin
                   mode = SMALL;
                   next_step_state = UNCOVER_test;
                   large_light = 0;
                   normal_light = 0;
                   small_light = 1;
                   dry_light = 0;
                   end
                   4'b0001: begin
                   mode = DRY;
                   next_step_state = UNCOVER_test;
                   large_light = 0;
                   normal_light = 0;
                   small_light = 0;
                   dry_light = 1;
                   end
                   default:next_step_state = WASH_test;
                   endcase
                   end
            else next_step_state = WASH_test;
        end
        
          UNCOVER_test:begin
          open_lid = 1;
            if (next) next_step_state = COVER_test;
            else next_step_state   = UNCOVER_test;
        end
        
        COVER_test:begin 
            if (next) begin
//               work_light = 1;
           next_step_state = WORK_test;
            end
            else next_step_state  = COVER_test;
        end
        
        WORK_test:begin
        open_lid = 0;
        work_begin = 1;
        work_light = 1;
         save=0;
            if (work_finish)
            begin
            p = 1;
            en_alert_flag = 1;
//            open_lid = 1;
           
            next_step_state = SAVE_test;
            end
            else next_step_state = WORK_test;
        end
        
        SAVE_test:begin
        save=1;leave=0;
        en_alert_flag = 0;
        work_begin = 0;
//        income = income + balance;
//        leave_time = leave_time + min;
        if(next)
        next_step_state = PAY_test;
        else
        next_step_state = SAVE_test;
        end

        PAY_test:begin
            if (next) begin
            leave=1;
            en_alert_flag = 0;
            work_begin = 0; 
            open_lid = 1;
            next_step_state = PRICE_test;
            end
            else next_step_state = PAY_test;
        end
        
         PRICE_test:begin
            if (next) begin
            next_step_state = CHECK_test;
            leave_time = min;
            income = income + price;
            work_begin = 0;
            large_light = 0;
            normal_light = 0;
            small_light = 0;
            dry_light = 0;
            end
            else next_step_state = PRICE_test;
        end
        
        CHECK_test:begin
            if (next) begin
//            leave = 2'b00;
            next_step_state = OPEN;
            end
            else next_step_state = CHECK_test;
        end
                                 
             RULE:
              if(a)
               next_step_state = BEGIN;
              else if (b) 
              next_step_state = EXCEED;
              else
              begin
              
                                case(sel)
                                   4'b1000: begin
                                   ch = 1;
                                   next_step_state =  ADJUST;
                                   end
                                   4'b0100: begin
                                   ch = 1;
                                   next_step_state =  ADJUST;
                                   end
                                   4'b0010: begin
                                   ch = 1;
                                   next_step_state =  ADJUST;
                                   end
                                   4'b0001: begin
                                   ch = 1;
                                   next_step_state =  ADJUST;
                                   end
                                   default:next_step_state = RULE;
                                   endcase
                                   end
//                            else next_step_state = RULE;
             ADJUST:
             if(b) begin
//             ch = 1;
             next_step_state =  EXCEED;
             end
             else
             next_step_state =  ADJUST;
             
             EXCEED:
             if(c)
             next_step_state = EXCEED_A;
             else if(b)
             next_step_state = INCOME_INFO;
             else if(a)
             next_step_state = RULE;
             else
             next_step_state = EXCEED;
             
            EXCEED_A:
            begin
            ch = 1;
            if(b)
            next_step_state = INCOME_INFO;
            else if(a)
            next_step_state = RULE;
            else
            next_step_state = EXCEED_A;
            end
             
             INCOME_INFO:
             if(a)
             next_step_state = EXCEED;
             else if(b)
             next_step_state = WORK_INFO;
             else
             next_step_state = INCOME_INFO;
             
             WORK_INFO:
             if(a)
             next_step_state = INCOME_INFO;
             else if(b)
             next_step_state =  LEAVE_INFO;
             else
             next_step_state = WORK_INFO;
                         
             LEAVE_INFO:
             if(a)
             next_step_state = WORK_INFO;
             else if(b)
             next_step_state = INFO;
             else
             next_step_state = LEAVE_INFO;
             
             INFO:
             if(c) begin
             income = 16'd0;
             work_time = 16'd0;
             leave_time = 16'd0;
             end
             else if(a)
             next_step_state = WORK_INFO;
             else if(b)
             next_step_state = RESET;
             else
             next_step_state = INFO;
             
             RESET:
             begin
             if(c)
             ch = 0;
             if(b)
             next_step_state = BEGIN;
             else if(a) 
             next_step_state = INFO;
             else
             next_step_state = RESET;
             end
             
             
             
      endcase
    end
    
    always@(hundred,ten,one)
    begin
    balance = hundred*100+ten*10+one;
    end
    
//    always@(*)
//    begin
//    if(clear)
//    income = 16'd0;
//    work_time = 16'd0;
//    leave_time = 16'd0;
//    else
//    if(!increase)
//    end
    
    always@(*)
        begin
            if(ch)
            begin
                default_fee = 0;
                case(mode)
                LARGE:price = lp + exceed*min;
                MIDDLE:price = np + exceed*min;
                SMALL:price = sp + exceed*min;
                DRY:price = dp + exceed*min;
                default: price = 16'd0;
                endcase
            end
            else
            begin
                default_fee = 1;
                case(mode)
                LARGE:price = 16'd8+min;
                MIDDLE:price = 16'd6+min;
                SMALL:price = 16'd4+min;
                DRY:price = 16'd2+min;
                default: price = 16'd0;
                endcase
            end
        end
   
   
endmodule
