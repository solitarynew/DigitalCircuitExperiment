module trigger(clk,in_en,in_d,out_lock1,out_lock2,out_unlock1,out_unlock2);
input clk,in_en,in_d;
output out_lock1,out_lock2,out_unlock1,out_unlock2;

Block block(clk,in_en,in_d,out_lock1,out_lock2);
Unblock unblock(clk,in_en,in_d,out_unlock1,out_unlock2);


endmodule