module shift_register(clk,cin,select,load,out);
	input clk,cin;
	input [2:0] select;
	input [7:0] load;
	output reg [7:0] out;


	always @(posedge clk)
	begin
		case(select)
		3'b000:out<=8'b00000000;
		3'b001:out<=load;
		3'b010:out<={1'b0,out[7:1]};
		3'b011:out<={out[6:0],1'b0};
		3'b100:out<={out[7],out[7:1]};
		3'b101:out<={cin,out[7:1]};
		3'b110:out<={out[0],out[7:1]};
		3'b111:out<={out[6:0],out[7]};
		default:out<=8'b11111111;
		endcase
	end

endmodule