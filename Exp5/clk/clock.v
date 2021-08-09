module clock(clk_1s,en,alt_s,alt_m,alt_h,count/*,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5*/);
	input clk_1s;
	input [1:0] en;
	input alt_s,alt_m,alt_h;
	output reg [19:0] count;
	//output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	
	initial begin
	count=0;
	end	
	
	//一个always只能有一个主时钟信号，其余为控制信号
	always @(posedge clk_1s/*, negedge alt_s,negedge alt_m,negedge alt_h*/)
	begin
		if(!alt_h)
		begin
			if(en==0)
				count<=count+3600;
		end
		else	if(!alt_m)
		begin
			if(en==0)
				count<=count+60;
		end
		else	if(!alt_s)
		begin
			if(en==0)
			begin
				count<=count+2;
			end
		end	
		else if(count>86398)
		begin
			count<=count-86399;
		end
		else
		begin
			count<=count+1;
		end
	
	end
	


endmodule