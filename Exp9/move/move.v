
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module move(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

	assign VGA_SYNC_N=1'b0;
	assign VGA_R[3:0]=4'b0000;
	assign VGA_G[3:0]=4'b0000;
	assign VGA_B[3:0]=4'b0000;

top_flyinglogo i(CLOCK2_50, 1'b0, VGA_HS, VGA_VS, VGA_R[7:4], VGA_G[7:4], VGA_B[7:4],VGA_CLK,VGA_BLANK_N);

//=======================================================
//  Structural coding
//=======================================================



endmodule
