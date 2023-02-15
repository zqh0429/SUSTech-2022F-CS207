`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/01 16:18:04
// Design Name: 
// Module Name: s_counter
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

module s_counter(
						clk,//时钟
						res,//复位
						s_num//秒计数，输出
						);
input					clk;
input					res;
output[4:0]		        s_num;
 
parameter			    frequency_clk=24;//24MHz;方便修改其他数值，比如16Mhz；
 
 
reg[24:0]			    con_t;//秒脉冲分频计数器；
//24MHz频率24000000，二进制25位
reg						s_pulse;//秒脉冲尖；
reg[4:0]		        s_num;
 
always@(posedge clk or negedge res)
//触发器复位
if(~res)begin
	con_t<=0;s_pulse<=0;s_num<=0;
end
//正常工作
else begin
	//秒脉冲分频计数器，基于系统时钟计数
	if(con_t==frequency_clk*100000000-1)begin
		con_t<=0;
	end
	else begin
		con_t<=con_t+1;
	end
	//秒脉冲，con_t为0，置1，非0，置0。
	if(con_t==0)begin
		s_pulse<=1;
	end
	else begin
		s_pulse<=0;
	end
	//秒计数器，对秒脉冲进行计数，看到一个秒脉冲加一。计数范围0-9。
	if(s_pulse)begin
			if(s_num==24)begin
				s_num<=0;
			end
			else begin
				s_num<=s_num+1;
	end
	end
end
endmodule