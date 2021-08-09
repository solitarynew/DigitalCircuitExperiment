module keyboardTop(clk,ps2_clk,ps2_data,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,spekey,clrn,testcase,data,ready);
	input clk,ps2_clk,ps2_data;
	input clrn;
	output [3:0]spekey;//SW[9:6],SW[9] is not used
	output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	wire [7:0] asdata, kbdata;
	output ready;
	wire overflow; // fifo overflow
	
	//wire [7:0] times;
reg nextdata_n;
output reg [7:0] data;
output reg [2:0] testcase;

//test
always @ (data)
begin
	case(data)
	8'h12: testcase <= 1;
	8'h14: testcase <= 2;
	8'h58: testcase <= 3;
	8'hf0: testcase <= 4;
	
	default: testcase <= 0;
	endcase
end


always @ (posedge ps2_clk)
begin
	if(ready)
	begin
		data <= kbdata;
		nextdata_n <= 0;
	end
	else begin
		data <= data;
		nextdata_n <= 1;
	end
end

//call modules

	Keyboard k1(.clk(clk),.clrn(clrn),.ps2_clk(ps2_clk),
	.ps2_data(ps2_data),.data(kbdata),.ready(ready),
	.nextdata_n(nextdata_n),.overflow(overflow));/**/
	
	toASCII t1(.data(data), .asdata(asdata));
	
	display d1(.clk(clk),.HEX0(HEX0),.HEX1(HEX1),.HEX2(HEX2),.HEX3(HEX3),.HEX4(HEX4),.HEX5(HEX5),
	.data(data),.asdata(asdata),.spekey(spekey));

	
endmodule 