module Keyboard(clk,clrn,reset,ps2_clk,ps2_data,data,ready,overflow,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,caps,shift,ctrl,state);
	input clk,clrn,reset;				//SW[0],SW[1]
	input ps2_clk,ps2_data; 
	wire nextdata_n; 		
	output [7:0] data;
	wire [7:0] kbdata;
	output ready;			//LEDR[6]
	output overflow;		//LEDR[7]
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;	
	output caps,shift,ctrl;		//LEDR[3],LEDR[4],LEDR[5]
	output [1:0] state;			//LEDR[1:0]
	

	
	out o(kbdata,ps2_clk,ready,data,nextdata_n);


	ps2_keyboard i(clk,clrn,ps2_clk,ps2_data,kbdata, ready,nextdata_n,overflow);
	ascii display(reset,data,ready,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,caps,shift,ctrl,state);

endmodule