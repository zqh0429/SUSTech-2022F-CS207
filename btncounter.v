`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/15 17:09:00
// Design Name: 
// Module Name: btncounter
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


module btncounter(clk,rst,btn1, btn2,counting);

	input clk;
	input rst;
//	input rst1;
	input btn1;
	input btn2;
//	input [3:0] seg_data_1;						
	//数码管需要显示0~9十个数字，所以最少需要4位输入做译码
//	input [3:0] seg_data_2;			
			
//	output [8:0] seg_led_1;						
	//在小脚丫上控制一个数码管需要9个信号 MSB~LSB=DIG、DP、G、F、E、D、C、B、A
//	output [8:0] seg_led_2;						
	//在小脚丫上第二个数码管的控制信号  MSB~LSB=DIG、DP、G、F、E、D、C、B、A
//	reg [8:0] seg [9:0];                                            
	//定义了一个reg型的数组变量，相当于一个10*9的存储器，存储器一共有10个数，每个数有9位宽
	
	wire key_pulse1;
	wire key_pulse2;
	output reg [4:0] counting = 2'd00;
//	output reg [3:0] seg_data_1= 1'd0;
//	output reg [3:0] seg_data_2= 1'd0;
	
//	initial                                                         
//	//在过程块中只能给reg型变量赋值，Verilog中有两种过程块always和initial
//		begin
//			seg[0] = 9'h3f;                                           
//			//对存储器中第一个数赋值9'b00_0011_1111,相当于共阴极接地，DP点变低不亮，7段显示数字  0
//	      seg[1] = 9'h06;                                           
//			//7段显示数字  1
//	      seg[2] = 9'h5b;                                           
//			//7段显示数字  2
//	      seg[3] = 9'h4f;                                           
//			//7段显示数字  3
//	      seg[4] = 9'h66;                                           
//			//7段显示数字  4
//	      seg[5] = 9'h6d;                                           
//			//7段显示数字  5
//	      seg[6] = 9'h7d;                                           
//			//7段显示数字  6
//	      seg[7] = 9'h07;                                           
//			//7段显示数字  7
//	      seg[8] = 9'h7f;                                           
//			//7段显示数字  8
//	      seg[9] = 9'h6f;                                           
//			//7段显示数字  9
//       end
	 debounce_button  u1 (                               
                       .clk (clk),
                       .rst (rst),
                       .key (btn1),
                       .key_pulse (key_pulse1)
                       );
	//按键1对应于加一
							  
	 debounce_button  u2 (                               
                       .clk (clk),
                       .rst (rst),
                       .key (btn2),
                       .key_pulse (key_pulse2)
                       );
	//按键2对应于减一
	always@(posedge clk or negedge rst  )
//		begin
//		if(~rst1)
//		counting <= 0;
//		else
		begin
			if(~rst)
			begin
			if(counting!=0)
				counting <= counting;
			end
			
			else
			begin
				if(key_pulse1)
				begin
					counting <= (counting + 1) % 10;
				end
				else 
				begin
					if(key_pulse2)
					begin
						counting <= (counting -1 + 10) % 10;
					end
					else
					begin
						counting <= counting;
					end
				end
				
//				seg_data_1 <= counting / 10;
//				if(counting % 10 == 0)
//				begin 
//					seg_data_2 <= 0;
//				end
//				else
//				begin 
//					seg_data_2 <= counting - 10 * seg_data_1;
//				end
			end
		end
//	end
//	assign seg_led_1 = seg[seg_data_1];                         
//   assign seg_led_2 = seg[seg_data_2];
endmodule

