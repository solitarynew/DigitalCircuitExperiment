module D_asynctrigger(clk,in_d,en,clr,out_q);
	input clk;
	input in_d;
	input en;
	input clr;
	output reg out_q;
	always @(posedge clk or posedge clr)
	begin
		if(clr)
		begin
			if(en)
				out_q<=0;
			else
				out_q<=out_q;
		end
		else
		begin
			if(en)
				out_q<=in_d;
			else
				out_q<=out_q;	
		end
			
			
	end


endmodule