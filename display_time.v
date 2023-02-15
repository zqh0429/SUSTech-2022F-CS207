`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 22:34:52
// Design Name: 
// Module Name: display_time
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
module display_time (
	clk,rst,
	i_minute,
	i_second,
	i_second_p,
//	i_step,
//	i_twinkle,
//	o_index_n, // select one from 4 dynamic dig
//	o_seg_n, // 7 seg to show the number
	o_lsb, // 7 seg to show the lsb 
//	en1,
	en2
);

//input i_twinkle;
input clk;
input rst;
input [7:0] i_minute;
input [7:0] i_second;
input [3:0] i_second_p;
//input [2:0] i_step;
//output [3:0] o_index_n; // 5 numbers from left to rignt
//output [7:0] o_seg_n; // 7 segments and 1 point to show the number
output [7:0] o_lsb;
//output [3:0] en1;
output [3:0] en2;



//assign en1 = 4'b0001;
assign en2 = 4'b0001;

reg [2:0] scan_count;
reg [7:0] seg; // a,b,c,d,e,f,g,p 
reg [7:0] lsb;
wire clk_1Hz;

divide u1(clk,rst,clk_1Hz);

assign o_lsb = lsb;
//assign o_seg_n = seg;

always @ (posedge clk_1Hz) begin
	case (i_second_p)
		4'd0: lsb = 8'b11111100; // 0
		4'd1: lsb = 8'b01100000; // 1
		4'd2: lsb = 8'b11011010; // 2
		4'd3: lsb = 8'b11110010; // 3
		4'd4: lsb = 8'b01100110; // 4
		4'd5: lsb = 8'b10110110; // 5
		4'd6: lsb = 8'b10111110; // 6
		4'd7: lsb = 8'b11100000; // 7
		4'd8: lsb = 8'b11111110; // 8
		4'd9: lsb = 8'b11110110; // 9
		default: lsb = 8'b0000001;
	endcase
end

//always @ (posedge clk_1Hz) begin
//	case (i_step)
//		3'd0: seg[7:0] = 8'b11111100; // 0
//		3'd1: seg[7:0] = 8'b01100000; // 1
//		3'd2: seg[7:0] = 8'b11011010; // 2
//		3'd3: seg[7:0] = 8'b11110010; // 3
//		3'd4: seg[7:0] = 8'b01100110; // 4
//		3'd5: seg[7:0] = 8'b10110110; // 5
//        3'd6: seg[7:0] = 8'b10111110; // 6
//		default:seg[7:0] = 8'b00000001;
//	endcase
//end
endmodule 

module divide(
input clk,
input rst_n,
output clk_bps
    );
    reg [13:0] cnt_first,cnt_second;
    always@(posedge clk, negedge rst_n) 
        if( !rst_n )
            cnt_first <= 14'd0;
        else if (cnt_first == 14'd10000)
            cnt_first <= 14'd0;
        else
            cnt_first <= cnt_first + 1'b1;
    always@(posedge clk, negedge rst_n) 
        if( !rst_n )
             cnt_second <= 14'd0;
        else if (cnt_second == 14'd10000)
             cnt_second <= 14'd0;
        else if ( cnt_first == 14'd10000)
             cnt_second <= cnt_second + 1'b1;   
        else 
            cnt_second <= cnt_second;       
    assign clk_bps = cnt_second == 14'd10000;              
endmodule