module alarm(clk_1s,en,alt_s,alt_m,alt_h,count);
	input  clk_1s;
	input [1:0] en;
	input alt_s,alt_m,alt_h;
	output reg [19:0] count;
	
	initial begin
	count=0;
	end

	always @(posedge clk_1s)
	begin
		if(!alt_h)
		begin
			if(en==2||en==3)
				count<=count+3600;
		end
		else	if(!alt_m)
		begin
			if(en==2||en==3)
				count<=count+60;
		end
		else	if(!alt_s)
		begin
			if(en==2||en==3)
				count<=count+1;
		end	
		else if(count>86398)
		begin
			count<=count-86399;
		end
		else
		begin
			count<=count;
		end
	
	end	

endmodule