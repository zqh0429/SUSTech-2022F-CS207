`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/12 21:56:29
// Design Name: 
// Module Name: step_fsm_sim
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
`define CLK_PRIOD 10

module step_fsm_sim();
reg clk;
reg rst_n;
reg a,b;
reg[15:0] balance;
reg[3:0] sel;
reg work_finish;
//wire state;
wire[15:0] step_state;
wire[1:0] mode;
// next_step_state,wash_state,next_wash_state;
//wire[7:0] seg_out;
wire[15:0] price;
wire[15:0] change;
wire light;

step_fsm u(.clk(clk),.rst_n(rst_n),.a(a),.b(b),.balance(balance),.sel(sel),.work_finish(work_finish),
//.seg_out(seg_out),
.step_state(step_state),.mode(mode),.price(price),.change(change),.light(light));
// step_state,next_step_state,wash_state,next_wash_state);

//reg[15:0] step_state_sim;

// always@(*) begin
//    case(step_state)
//    16'b0000_0000_0000_0010: step_state_sim = "OPEN";
//    16'b0000_0000_0000_0100:step_state_sim = "CARD";
//    16'b0000_0000_0000_1000:step_state_sim = "WASH";
//    16'b0000_0000_0001_0000:step_state_sim = "UNCOVER";
//    16'b0000_0000_0010_0000:step_state_sim = "WEIGHT";
//    16'b0000_0000_0100_0000:step_state_sim = "COVER";
//    16'b0000_0000_1000_0000:step_state_sim = "LEGAL";
//    16'b0000_0001_0000_0000:step_state_sim = "WORK";
//    16'b0000_0010_0000_0000:step_state_sim = "PRICE";
//    16'b0000_0100_0000_0000:step_state_sim = "CHECK";
//    16'b0000_1000_0000_0000:step_state_sim = "REOPEN";
//    16'b0001_0000_0000_0000:step_state_sim = "FINAL";
//    endcase
//    end
    
initial clk = 1;
always #(`CLK_PRIOD/2) clk = ~clk;

initial begin
		rst_n = 0;
		#5
		rst_n = 1;
	end

initial begin
a = 1'b0; b = 1'b0;
//repeat(30) begin
//#15 A = 1'b1;
//#15 A = 1'b0;
//end
end

initial begin
#25 a = 1'b1; #25 a = 1'b0;//开始使用洗衣机 
#30 balance = 15'd0;#25 b = 1'b1; #25 b= 1'b0;//刷卡，输入余额，并且确定
#25 a = 1'b1; #25 a = 1'b0;//因为余额为0，重新开始使用洗衣机
#30 balance = 15'd100; #25 b = 1'b1; #25 b= 1'b0;//这次余额为100，可以进入选择洗衣选项
#30 sel = 4'b0100; #25 a = 1'b1; #25 a = 1'b0; //输入洗衣模式，并且确定
#25 b = 1'b1; #25 b= 1'b0; //开盖
#30 sel = 4'b1111; #25 a = 1'b1; #25 a = 1'b0; //输入洗衣重量，并且确定
#25 b = 1'b1; #25 b= 1'b0; //关盖
#25 a = 1'b1; #25 a= 1'b0; //按开始键
#30 sel = 4'b1000; #25 a = 1'b1; #25 a = 1'b0;  //不匹配，回到洗衣选项，再次输入洗衣模式，并且确定
#25 b = 1'b1; #25 b= 1'b0; //开盖
#30 sel = 4'b1111; #25 a = 1'b1; #25 a = 1'b0; //输入洗衣重量，并且确定
#25 b = 1'b1; #25 b= 1'b0; //关盖
#25 a = 1'b1; #25 a= 1'b0; //按开始键
#100 work_finish = 1'b1; //工作模式，直到结束，显示扣款量
#30 balance = 15'd100;#25 b = 1'b1; #25 b= 1'b0; //刷卡，输入余额，并且确定，显示余额
#25 a = 1'b1; #25 a= 1'b0; //取走衣服，洗衣结束
#100
$finish();
end


endmodule
