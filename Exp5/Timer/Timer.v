module Timer(clk,str,pas,clr,of,clk_1s,HEX0,HEX1);
	input clk;
	input str,pas,clr;
	output reg clk_1s,of;
	output reg [6:0] HEX0;
	output reg [6:0] HEX1;
	reg [7:0] count;
	reg [24:0] count_clk;
	reg en;
	
	initial begin
	count_clk=0;
	count=0;
	en=0;
	end
	
	always @(posedge clk or negedge clr)
	begin
			if(!clr)
				count_clk<=0;
			else if(count_clk==25000000)
			begin
				clk_1s<=~clk_1s;
				count_clk<=0;
			end
			else
				count_clk<=count_clk+1;			
	end
		
		
	always @(posedge clk_1s or negedge clr)
	begin
		if(!clr)
			count<=0;
		else if(!en)
			count<=count;
		else if(count==99)
		begin
			count<=0;
			of<=1;
		end
		else
		begin
			count<=count+1;	
			of<=0;
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
		case ((count-count%10)/10)
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
		
	end
	
	always @(negedge str or negedge pas)
	begin
		if(!pas)
			en<=0;
		else
			en<=1;
	end
	
	


endmodule