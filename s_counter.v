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
						clk,//ʱ��
						res,//��λ
						s_num//����������
						);
input					clk;
input					res;
output[4:0]		        s_num;
 
parameter			    frequency_clk=24;//24MHz;�����޸�������ֵ������16Mhz��
 
 
reg[24:0]			    con_t;//�������Ƶ��������
//24MHzƵ��24000000��������25λ
reg						s_pulse;//������⣻
reg[4:0]		        s_num;
 
always@(posedge clk or negedge res)
//��������λ
if(~res)begin
	con_t<=0;s_pulse<=0;s_num<=0;
end
//��������
else begin
	//�������Ƶ������������ϵͳʱ�Ӽ���
	if(con_t==frequency_clk*100000000-1)begin
		con_t<=0;
	end
	else begin
		con_t<=con_t+1;
	end
	//�����壬con_tΪ0����1����0����0��
	if(con_t==0)begin
		s_pulse<=1;
	end
	else begin
		s_pulse<=0;
	end
	//�������������������м���������һ���������һ��������Χ0-9��
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