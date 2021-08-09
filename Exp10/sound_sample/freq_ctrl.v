module freq_ctrl(clk,reset,ps2_clk,ps2_data,volume,freq,HEX2,HEX3,HEX4,HEX5,tag);
	input clk,reset;
	input ps2_clk,ps2_data;
	output reg [6:0] HEX2,HEX3,HEX4,HEX5;
	output reg [6:0] volume;
	output reg [15:0] freq;
	wire [7:0] kbdata;
	wire [7:0] data;
	wire ready;
	reg nextdata_n;
	reg break;
	reg [15:0] rom [7:0];
	reg [2:0] count;

	output reg [7:0] tag;		//state

	
	initial begin
		rom[0]=16'd714;
		rom[1]=16'd801;
		rom[2]=16'd900;
		rom[3]=16'd953;
		rom[4]=16'd1070;
		rom[5]=16'd1201;
		rom[6]=16'd1348;
		rom[7]=16'd1428;
		count<=0;
		volume<=7'h79;	
		freq<=16'h0;
		break<=1'b0;
		tag<=8'b0;
	end

	ps2_keyboard i(.clk(clk),.clrn(1'b1),.ps2_clk(ps2_clk),.ps2_data(ps2_data),.data(data),.nextdata_n(1'b0),.ready(ready));
	

	
	 
	//decode_hex(volume[3:0],HEX0);
	//decode_hex(volume[6:4],HEX1);
	decode_hex(freq[3:0],HEX2);
	decode_hex(freq[7:4],HEX3);
	decode_hex(freq[11:8],HEX4);
	decode_hex(freq[15:12],HEX5);
	
	always @ (posedge clk) 
	begin
	   if (data == 8'hf0) 
		begin
			break<=1'b1;
		end
		else if (break && data != 0) 
		begin
			break<=1'b0;
			case(data)
				8'h21:begin if(tag[0]==1'b1)count<=count-1;tag[0]=1'b0; end
				8'h23:begin if(tag[1]==1'b1)count<=count-1;tag[1]=1'b0; end
				8'h24:begin if(tag[2]==1'b1)count<=count-1;tag[2]=1'b0; end
				8'h2b:begin if(tag[3]==1'b1)count<=count-1;tag[3]=1'b0; end
				8'h34:begin if(tag[4]==1'b1)count<=count-1;tag[4]=1'b0; end
				8'h1c:begin if(tag[5]==1'b1)count<=count-1;tag[5]=1'b0; end
				8'h32:begin if(tag[6]==1'b1)count<=count-1;tag[6]=1'b0; end
				8'h2a:begin if(tag[7]==1'b1)count<=count-1;tag[7]=1'b0; end
				default:tag<=tag;
			endcase
		end
		else
		case(data)
			8'h21:begin if(tag[0]==1'b0)count<=count+1;tag[0]=1'b1; end
			8'h23:begin if(tag[1]==1'b0)count<=count+1;tag[1]=1'b1; end
			8'h24:begin if(tag[2]==1'b0)count<=count+1;tag[2]=1'b1; end
			8'h2b:begin if(tag[3]==1'b0)count<=count+1;tag[3]=1'b1; end
			8'h34:begin if(tag[4]==1'b0)count<=count+1;tag[4]=1'b1; end
			8'h1c:begin if(tag[5]==1'b0)count<=count+1;tag[5]=1'b1; end
			8'h32:begin if(tag[6]==1'b0)count<=count+1;tag[6]=1'b1; end
			8'h2a:begin if(tag[7]==1'b0)count<=count+1;tag[7]=1'b1; end
			8'h72: 					
			begin
				if(volume==7'h0)
					volume<=volume;
				else
					volume<=volume-7'h1;
				tag<=tag;
			end
			8'h75: 					
			begin
				if(volume==7'h7f)
					volume<=volume;
				else
					volume<=volume+7'h1;
				tag<=tag;				
			end
			default: tag<=tag;
		endcase
	end	
	
	/*
	always @ (tag) 
	begin
		reg [2:0] count;
		integer j;
		count<=3'b0;
		for(j=0;j<8;j=j+1)
		begin
			if(tag[j]!=0)
			begin
				count<=count+1;
				//freq<=((freq/(count+1)*count)+(rom[j]/(count+1)));
			end
		end
		freq<=count;
	end*/
	
	
	always @(tag)
	begin
		if(tag==0)
			freq<=0;
		else
		begin
			freq<=((tag[0]==1?rom[0]:0)+(tag[1]==1?rom[1]:0)+(tag[2]==1?rom[2]:0)+(tag[3]==1?rom[3]:0)+\(tag[4]==1?rom[4]:0)+(tag[5]==1?rom[5]:0)+(tag[6]==1?rom[6]:0)+(tag[7]==1?rom[7]:0))/count;
		end
	end
	
	
	/*
	always @(tag)
	begin
		integer j;
		count<=3'b0;
		for(j=0;j<8;j=j+1)
		begin
			if(tag[j]!=0)
			count<=count+1;
		end
	end
	*/
	
	
	
	
	
	
	
	
	
	
	
	
	
	/*
	always @ (posedge clk) 
	begin
	   if (data == 8'hf0) 
		begin
			break<=1'b1;
		end
		else if (break && data != 0) 
		begin
			break<=1'b0;
			freq<=16'h0;
		end
		else
		case(data)
			8'h21:freq<=16'd714;
			8'h23:freq<=16'd801;
			8'h24:freq<=16'd900;
			8'h2b:freq<=16'd953;
			8'h34:freq<=16'd1070;
			8'h1c:freq<=16'd1201;
			8'h32:freq<=16'd1348;
			8'h2a:freq<=16'd1428;
			8'h72: 					
			begin
				if(volume==7'h0)
					volume<=volume;
				else
					volume<=volume-7'h1;
				freq<=freq;	
			end
			8'h75: 					
			begin
				if(volume==7'h7f)
					volume<=volume;
				else
					volume<=volume+7'h1;
				freq<=freq;					
			end
			default: freq <= freq;			// others
		endcase
	end	
	*/
	
	
	/*
	always @(data)
	begin
	if(data==0)
	begin
		freq<=freq;
	end
	else
	begin
		if(data==8'hf0)
		begin
			break<=1'b1;
		end
		else if(break==1'b1)
		begin
			break<=1'b0;
			freq<=16'h0;
		end
		else
		begin
			case (data)
				8'h21:freq<=16'd714;
				8'h23:freq<=16'd801;
				8'h24:freq<=16'd900;
				8'h2b:freq<=16'd953;
				8'h34:freq<=16'd1070;
				8'h1c:freq<=16'd1201;
				8'h32:freq<=16'd1348;
				8'h2a:freq<=16'd1428;		//V
				8'h72:							//2
				begin
					if(volume==7'h0)
						volume<=volume;
					else
						volume<=volume-7'h1;
						freq<=freq;
				end
				8'h75:							//8
				begin
					if(volume==7'h7f)
						volume<=volume;
					else
						volume<=volume+7'h1;
						freq<=freq;					
					end
				default:freq<=freq;
			endcase
		end
	end
	end
	*/

endmodule