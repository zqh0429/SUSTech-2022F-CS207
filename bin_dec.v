`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/23 14:49:56
// Design Name: 
// Module Name: bin_dec
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


module bin_dec(clk,bin,rst_n,one,ten,hun,count,shift_reg
    );
input  [15:0] bin;
input        clk,rst_n;
output [3:0] one,ten;
output [3:0] count;
output [1:0] hun;
output [17:0]shift_reg;
reg    [3:0] one,ten;
reg    [1:0] hun;
reg    [3:0] count;
reg    [17:0]shift_reg=18'b000000000000000000;
// 计数部分
always @ ( posedge clk or negedge rst_n )
begin
 if( !rst_n )
   count<=0;
 else if (count==9)
   count<=0;
 else
   count<=count+1;
end

// 二进制转换为十进制 /
always @ (posedge clk or negedge rst_n )
begin
  if (!rst_n)
       shift_reg=0;
  else if (count==0)
       shift_reg={2'b00,bin};
  else if ( count<=8)                //实现8次移位操作
   begin
      if(shift_reg[11:8]>=5)         //判断个位是否>5，如果是则+3  
          begin
             if(shift_reg[15:12]>=5) //判断十位是否>5，如果是则+3  
                 begin
   shift_reg[15:12]=shift_reg[15:12]+2'b11;   
   shift_reg[11:8]=shift_reg[11:8]+2'b11;
shift_reg=shift_reg<<1;  //对个位和十位操作结束后，整体左移
 end
             else
       begin
                   shift_reg[15:12]=shift_reg[15:12];
shift_reg[11:8]=shift_reg[11:8]+2'b11;
shift_reg=shift_reg<<1;
 end
          end              
      else
          begin
             if(shift_reg[15:12]>=5)
                 begin
   shift_reg[15:12]=shift_reg[15:12]+2'b11;
   shift_reg[11:8]=shift_reg[11:8];
shift_reg=shift_reg<<1;
 end
             else
       begin
                   shift_reg[15:12]=shift_reg[15:12];
shift_reg[11:8]=shift_reg[11:8];
shift_reg=shift_reg<<1;
 end
          end        
  end
  end

//输出赋值//
always @ ( posedge clk or negedge rst_n )
begin
 if ( !rst_n )
  begin
    one<=0;
    ten<=0;
    hun<=0; 
  end
 else if (count==9)  //此时8次移位全部完成，将对应的值分别赋给个,十,百位
  begin
    one<=shift_reg[11:8];
ten<=shift_reg[15:12];
hun<=shift_reg[17:16]; 
  end
end
endmodule
