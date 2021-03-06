
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module my_clock(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// Seg7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

wire [9:0] LEDRa,LEDRb;
wire [6:0] HEX0a,HEX1a,HEX2a,HEX3a,HEX4a,HEX5a;
wire [6:0] HEX0b,HEX1b,HEX2b,HEX3b,HEX4b,HEX5b;
wire [6:0] HEX0c,HEX1c,HEX2c,HEX3c,HEX4c,HEX5c;
wire C;
	Clock clock(SW[0],CLOCK_50,KEY[0],KEY[1],KEY[2],LEDRa[0],HEX0a,HEX1a,HEX2a,HEX3a,HEX4a,HEX5a);
	Timer timer(SW[0],CLOCK_50,KEY[0],KEY[1],KEY[2],LEDRb[1],LEDRb[0],HEX0b,HEX1b,HEX2b,HEX3b,HEX4b,HEX5b);
	CL cl(KEY[0],KEY[1],KEY[2],C,HEX0c,HEX1c,HEX2c,HEX3c,HEX4c,HEX5c);


assign LEDR=SW[0]?LEDRa:LEDRb;
assign HEX0=SW[1]?HEX0c:(SW[0]?HEX0a:HEX0b);
assign HEX1=SW[1]?HEX1c:(SW[0]?HEX1a:HEX1b);
assign HEX2=SW[1]?HEX2c:(SW[0]?HEX2a:HEX2b);
assign HEX3=SW[1]?HEX3c:(SW[0]?HEX3a:HEX3b);
assign HEX4=SW[1]?HEX4c:(SW[0]?HEX4a:HEX4b);
assign HEX5=SW[1]?HEX5c:(SW[0]?HEX5a:HEX5b);
//=======================================================
//  Structural coding
//=======================================================



endmodule
