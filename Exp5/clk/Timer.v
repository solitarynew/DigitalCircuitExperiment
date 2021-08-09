module Timer(clk_10ms,en,str,pas,clr,count);
	input clk_10ms;
	input [1:0] en;
	input str,pas,clr;
	output reg [19:0] count;
	reg pow;
	
	initial begin
	count=0;
	pow=0;
	end	


	always @(posedge clk_10ms or negedge clr)
	begin
		if(!clr)
		begin
			if(en==1)			
				count<=0;
		end
		else if(!pow)
				count<=count;
		else if(count==600000)
		begin
				count<=0;
		end
		else
		begin
				count<=count+1;	
		end
	end	
	
	always @(negedge str or negedge pas)
	begin
		if(!pas)
		begin
			if(en==1)
				pow<=0;
		end
		else if(en==1)
				pow<=1;
	end	
	
	
	
endmodule 