module getcolor(input [9:0] h_addr,input [9:0] v_addr,output reg [23:0] vga_data);
	
	initial begin
		vga_data=24'h000000;
	end
		
	
	always @(h_addr)
	begin
		if(h_addr>240 && h_addr<260)
			vga_data<=24'hFF3300;
		else if(h_addr>400 && h_addr<420)
			vga_data<=24'h0066FF;
		else
			vga_data<=24'h000000;
	end

endmodule