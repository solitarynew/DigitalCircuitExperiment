module div(clk,clk_1s);
	input clk;
	output reg clk_1s;
	reg [24:0] count_clk;
	initial begin
		count_clk=0;
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


endmodule



module m_clock(clk,clk_1s);
	input clk;
	output clk_1s;
	
	
	div d(clk,clk_1s);
	

endmodule