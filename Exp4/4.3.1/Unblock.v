module Unblock(clk,in_en,in_d,out_unlock1,out_unlock2);
input clk,in_en,in_d;
output reg out_unlock1,out_unlock2;

always @(posedge clk)
begin
	if(in_en)
	begin
		out_unlock1<=in_d;
		out_unlock2<=out_unlock1;
	end
	else
	begin
		out_unlock1<=out_unlock1;
		out_unlock2<=out_unlock2;
	end
end

endmodule