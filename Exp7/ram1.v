module ram1(clk,din,inaddr,outaddr,we,dout);
	input clk;
	input [7:0] din;
	input [3:0] inaddr,outaddr;
	input we;
	output reg [7:0] dout;
	reg [7:0] ram [15:0];
	

	initial begin
		$readmemh("D:/data/Homework/FPGA/Exp/Exp7/mem1.txt",ram,0,15);
	
	end

	always@ (posedge clk)
	begin
		if(we)
			ram[inaddr]<=din;
		else
		dout<=ram[outaddr];
	end

endmodule