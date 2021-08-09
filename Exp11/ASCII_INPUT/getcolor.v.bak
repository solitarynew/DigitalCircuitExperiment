module getcolor(input clk,input [9:0] h_addr,input [9:0] v_addr,output reg [23:0] vga_data);
	
	wire [18:0] addr;
	wire [11:0] data;
	
	initial begin
		vga_data=24'h000000;
	end
	
	assign addr={h_addr,v_addr[8:0]};
	myrom rom(addr,clk,data);
	
	always @(h_addr or v_addr)
	begin
		vga_data<={data[11:8],4'b0000,data[7:4],4'b0000,data[3:0],4'b0000};
	end

endmodule