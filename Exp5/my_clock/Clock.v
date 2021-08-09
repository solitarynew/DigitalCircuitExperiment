module Clock(pow,clk,alt_s,alt_m,alt_h,clk_1s,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input pow,clk;
	input alt_s,alt_m,alt_h;
	output reg clk_1s;
	output  reg [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	reg [16:0] count;
	reg [24:0] count_clk;
	initial begin
	count_clk=0;
	count=85680;
	clk_1s=0;
	end	
	
	always @(posedge clk)
	begin
		if(count_clk==25000000)
		begin
			clk_1s<=~clk_1s;
			count_clk<=0;
		end
		else
			count_clk<=count_clk+1;
	end
	
	always @(posedge clk_1s , negedge alt_h , negedge alt_m , negedge alt_s)
	begin
		if(!alt_s)
			count<=count+1;
		else if(!alt_m)
			count<=count+1;
		else if(!alt_h)
			count<=count+1;
		else if(count>=86399)
		begin
			count<=0;
		end
		else
		begin
			count<=count+1;	
		end
	end
	
	always @(count)
	begin
		case (count%10)
			0: HEX0=7'b1000000;
			1: HEX0=7'b1111001;
			2: HEX0=7'b0100100;
			3: HEX0=7'b0110000;
			4: HEX0=7'b0011001;
			5: HEX0=7'b0010010;
			6: HEX0=7'b0000010;
			7: HEX0=7'b1111000;
			8: HEX0=7'b0000000;
			9: HEX0=7'b0010000;
			default: HEX0=7'b1111111;
		endcase
		case ((count%60)/10)
			0: HEX1=7'b1000000;
			1: HEX1=7'b1111001;
			2: HEX1=7'b0100100;
			3: HEX1=7'b0110000;
			4: HEX1=7'b0011001;
			5: HEX1=7'b0010010;
			6: HEX1=7'b0000010;
			7: HEX1=7'b1111000;
			8: HEX1=7'b0000000;
			9: HEX1=7'b0010000;
			default: HEX1=7'b1111111;
		endcase		
		case ((count/60%60)%10)
			0: HEX2=7'b1000000;
			1: HEX2=7'b1111001;
			2: HEX2=7'b0100100;
			3: HEX2=7'b0110000;
			4: HEX2=7'b0011001;
			5: HEX2=7'b0010010;
			6: HEX2=7'b0000010;
			7: HEX2=7'b1111000;
			8: HEX2=7'b0000000;
			9: HEX2=7'b0010000;
			default: HEX2=7'b1111111;
		endcase	
		case ((count/60%60)/10)
			0: HEX3=7'b1000000;
			1: HEX3=7'b1111001;
			2: HEX3=7'b0100100;
			3: HEX3=7'b0110000;
			4: HEX3=7'b0011001;
			5: HEX3=7'b0010010;
			6: HEX3=7'b0000010;
			7: HEX3=7'b1111000;
			8: HEX3=7'b0000000;
			9: HEX3=7'b0010000;
			default: HEX3=7'b1111111;
		endcase		
		case ((count/3600)%10)
			0: HEX4=7'b1000000;
			1: HEX4=7'b1111001;
			2: HEX4=7'b0100100;
			3: HEX4=7'b0110000;
			4: HEX4=7'b0011001;
			5: HEX4=7'b0010010;
			6: HEX4=7'b0000010;
			7: HEX4=7'b1111000;
			8: HEX4=7'b0000000;
			9: HEX4=7'b0010000;
			default: HEX4=7'b1111111;
		endcase		
		case ((count/3600)/10)
			0: HEX5=7'b1000000;
			1: HEX5=7'b1111001;
			2: HEX5=7'b0100100;
			3: HEX5=7'b0110000;
			4: HEX5=7'b0011001;
			5: HEX5=7'b0010010;
			6: HEX5=7'b0000010;
			7: HEX5=7'b1111000;
			8: HEX5=7'b0000000;
			9: HEX5=7'b0010000;
			default: HEX5=7'b1111111;
		endcase			
	end
	
endmodule