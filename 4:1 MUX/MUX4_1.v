`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2026 19:58:54
// Design Name: 
// Module Name: MUX4_1
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


module MUX4_1(
    input I0,I1,I2,I3,
    input S0,S1,
    output reg Y
    );
    always @(*)begin
    case({S0,S1})
     2'b00: Y=I0;
     2'b01: Y=I1;
     2'b10: Y=I2;
     2'b11: Y=I3;
     
    endcase
    end
endmodule
