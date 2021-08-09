module getcolor(clk,vga_clk,ps2_clk,ps2_data,h_addr,v_addr,vga_data,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,blank);
	
	input clk;
	input vga_clk;
	input ps2_clk,ps2_data;
	input [9:0] h_addr;
	input [9:0] v_addr;
	output reg [23:0] vga_data;
	output reg [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	//reg [11:0] ram [4095:0];
	reg [11:0] addr;
	reg [11:0] line;
	//reg [7:0] ascii [2099:0];
	//reg [11:0] data;
	output reg blank;
	wire ready;
	wire [7:0] data;
	reg [11:0] cnt;
	reg [11:0] idx;
	reg break;
	reg we;
	wire [7:0] q;
	reg [7:0] code;
	wire [10:0] font;
	//reg shift;
	//reg caps;
	
	initial begin
		vga_data=24'h000000;
		blank=1'b1;
		//$readmemh("D:/data/Homework/FPGA/Exp/Exp11/ASCII_INPUT/vga_font.txt",ram,0,4095);
		//ascii[0]=68;
		cnt=12'b0;
		idx=12'b0;
		break=1'b0;
		//caps=1'b0;
		//font=11'b0;
	end
	
	(* ram_init_file = "ascii.mif" *)reg [7:0] a [255:0];
	ps2_keyboard i(.clk(vga_clk),.clrn(1'b1),.ps2_clk(ps2_clk),.ps2_data(ps2_data),.data(data),.nextdata_n(1'b0),.ready(ready));
	display d(vga_clk,code,addr,idx,we,q);
	font_data fram(line,vga_clk,0,0,font);
	
	always @(vga_clk)
	begin
		addr<=(h_addr/9)+(v_addr>>4)*70;
		line<=v_addr[3:0]+(q<<4);
	end
	
	
	always @(h_addr or v_addr)
	begin
		blank<=font[(h_addr+7)%9];
	end
	
	
	decode_hex hex0(code[3:0],HEX0);			//why?
	decode_hex hex1(code[7:4],HEX1);
	decode_hex hex2(idx[3:0],HEX2);
	decode_hex hex3(idx[7:4],HEX3);
	decode_hex hex4(cnt[3:0],HEX4);
	decode_hex hex5(cnt[7:4],HEX5);
	
	
	always @(h_addr or v_addr)			//clk??
	begin
		if(blank && (h_addr<630))
			vga_data<=24'hffffff;
		else 
			vga_data<=24'h000000;
	end
	
	

	
	always @ (posedge vga_clk) 
	begin
	   if (data == 8'hf0) 
		begin
			break<=1'b1;
		end
		else if (break && data != 0) 
		begin
			break<=1'b0;
		end
		else
		begin
			if(data!=0)
			begin
				if(data==8'h5a)
				begin
					idx<=cnt;
					cnt<=(cnt+70)/70*70;
					we<=0;
				end
				else
				begin
					we<=1;
					idx<=cnt;
					cnt<=cnt+1;
					//if(caps&&a[data]>=8'h61&&a[data]<=8'h7a)
					//	code<=a[data]-8'h20;
					//else
					code<=a[data];
				end
			end
			else 
			begin
				we<=0;
			end
		end
		
		if(cnt>=2100)
		begin
			cnt<=0;
			idx<=0;
		end
	end
	
	

endmodule