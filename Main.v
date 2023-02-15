`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 22:28:13
// Design Name: 
// Module Name: Main
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
module washingmachine_top (
	clk, 
	rst_n,
	i_start_n, 
	mode,
	done,
	next,test,
	fault,
	en_light,
	leave_time,
//	step,
	minute_wire,second_wire,second_p_wire
//	light
);

input clk, rst_n; 
input i_start_n;
input leave_time;
//input i_water_full_n;
input[3:0] mode;
//input choose_song;
input fault;
input next,test;
//input open;

//output buzzer;
output reg done;
output reg[7:0] en_light;//水量

parameter IDLE	= 5'd1;
parameter WATER	= 5'd2;
parameter ROTATE= 5'd3; 
parameter DRAIN	= 5'd4; 
parameter WATER2	= 5'd5;
parameter ROTATE2 = 5'd6; 
parameter DRAIN2	= 5'd7;  
parameter DRY	= 5'd8; 
parameter DRAIN4	= 5'd9; 
parameter REVERSE_DRY = 5'd10;
parameter DRAIN5	= 5'd11; 
parameter END	= 5'd12; 
parameter END2 = 5'd13;
parameter DRY2 = 5'd14;
parameter REVERSE_DRY2 = 5'd15;
parameter END3 = 5'd16;
parameter END4 = 5'd17;
parameter IDLE2 = 5'd18;
parameter DRY_FAULT = 5'd19;
parameter DRY_REPAIR = 5'd20;
parameter DRAIN6	= 5'd21; 
parameter DRAIN7	= 5'd22; 



parameter WATER_TIME  = 16'd3;
parameter ROTATE_TIME	= 16'd4; // 10min -> 5min
parameter DRAIN_TIME	= 16'd2; // 30sec
parameter DRY_TIME		= 16'd4; // 5min
parameter REVERSE_DRY_TIME = 16'd5;

reg [4:0] state;
reg timer_start;
reg [15:0] timer_state;
//output reg [2:0] step;
reg [3:0] index;

wire [15:0] timer_done;
wire [15:0] time_wire;
output [7:0] minute_wire;
output [7:0] second_wire;
output [3:0] second_p_wire;

reg flag;
//reg en_alert;
reg has_fault;
//output reg light;
always @(*) begin
     if(mode == 4'b0001 || mode == 4'b0010 || mode == 4'b0100)  flag = 1'b1;
     else if(mode == 4'b1000) flag = 1'b0;
end
always @(*) begin
 if(fault)  has_fault = 1'b1;
 else has_fault = 1'b0;
end

always @ (posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		timer_start <= 1'b0;
		timer_state <= 0;
		index <= 4'b0000;
		done <= 1'b0;
//		en_alert <= 1'b0;
	if(flag) state <= IDLE;
	else state <= IDLE2;
	end
   else  begin
    
//    if(!done) begin
	    if(flag) begin //大件
		case (state)
			IDLE: begin
				if (!i_start_n) begin
				begin
					state <= WATER;
					timer_start <= 0;
					timer_state <= 0;
					end
				end else begin
					state <= IDLE;
					timer_start <= 0;
					timer_state <= 0;
				end
			end
			
			WATER: begin
				if(test) begin
                  if(next)begin
                      state <= ROTATE;
                      timer_start <= 0;
                      timer_state <= WATER_TIME;
                     end
                 end
               else begin
					state <= ROTATE;
					timer_start <= 1;
					timer_state <= WATER_TIME;	
					end
               end
			
			ROTATE: begin
			if(test) begin
              if(next)begin
                  state <= DRAIN;
                  timer_start <= 0;
                  timer_state <= ROTATE_TIME;
                 end
             end
           else begin
				if (timer_done[index]) begin
					state <= DRAIN;
					timer_start <= 1;
					timer_state <= ROTATE_TIME;   					
                    index <= index + 1;
				end
			end
			end
			
			DRAIN: begin
			if(test) begin
              if(next)begin
                  state <= WATER2;
                  timer_start <= 0;
                  timer_state <= DRAIN_TIME;
                 end
             end
           else begin
				if (timer_done[index]) begin
					state <= WATER2;
					timer_start <= 1;
					timer_state <= DRAIN_TIME;   
                    index <= index + 1;
				end
				end
			end
			WATER2: begin
			if(test) begin
              if(next)begin
                  state <= ROTATE2;
                  timer_start <= 0;
                  timer_state <= WATER_TIME;
                 end
             end
           else begin
                if (timer_done[index]) begin
                    state <= ROTATE2;
                    timer_start <= 1;
                    timer_state <= WATER_TIME;  
                    index <= index + 1;
                end 
            end
            end
            ROTATE2: begin
            				if(test) begin
              if(next)begin
                  state <= DRAIN2;
                  timer_start <= 0;
                  timer_state <= ROTATE_TIME;
                 end
             end
           else begin
                if (timer_done[index]) begin
                    state <= DRAIN2;
                    timer_start <= 1;
                    timer_state <= ROTATE_TIME;                     
                    index <= index + 1;
                end
            end
            end
            
            DRAIN2: begin
            				if(test) begin
              if(next)begin
                  state <= DRY;
                  timer_start <= 0;
                  timer_state <= DRAIN_TIME;
                 end
             end
           else begin
                if (timer_done[index]) begin
                    if(has_fault) state <= DRY_FAULT;
                    else state <= DRY;
                    timer_start <= 1;
                    timer_state <= DRAIN_TIME;
                    index <= index + 1;
                end
            end
            end
            
			DRY: begin
			if(test) begin
              if(next)begin
                  state <= DRAIN4;
                  timer_start <= 0;
                  timer_state <= DRY_TIME;
                 end
             end
           else begin
				if (timer_done[index]) begin
					state <= DRAIN4;
					timer_start <= 1;
					timer_state <= DRY_TIME;
                    index <= index + 1;
				end
			end
			end
			DRY_FAULT:begin
			     if (timer_done[index]) begin
			        state <= DRY_REPAIR;
                    timer_start <= 0;
                    timer_state <= 0;
                  end		
			end
			DRY_REPAIR:begin
			      if(!has_fault)begin
			        state <= DRAIN4;
					timer_start <= 1;
                    timer_state <= DRY_TIME; 
                    index <= index + 1;
			      end
			end
            DRAIN4: begin
            if(test) begin
              if(next)begin
                  state <= REVERSE_DRY;
                  timer_start <= 0;
                  timer_state <= DRAIN_TIME;
                 end
             end
           else begin
                if (timer_done[index]) begin
                    state <= REVERSE_DRY;
                    timer_start <= 1;
                    timer_state <= DRAIN_TIME;
                    index <= index + 1;
                end
            end
            end
			REVERSE_DRY: begin
							if(test) begin
              if(next)begin
                  state <= DRAIN5;
                  timer_start <= 0;
                  timer_state <= REVERSE_DRY_TIME;
                 end
             end
           else begin
				if (timer_done[index]) begin
					state <= DRAIN5;
					timer_start <= 1;
					timer_state <= REVERSE_DRY_TIME;
                    index <= index + 1;
				end 
			end
			end
			
            DRAIN5: begin
           if(test) begin
              if(next)begin
                  state <= END;
                  timer_start <= 0;
                  timer_state <= DRAIN_TIME;
                 end
             end
           else begin
                if (timer_done[index]) begin
                    state <= END;
                    timer_start <= 1;
                    timer_state <= DRAIN_TIME;                        
                       index <= index + 1;
                end
            end
            end
            
           END: begin
          if(test) begin
             if(next)begin
                 state <= IDLE;
                 done = 1'b1;
                 timer_start <= 0;
                 timer_state <= 0;
                end
            end
          else begin
                if (timer_done[index]) begin
                    state <= END2;
                    timer_start <= 0;
                    timer_state <= 0;                       
                    index <= index + 1;
                    done <= 1'b1;
//                    en_alert <= 1'b1;
                end
            end
            end
            END2:begin
                if (timer_done[index]) begin
                state <= IDLE;
//                index <= index + 1;
                timer_start <= 0;
                timer_state <= 0;
                done <= 1'b0;
//                en_alert <= 0;
            end
        end
			default: begin
				state <= IDLE;
				timer_start <= 0;
				timer_state <= 0;
			end
		endcase
	    end
	else begin   //旋干 
	    case (state)
                IDLE2: begin
                    if (!i_start_n) begin
                        state <= DRY2;
                        timer_start <= 0;
                        timer_state <= 0;
                    end else begin
                        state <= IDLE2;
                        timer_start <= 0;
                        timer_state <= 0;
                    end
                end
                DRY2: begin
                           if(test) begin
                   if(next)begin
                       state <= DRAIN6;
                       timer_start <= 0;
                       timer_state <= DRY_TIME;
                      end
                  end
                else begin
                        state <= DRAIN6;
                        timer_start <= 1;
                        timer_state <= DRY_TIME;
                      end
                end
                DRAIN6: begin
                           if(test) begin
                   if(next)begin
                       state <= REVERSE_DRY2;
                       timer_start <= 0;
                       timer_state <= DRAIN_TIME;
                      end
                  end
                else begin
                    if (timer_done[index]) begin
                        state <= REVERSE_DRY2;
                        timer_start <= 1;
                        timer_state <= DRAIN_TIME;
                        index <= index + 1;
                    end
                end
                end
                REVERSE_DRY2: begin
                           if(test) begin
                   if(next)begin
                       state <= DRAIN7;
                       timer_start <= 0;
                       timer_state <= REVERSE_DRY_TIME;
                      end
                  end
                else begin
                    if (timer_done[index]) begin
                        state <= DRAIN7;
                        timer_start <= 1;
                        timer_state <= REVERSE_DRY_TIME;
                        index <= index + 1;
                    end 
                end
                end
                DRAIN7: begin
                           if(test) begin
                   if(next)begin
                       state <= END3;
                       timer_start <= 0;
                       timer_state <= WATER_TIME;
                      end
                  end
                else begin
                    if (timer_done[index]) begin
                        state <= END3;
                        timer_start <= 1;
                        timer_state <= DRAIN_TIME;
                        index <= index + 1;
                    end
                end
                end
                END3: begin
                           if(test) begin
                   if(next)begin
                       state <= IDLE2;
                       timer_start <= 0;
                       done <= 1'b1;
                       timer_state <= 0;
                      end
                  end
                else begin
                    if (timer_done[index]) begin
                        state <= END4;
                        timer_start <= 0;
                        timer_state <= 0;
                        index <= index + 1;
                        done <= 1'b1;
                    end
                end
                end
                END4:begin
                    if (timer_done[index]) begin
                    state <= IDLE2;
                    timer_start <= 0;
                    timer_state <= 0;
                    done <= 0;
//                    en_alert <= 0;
                end
            end
                default: begin
                    state <= IDLE;
                    timer_start <= 0;
                    timer_state <= 0;
//                    en_alert <= 1'b0;
                end
            endcase
	end
end		
end
//end

always @(*)begin
case(state)
WATER: begin
       case(mode)
        4'b0001:en_light <= 8'b10000111;
        4'b0010:en_light <= 8'b10000011;
        4'b0100:en_light <= 8'b10000001;
        endcase            
        end

ROTATE: begin
       case(mode)
         4'b0001:en_light <= 8'b01000111;
         4'b0010:en_light <= 8'b01000011;
         4'b0100:en_light <= 8'b01000001;
         endcase                        
    end
DRAIN: begin
       case(mode)
         4'b0001:en_light <= 8'b00100111;
         4'b0010:en_light <= 8'b00100011;
         4'b0100:en_light <= 8'b00100001;
         endcase    
    end
WATER2: begin
       case(mode)
         4'b0001:en_light <= 8'b10000111;
         4'b0010:en_light <= 8'b10000011;
         4'b0100:en_light <= 8'b10000001;
         endcase    
    end 

ROTATE2: begin
        case(mode)
        4'b0001:en_light <= 8'b01000111;
        4'b0010:en_light <= 8'b01000011;
        4'b0100:en_light <= 8'b01000001;
        endcase                        
    end
DRAIN2: begin
       case(mode)
          4'b0001:en_light <= 8'b00100111;
          4'b0010:en_light <= 8'b00100011;
          4'b0100:en_light <= 8'b00100001;
          endcase 
    end
DRY: begin
       case(mode)
          4'b0001:en_light <= 8'b00010111;
          4'b0010:en_light <= 8'b00010011;
          4'b0100:en_light <= 8'b00010001;
          endcase   
    end
DRY_FAULT:begin
       case(mode)
          4'b0001:en_light <= 8'b00010111;
          4'b0010:en_light <= 8'b00010011;
          4'b0100:en_light <= 8'b00010001;
          endcase   
      end        
DRY_REPAIR:begin
       case(mode)
          4'b0001:en_light <= 8'b00010111;
          4'b0010:en_light <= 8'b00010011;
          4'b0100:en_light <= 8'b00010001;
          endcase   
      end
DRAIN4: begin
       case(mode)
          4'b0001:en_light <= 8'b00100111;
          4'b0010:en_light <= 8'b00100011;
          4'b0100:en_light <= 8'b00100001;
          endcase                    
          end
REVERSE_DRY: begin
       case(mode)
          4'b0001:en_light <= 8'b00001111;
          4'b0010:en_light <= 8'b00001011;
          4'b0100:en_light <= 8'b00001001;
          endcase                     
          end
DRAIN5: begin
       case(mode)
           4'b0001:en_light <= 8'b00100111;
           4'b0010:en_light <= 8'b00100011;
           4'b0100:en_light <= 8'b00100001;
           endcase                         
           end
END: begin
       case(mode)
           4'b0001:en_light <= 8'b11111111;
           4'b0010:en_light <= 8'b11111011;
           4'b0100:en_light <= 8'b11111001;
         endcase                         
      end
END2:en_light <= 8'b00000000;
DRY2: en_light <= 8'b00010000;
DRAIN6:en_light <= 8'b00100000;
REVERSE_DRY2:en_light <= 8'b00001000;
DRAIN7:en_light <= 8'b00100000;
END3:en_light <=  8'b11111000;
END4:en_light <= 8'b00000000;
default:en_light <= 8'b11111111;
endcase
end
timer t (
	.clk(clk),
	.rst_n(rst_n),
	.i_start(timer_start),
	.i_state(timer_state),
	.i_step(index),
	.o_response(timer_done),
	.o_time(time_wire)
);

get_time g (
	.i_time(time_wire),
	.o_minute(minute_wire),
	.o_second(second_wire),
	.o_second_p(second_p_wire)
);

//alert a(
//clk,en_alert,choose_song,buzzer
//);
endmodule 