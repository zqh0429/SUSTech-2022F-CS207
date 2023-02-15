`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/14 22:35:49
// Design Name: 
// Module Name: timer
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
module timer(
	clk,
	rst_n,
	i_start,
//	i_acc,
	i_state,
	i_step,
	o_response,
	o_time
);

input clk;
input rst_n;
//input i_acc;
input [3:0] i_step;
input i_start;
input [15:0] i_state; // time to count
output [15:0] o_response;
output reg [3:0] o_time;

reg [15:0] o_response;
reg [15:0] temp_time;
wire clk_1Hz;

divide u1(clk,rst_n,clk_1Hz);

always @ (posedge clk_1Hz or negedge rst_n) begin
	if (!rst_n) begin
		o_time <= 0;
		o_response <= 16'b0;
	end else begin
		if (i_start) begin
			o_time <= o_time + 16'd1;
			temp_time <= temp_time + 16'd1;
			if (temp_time < i_state) begin	
				temp_time <= temp_time + 16'd1;
			end else begin
				temp_time <= 16'd0;
				o_time <= 0;
				o_response[i_step] <= 1'b1;
			end
		end else begin
			o_time <= i_state;
			temp_time <= 16'd0;
		end
	end

end

endmodule 
