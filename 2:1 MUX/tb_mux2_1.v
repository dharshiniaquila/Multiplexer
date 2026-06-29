`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 19:55:31
// Design Name: 
// Module Name: tb_mux2_1
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


module tb_mux2_1;
reg a,b,s;
wire y;
mux2_1 uut(a,b,s,y);
initial 
begin 
a=0; b=0; s=0; #10;
a=0; b=1; s=0;#10;

a=0; b=1; s=1;#10;
a=1; b=0; s=1;#10;
end
endmodule
