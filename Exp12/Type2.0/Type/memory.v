module memory(
	input clk,
	input vga_clk,
	input [9:0] h_addr,
	input [9:0] v_addr,
	input [7:0] kbdata,
	output reg [23:0] vga_data,
	input sw,
	output [6:0] HEX2,
	output [6:0] HEX3
);




	reg [8:0] charset [127:0];
	reg [11:0] charloc [127:0];	

	
	//Declare ROM and ROM modules
	wire [7:0] v_q;
	reg [7:0] v_data;
	reg [11:0] v_address_a;
	reg [11:0] v_address_b;

	video_ram vram(
	.address_a(v_address_a),
	.address_b(v_address_b),
	.clock(clk),
	.data_a(v_data),
	.wren_a(1'b1),
	.wren_b(1'b0),
	.q_b(v_q)
	);
	
	font_rom from(
	.address(line),
	.clock(clk),
	.q(font)
	);
	
	
	
	
	//Refresh the screen for relevant information
	reg blank;
	reg [11:0] line;
	reg [9:0] hit_score=10'b0;
	reg [9:0] miss_score=10'b0;
	reg [2:0] level=3'b1;
	wire [11:0] font;

	always @(vga_clk)
	begin
		v_address_b<=(h_addr/9)+(v_addr>>4)*70;
		line<=v_addr[3:0]+(v_q<<4);
	end
	
	always @(h_addr or v_addr)
	begin
		blank<=font[(h_addr+7)%9];
	end
	
	always @(h_addr or v_addr)			
	begin
		if(blank && (h_addr<630))
			vga_data<=24'hffffff;
		else 
			vga_data<=24'h000000;
	end
	
	
	//
	
	
	//update video memory information in real time
	reg update_signal2=1'b0;
	reg update_signal3=1'b0;
	reg [11:0] update_cnt=0;
	reg [11:0] update_cnt2=0;
	reg [9:0] cnt=0;
	reg clear_last=1'b0;
	reg clear_signal=1'b0;
	reg [11:0] clear_loc=12'b0;
	//wire update_clk1;
	wire update_clk2;
	//wire update_clk3;
	

	//clkgen #(25000000/10000) gen_clk1(clk,1'b0,1'b1,update_clk1);
	clkgen #(25000000/5) gen_clk2(clk,1'b0,1'b1,update_clk2);
	//clkgen #(25000000/2) gen_clk3(clk,1'b0,1'b1,update_clk3);


	/*
	always @(posedge update_clk2)
	begin
		if(update_signal2==0)
		begin
			update_signal2<=1'b1;
			update_cnt<=0;	
		end
		else
		begin
			if(update_signal3)
			begin
				if(clear_signal)
				begin
					v_data<=8'b0;
					v_address_a<=clear_loc;
					clear_signal<=1'b0;
					clear_loc<=12'b0;
					update_signal3<=1'b0;
				end
				else if(clear_last)
				begin
					if(charloc[update_cnt]>70)
					begin
						v_data<=8'b0;
						v_address_a<=charloc[update_cnt]-70;
					end
					clear_last<=1'b0;
				end
				else
				begin
					v_data<=charset[update_cnt][7:0];
					v_address_a<=charloc[update_cnt];
					clear_last<=1'b1;
					update_signal3<=1'b0;
				end
			end
			else 
			begin
				if(update_cnt<128)
				begin
					update_cnt<=update_cnt+1;
					if(charset[update_cnt][8])
					begin
						update_signal3<=1'b1;
						clear_last<=1'b1;
					end
				end
				else if(update_cnt==128)
				begin
					update_cnt<=update_cnt+1;
					if(clear_signal)
					begin
						update_signal3<=1'b1;
					end
				end
				else if(update_cnt==129)
				begin
					update_cnt<=0;
					update_signal2<=0;
				end
			end
		end
	end
	*/
	always @(posedge update_clk2)
	begin
		if(update_signal2==0)
		begin
			update_signal2<=1'b1;
			update_cnt<=0;	
		end
		else
		begin
			if(update_signal3)
			begin
				if(update_cnt2<128)
				begin
					if(charset[update_cnt2][8]&&charloc[update_cnt2]==update_cnt)
					begin
						v_address_a<=update_cnt;
						v_data<=charset[update_cnt2][7:0];
						update_cnt2<=0;
						update_signal3<=1'b0;
					end
					update_cnt2<=update_cnt2+1;
				end
				else if(update_cnt2==128)
				begin
					update_cnt2<=0;
					update_signal3<=1'b0;
					v_address_a<=update_cnt;
					v_data<=0;
				end
			end
			else 
			begin
				if((update_cnt>=71&&update_cnt<=138)||(update_cnt>=1961&&update_cnt<=2028))
				begin
					update_cnt<=update_cnt+1;
					v_address_a<=update_cnt;
					v_data<=42;
				end
				else if(update_cnt>=1&&update_cnt<=68)
				begin
					update_cnt<=update_cnt+1;
					v_address_a<=update_cnt;
					case (update_cnt)
						1: v_data<=70;
						2: v_data<=80;
						3: v_data<=83;
						4: v_data<=58;
						5: v_data<=51;
						6: v_data<=48;
						68: v_data<=48+level;
						67: v_data<=58;
						66: v_data<=76;
						65: v_data<=69;
						64: v_data<=86;
						63: v_data<=69;	
						62: v_data<=76;					
						default: v_data<=0; 
					endcase
				end
				else if(update_cnt>=2031&&update_cnt<=2099)
				begin
					update_cnt<=update_cnt+1;
					v_address_a<=update_cnt;
					case (update_cnt)
						2031: v_data<=83;
						2032: v_data<=67;
						2033: v_data<=79;
						2034: v_data<=82;
						2035: v_data<=69;
						2036: v_data<=58;
						2037: v_data<=48+hit_score/100;
						2038: v_data<=48+hit_score/10%10;
						2039: v_data<=48+hit_score%10;
						2098: v_data<=48+miss_score%10;
						2097: v_data<=48+miss_score/10%10;
						2096: v_data<=48+miss_score/100;
						2095: v_data<=58;
						2094: v_data<=83;
						2093: v_data<=83;
						2092: v_data<=73;
						2091: v_data<=77;
						2061: if(sw) v_data<=0; else v_data<=84;
						2062: if(sw) v_data<=0; else v_data<=72;
						2063: if(sw) v_data<=0; else v_data<=69;
						2064: if(sw) v_data<=0; else v_data<=0;
						2065: if(sw) v_data<=0; else v_data<=87;
						2066: if(sw) v_data<=0; else v_data<=79;
						2067: if(sw) v_data<=0; else v_data<=82;
						2068: if(sw) v_data<=0; else v_data<=76;
						2069: if(sw) v_data<=0; else v_data<=68;
						2070: if(sw) v_data<=0; else v_data<=33;
						default: v_data<=0; 
					endcase
				end
				else if(update_cnt<2100)
				begin
					update_cnt<=update_cnt+1;
					update_cnt2<=0;
					update_signal3<=1'b1;
				end
				else if(update_cnt==2100)
				begin
					update_cnt<=0;
					update_signal2<=0;
				end
			end
		end
	end



	// generate random ascii code and location,and stores them in charset and charloc
	// Eliminate the character
	//
	wire [7:0] rand_char;
	wire [11:0] rand_loc;
	wire random_clk;
	wire en_clk;
	reg [6:0] cur_idx=7'b0;
	reg [28:0] modify_cnt=29'b0;
	//reg [7:0] kbdata;
	reg kb_signal=1'b0;
	reg [8:0] kb_cnt=9'b0;
	reg [7:0] cur_data;
	reg fall_signal=1'b0;
	reg [8:0] fall_cnt=9'b0;
	
	reg [28:0] MAX=200000000;
	reg [28:0] GEN_FREQ=40000000;
	reg [28:0] KB_FREQ=2500000;
	reg [28:0] FALL_FREQ=12500000;

	always @(level)
	begin
		case (level)
			1: 
			begin
				GEN_FREQ<=40000000;
				FALL_FREQ<=12500000;
			end
			2:
			begin
				GEN_FREQ<=25000000;
				FALL_FREQ<=10000000;				
			end
			3:
			begin
				GEN_FREQ<=12500000;
				FALL_FREQ<=6250000;
			end
			4:
			begin
				GEN_FREQ<=6250000;
				FALL_FREQ<=5000000;
			end
			default: 
			begin
				GEN_FREQ<=40000000;
				FALL_FREQ<=12500000;
			end
		endcase
	end
	
	clkgen #(25000000/6250000) gen_randomclk(clk,1'b0,1'b1,random_clk);		
	
	decode_hex h2(testascii[3:0],HEX2);
	decode_hex h3(testascii[7:4],HEX3);
	
	Random #(200,65,90) gen_randchar(
	.en(random_clk),
	.rst_n(1'b1),
	.srand(1'b0),
	.clk(clk),
	.out_num(rand_char)
	);
	
	Random #(100,72,137) gen_randloc(
	.en(random_clk),
	.rst_n(1'b1),
	.srand(1'b0),
	.clk(clk),
	.out_num(rand_loc[7:0])
	);
	
	reg [7:0]testascii;
	clkgen #(25000000/1) gen_gclk(clk,1'b0,sw,en_clk);				
	
	/*
	always @(posedge gen_clk)
	begin
		charset[cur_idx]<={1'b1,rand_char};
		charloc[cur_idx]<=rand_loc;
		cur_idx<=cur_idx+1;
	end
	*/

	always @(posedge en_clk)
	begin
		if(modify_cnt<MAX)
			modify_cnt<=modify_cnt+1;
		else if(modify_cnt==MAX)
			modify_cnt<=0;

		if(modify_cnt%GEN_FREQ==0)
		begin
			charset[cur_idx]<={1'b1,rand_char};
			charloc[cur_idx]<=rand_loc;
			cur_idx<=cur_idx+1;
		end

		if(modify_cnt%KB_FREQ==0)
		begin
			if(kbdata>=49&&kbdata<=52)
			begin
				level<=kbdata-48;
			end
			else if(kbdata!=0)
			begin
				kb_signal<=1'b1;
				kb_cnt<=0;
				cur_data<=kbdata;
			end
		end
		else if(kb_signal)
		begin
			if(kb_cnt<128)
			begin
				kb_cnt<=kb_cnt+1;
				if(charset[kb_cnt][8]&&charset[kb_cnt][7:0]==cur_data)
				begin
					kb_signal<=1'b0;
					kb_cnt<=0;
					cur_data<=0;
					charset[kb_cnt]<=0;
					hit_score<=hit_score+1;
				end
			end
			else if(kb_cnt==128)
			begin
				kb_signal<=1'b0;
				kb_cnt<=0;
				cur_data<=0;
			end
		end

		if(modify_cnt%FALL_FREQ==0)
		begin
			fall_signal<=1'b1;
			fall_cnt<=0;
		end
		else if(fall_signal)
		begin
			if(fall_cnt<128)
			begin
				fall_cnt<=fall_cnt+1;
				if(charset[fall_cnt][8])
				begin
					if(charloc[fall_cnt]>(2099-210))
					begin
						testascii <= charset[fall_cnt][7:0];
						charset[fall_cnt][8]<=1'b0;
						miss_score<=miss_score+1;
					end
					else 
					begin
						charloc[fall_cnt]<=charloc[fall_cnt]+70;
					end
				end
			end
			else if(fall_cnt==128)
			begin
				fall_cnt<=0;
				fall_signal<=1'b0;
			end
		end
	end

endmodule