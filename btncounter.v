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
	//�������Ҫ��ʾ0~9ʮ�����֣�����������Ҫ4λ����������
//	input [3:0] seg_data_2;			
			
//	output [8:0] seg_led_1;						
	//��С��Ѿ�Ͽ���һ���������Ҫ9���ź� MSB~LSB=DIG��DP��G��F��E��D��C��B��A
//	output [8:0] seg_led_2;						
	//��С��Ѿ�ϵڶ�������ܵĿ����ź�  MSB~LSB=DIG��DP��G��F��E��D��C��B��A
//	reg [8:0] seg [9:0];                                            
	//������һ��reg�͵�����������൱��һ��10*9�Ĵ洢�����洢��һ����10������ÿ������9λ��
	
	wire key_pulse1;
	wire key_pulse2;
	output reg [4:0] counting = 2'd00;
//	output reg [3:0] seg_data_1= 1'd0;
//	output reg [3:0] seg_data_2= 1'd0;
	
//	initial                                                         
//	//�ڹ��̿���ֻ�ܸ�reg�ͱ�����ֵ��Verilog�������ֹ��̿�always��initial
//		begin
//			seg[0] = 9'h3f;                                           
//			//�Դ洢���е�һ������ֵ9'b00_0011_1111,�൱�ڹ������ӵأ�DP���Ͳ�����7����ʾ����  0
//	      seg[1] = 9'h06;                                           
//			//7����ʾ����  1
//	      seg[2] = 9'h5b;                                           
//			//7����ʾ����  2
//	      seg[3] = 9'h4f;                                           
//			//7����ʾ����  3
//	      seg[4] = 9'h66;                                           
//			//7����ʾ����  4
//	      seg[5] = 9'h6d;                                           
//			//7����ʾ����  5
//	      seg[6] = 9'h7d;                                           
//			//7����ʾ����  6
//	      seg[7] = 9'h07;                                           
//			//7����ʾ����  7
//	      seg[8] = 9'h7f;                                           
//			//7����ʾ����  8
//	      seg[9] = 9'h6f;                                           
//			//7����ʾ����  9
//       end
	 debounce_button  u1 (                               
                       .clk (clk),
                       .rst (rst),
                       .key (btn1),
                       .key_pulse (key_pulse1)
                       );
	//����1��Ӧ�ڼ�һ
							  
	 debounce_button  u2 (                               
                       .clk (clk),
                       .rst (rst),
                       .key (btn2),
                       .key_pulse (key_pulse2)
                       );
	//����2��Ӧ�ڼ�һ
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

