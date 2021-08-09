module Clock(clk,clk_1s,HEX);
	input clk;
	output reg clk_1s;
	output HEX;
	reg [6:0] HEX[0:5];
	reg [7:0] count;
	reg [16:0] count_clk;
	initial begin
	count_clk=0;
	count=0;
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
	
	always @(posedge clk_1s)
	begin
		if(count==86399)
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