module out(kbdata,ps2_clk,ready,data,nextdata_n);
	input [7:0] kbdata;
	input ps2_clk,ready;
	output reg [7:0] data;
	output reg nextdata_n;
	
	
	initial 
	begin
		nextdata_n<=1;	
		data<=8'b00000000; 
	end
	
	always @(ps2_clk)
	begin
		if(ready)
		begin
			nextdata_n<=0;
			data<=kbdata;
		end
		else
		begin
			nextdata_n<=1;		
		end
	end

endmodule