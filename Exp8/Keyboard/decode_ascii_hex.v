module decode_ascii_hex(in,en,is_caps,shift,HEX);
	input [3:0] in;
	input en;
	input shift,is_caps;
	output reg [6:0] HEX;
	
	wire is_upper;
	wire [3:0] _in;
	
	
	assign is_upper=shift^is_caps;
	
	assign _in=(in<=8'h7a&&in>=8'h61)?(is_upper?(in-32):in):in;
		
	
	always @(_in or en)
	begin
		if(en)
			case (_in)
			0: HEX=7'b1000000;
			1: HEX=7'b1111001;
			2: HEX=7'b0100100;
			3: HEX=7'b0110000;
			4: HEX=7'b0011001;
			5: HEX=7'b0010010;
			6: HEX=7'b0000010;
			7: HEX=7'b1111000;
			8: HEX=7'b0000000;
			9: HEX=7'b0010000;
			10:HEX=7'b0001000;
			11:HEX=7'b0000011;
			12:HEX=7'b1000110;
			13:HEX=7'b0100001;
			14:HEX=7'b0000110;
			15:HEX=7'b0001110;
			default: HEX=7'b1111111;
			endcase	
		else
			HEX=7'b1111111;	
	end
endmodule