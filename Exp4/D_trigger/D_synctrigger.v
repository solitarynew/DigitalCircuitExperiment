module D_synctrigger(clk,in_d,en,clr,out_q);
	input clk;
	input in_d;
	input en;
	input clr;
	output reg out_q;
	
	always @(posedge clk )
	begin
		if(en)
		begin
			if(clr)
				out_q<=0;
			else
				out_q<=in_d;
		end
		else
			out_q<=out_q;
	end
endmodule