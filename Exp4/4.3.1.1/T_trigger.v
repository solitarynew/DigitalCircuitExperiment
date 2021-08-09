module T_trigger(clk,in_t,en,out_q);
	input clk;
	input in_t;
	input en;
	output reg out_q;
	
	always @(posedge clk)
		if(en)
			out_q=in_t^out_q;
		else
			out_q=out_q;
endmodule
