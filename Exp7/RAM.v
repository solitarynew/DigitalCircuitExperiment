module RAM(clk,din,inaddr,outaddr,we,HEX0,HEX1,HEX2,HEX3);
	input clk;
	input [1:0] din;
	input [3:0] inaddr,outaddr;
	input we;
	output [6:0] HEX0,HEX1,HEX2,HEX3;
	wire [7:0] dout1,dout2;
	ram1 ram_1(clk,din,inaddr,outaddr,we,dout1);
	ram2 ram_2(clk,din,outaddr,inaddr,we,dout2);
	
	decode_hex decode_hex0(dout1[3:0],HEX0);
	decode_hex decode_hex1(dout1[7:4],HEX1);
	decode_hex decode_hex2(dout2[3:0],HEX2);
	decode_hex decode_hex3(dout2[7:4],HEX3);
	

endmodule