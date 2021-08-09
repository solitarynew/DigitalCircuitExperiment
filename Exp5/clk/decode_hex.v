module decode_hex(hex_num,count,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [6:0] hex_num;
	input [19:0] count;
	output reg [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

	always @(count)
	begin
		case (count%10)
			0: HEX0=7'b1000000;
			1: HEX0=7'b1111001;
			2: HEX0=7'b0100100;
			3: HEX0=7'b0110000;
			4: HEX0=7'b0011001;
			5: HEX0=7'b0010010;
			6: HEX0=7'b0000010;
			7: HEX0=7'b1111000;
			8: HEX0=7'b0000000;
			9: HEX0=7'b0010000;
			default: HEX0=7'b1111111;
		endcase
		case ((count%hex_num)/10)
			0: HEX1=7'b1000000;
			1: HEX1=7'b1111001;
			2: HEX1=7'b0100100;
			3: HEX1=7'b0110000;
			4: HEX1=7'b0011001;
			5: HEX1=7'b0010010;
			6: HEX1=7'b0000010;
			7: HEX1=7'b1111000;
			8: HEX1=7'b0000000;
			9: HEX1=7'b0010000;
			default: HEX1=7'b1111111;
		endcase		
		case ((count/hex_num%60)%10)
			0: HEX2=7'b1000000;
			1: HEX2=7'b1111001;
			2: HEX2=7'b0100100;
			3: HEX2=7'b0110000;
			4: HEX2=7'b0011001;
			5: HEX2=7'b0010010;
			6: HEX2=7'b0000010;
			7: HEX2=7'b1111000;
			8: HEX2=7'b0000000;
			9: HEX2=7'b0010000;
			default: HEX2=7'b1111111;
		endcase	
		case ((count/hex_num%60)/10)
			0: HEX3=7'b1000000;
			1: HEX3=7'b1111001;
			2: HEX3=7'b0100100;
			3: HEX3=7'b0110000;
			4: HEX3=7'b0011001;
			5: HEX3=7'b0010010;
			6: HEX3=7'b0000010;
			7: HEX3=7'b1111000;
			8: HEX3=7'b0000000;
			9: HEX3=7'b0010000;
			default: HEX3=7'b1111111;
		endcase		
		case ((count/hex_num/60)%10)
			0: HEX4=7'b1000000;
			1: HEX4=7'b1111001;
			2: HEX4=7'b0100100;
			3: HEX4=7'b0110000;
			4: HEX4=7'b0011001;
			5: HEX4=7'b0010010;
			6: HEX4=7'b0000010;
			7: HEX4=7'b1111000;
			8: HEX4=7'b0000000;
			9: HEX4=7'b0010000;
			default: HEX4=7'b1111111;
		endcase		
		case ((count/hex_num/60)/10)
			0: HEX5=7'b1000000;
			1: HEX5=7'b1111001;
			2: HEX5=7'b0100100;
			3: HEX5=7'b0110000;
			4: HEX5=7'b0011001;
			5: HEX5=7'b0010010;
			6: HEX5=7'b0000010;
			7: HEX5=7'b1111000;
			8: HEX5=7'b0000000;
			9: HEX5=7'b0010000;
			default: HEX5=7'b1111111;
		endcase			
	end



endmodule