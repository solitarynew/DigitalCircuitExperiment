module encode83(x,en,y,is_input,HEX);
	input [7:0] x;
	input en;
	output reg [2:0] y;
	output reg is_input;
	output reg [6:0] HEX;
	integer i;
	always @(x or en) 
		begin
			if(en) 
				begin
					is_input=0;
					y=0;
					for(i=0;i<=7;i=i+1)
						if(x[i]==1) 
							begin 
								y=i;
								is_input=1;
							end
				end
			else
				begin
					y=0;
					is_input=0;
				end
			case (y)
				0: HEX=7'b1000000;
				1: HEX=7'b1111001;
				2: HEX=7'b0100100;
				3: HEX=7'b0110000;
				4: HEX=7'b0011001;
				5: HEX=7'b0010010;
				6: HEX=7'b0000010;
				7: HEX=7'b1111000;
				default: HEX=7'b1111111;
			endcase
		end
endmodule


//use casez
// case (x)
//		8'b1???????:y=7;
//		8'b01??????:y=6;
//		8'b001?????:y=5;	
//		8'b0001????:y=4;	
//		8'b00001???:y=3;	
//		8'b000001??:y=2;
//		8'b0000001?:y=1;
//		8'b00000001:y=0;
//		default:y=0;
// endcase