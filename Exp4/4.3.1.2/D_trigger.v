module D_trigger(clk,in_d,en,out_q);
	input clk;
	input in_d;
	input en;
	output reg out_q;

	always @(posedge clk)
		if(en)
			out_q<=in_d;
		else
			out_q<=out_q;
endmodule