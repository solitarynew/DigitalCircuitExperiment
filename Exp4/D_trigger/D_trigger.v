module D_trigger(clk,in_d,en,clr,out_q1,out_q2);
	input clk;
	input in_d;
	input en;
	input clr;
	output out_q1;
	output out_q2;
	
	D_synctrigger D_trigger1(.clk(clk),.in_d(in_d),.en(en),.clr(clr),.out_q(out_q1));
	D_asynctrigger D_trigger2(.clk(clk),.in_d(in_d),.en(en),.clr(clr),.out_q(out_q2));
	
endmodule