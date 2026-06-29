`timescale 1ns / 1ps

module tb_MUX4_1;
reg I0,I1,I2,I3,S0,S1;
wire Y;

MUX4_1 uut(I0,I1,I2,I3,S0,S1,Y);
 initial 
 begin 
 
 I0=1; I1=0;I2=1;I3=0;
 
S0=0; S1=0; #10;
S0=0; S1=1; #10;
S0=1; S1=0; #10;
S0=1; S1=1; #10;
$finish;
end
endmodule
