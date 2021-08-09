
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module Type(

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
	output		     [6:0]		HEX5,

	//////////// SDRAM //////////
	output		    [12:0]		DRAM_ADDR,
	output		     [1:0]		DRAM_BA,
	output		          		DRAM_CAS_N,
	output		          		DRAM_CKE,
	output		          		DRAM_CLK,
	output		          		DRAM_CS_N,
	inout 		    [15:0]		DRAM_DQ,
	output		          		DRAM_LDQM,
	output		          		DRAM_RAS_N,
	output		          		DRAM_UDQM,
	output		          		DRAM_WE_N,

	//////////// Video-In //////////
	input 		          		TD_CLK27,
	input 		     [7:0]		TD_DATA,
	input 		          		TD_HS,
	output		          		TD_RESET_N,
	input 		          		TD_VS,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// Audio //////////
	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// PS2 //////////
	inout 		          		PS2_CLK,
	inout 		          		PS2_CLK2,
	inout 		          		PS2_DAT,
	inout 		          		PS2_DAT2,

	//////////// ADC //////////
	output		          		ADC_CONVST,
	output		          		ADC_DIN,
	input 		          		ADC_DOUT,
	output		          		ADC_SCLK,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	//////////// IR //////////
	input 		          		IRDA_RXD,
	output		          		IRDA_TXD
);


wire[7:0] n;

/*
reg	[7:0]  v_data;
reg	[11:0]  v_rdaddress;
reg	  v_rdclock;
reg	[11:0]  v_wraddress;
reg	  v_wrclock;
reg	  v_wren;
wire	[7:0]  v_q;
*/

//=======================================================
//  REG/WIRE declarations
//=======================================================


	/*
	decode_hex hex0(
	.in(n[3:0]),
	.HEX(HEX0)
	);
	
	decode_hex hex1(
	.in(n[7:4]),
	.HEX(HEX1)
	);
	*/
	
wire [9:0] h_addr,v_addr;
wire [23:0] vga_data;
assign VGA_SYNC_N=0;
reg [7:0] kbdata;
wire en_clk;

	
//bgm
wire clk_i2c;
wire clk_bgm;
wire reset;
wire [15:0] audiodata;
wire [6:0]volume;
wire [15:0]freq;
wire [2:0]audio_config_testbits;
wire audio_clk_sig;
wire [2:0] level;
wire [7:0] cnt;
//=======================================================
//  Structural coding
//=======================================================

	clkgen #(25000000) my_vgaclk(CLOCK2_50,1'b0,1'b1,VGA_CLK);
	vga_ctrl my_ctrl(VGA_CLK,1'b0,vga_data,h_addr,v_addr,VGA_HS,VGA_VS,VGA_BLANK_N,VGA_R,VGA_G,VGA_B);
	keyboard k(1'b1,CLOCK2_50,PS2_CLK,PS2_DAT,kbdata);
	
	decode_hex h0(kbdata[3:0],HEX0);
	decode_hex h1(kbdata[7:4],HEX1);
	
	//clkgen #(25000000) my_enclk(CLOCK2_50,1'b0,SW[1],en_clk);
	
	memory ctrl_memory(
		.clk(CLOCK2_50),
		.vga_clk(VGA_CLK),
		.h_addr(h_addr),
		.v_addr(v_addr),
		.kbdata(kbdata),
		.vga_data(vga_data),
		.sw(SW[0]),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.level(level)

	);
//assign reset = ~KEY[0];

reg bgm_en;
reg [31:0] bgm_cnt = 0;
always @ (posedge CLOCK2_50)
begin
	if(kbdata >= 65 && kbdata <= 90)
	begin
	  	bgm_cnt <= 0;
		bgm_en <= 1;
	end
	else begin
	    if(bgm_cnt >= 25000000)
		begin
		    bgm_cnt <= 0;
		    bgm_en <= 0;
		end
	    else begin
		    bgm_cnt <= bgm_cnt + 1;
			bgm_en <= bgm_en;
		end
	end

end

assign LEDR[0] = bgm_en;
assign reset_n = ~reset;

clkgen #(10000) my_i2c_clk(CLOCK2_50,reset,1'b1,clk_i2c);  //10k I2C clock  

audio_clk u1(CLOCK2_50, reset,AUD_XCK, audio_clk_sig);

I2C_Audio_Config myconfig(clk_i2c, reset_n, FPGA_I2C_SCLK,FPGA_I2C_SDAT,audio_config_testbits,0,volume);

I2S_Audio myaudio(AUD_XCK, reset_n, AUD_BCLK, AUD_DACDAT, AUD_DACLRCK, audiodata);

Sin_Generator sin_wave(AUD_DACLRCK, reset_n, freq, audiodata);//
 
//piano p1(.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),.clk(CLOCK2_50),.volume(volume),.freq(freq),.test(LEDR),.en(en));
//clkgen #(4) my_bgm_clk(clk,1'b0,1'b1,clk_bgm);
bgm bm(.clk(CLOCK2_50),.en(bgm_en),.freq(freq),.volume(volume),.level(level),.cnt(cnt),.reset(reset),.kbdata(kbdata));



decode_hex h4(volume[3:0],HEX4);
decode_hex h5({1'b0, volume[6:4]},HEX5);
endmodule
