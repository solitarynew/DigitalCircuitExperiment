module div(clk,clk_1s);
	parameter max=25000000;
	input clk;
	output reg clk_1s;
	reg [24:0] count_clk;
	
	initial begin
		count_clk=0;
		clk_1s=0;
	end
	
	always @(posedge clk)
	begin
		if(count_clk==max)
		begin
			clk_1s<=~clk_1s;
			count_clk<=0;
		end
		else
			count_clk<=count_clk+1;
	end


endmodule



