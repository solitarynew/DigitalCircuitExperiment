module Block(clk,in_en,in_d,out_lock1,out_lock2);
input clk,in_en,in_d;
output reg out_lock1,out_lock2;

always @(posedge clk)
begin
	if(in_en)
	begin
		out_lock1=in_d;
		out_lock2=out_lock1;
	end
	else
	begin
		out_lock1=out_lock1;
		out_lock2=out_lock2;
	end
end

endmodule