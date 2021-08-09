module ascii2 #(parameter Caps=8'h58,parameter Shift=8'h12,parameter Ctrl=8'h14,parameter Break=8'hf0,parameter None=8'hff)
					(reset,nextdata_n,data,ready,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,caps,shift,ctrl,state);
	input reset;
	input nextdata_n;
	input [7:0] data;
	input ready;
	output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	reg [7:0] ascii;
	reg [7:0] count;
	//reg n_cnt;
	//reg is_over;
	output reg [1:0] state;
	output reg caps,shift,ctrl;
	reg is_last_f0;
	reg is_caps;
	//reg [7:0] cur_data;
	
	wire en;
	(* ram_init_file = "ascii.mif" *)reg [7:0] myrom [255:0];
	
	parameter S0=0,S1=1;
	initial begin
		count=0;
		state=S0;
		caps=0;
		shift=0;
		ctrl=0;
		is_last_f0=0;
		is_caps=0;
	end
	

	

	assign en=~(caps==0&&shift==0&&ctrl==0&&state==0);
	
	decode_hex d_hex0(data[3:0],en,HEX0);
	decode_hex d_hex1(data[7:4],en,HEX1);
	
	always @(posedge ready)
	begin
		if(reset)
		begin
		count=0;
		state=S0;
		caps=0;
		shift=0;
		ctrl=0;
		is_last_f0=0;
		is_caps=0;
		end else begin
		ascii<=myrom[data];
		if(data==Break)
		begin
			is_last_f0<=1;
		end
		else
		begin
			if(data==Caps)
			begin
				if(is_last_f0==1)
				begin
					caps<=0;
					is_last_f0<=0;
				end
				else
				begin
					if(caps==0)
					begin
						count<=count+1;
						is_caps<=~is_caps;
					end
					caps<=1;
				end	
			end
			else if(data==Shift)
			begin
				if(is_last_f0==1)
				begin
					shift<=0;
					is_last_f0<=0;
				end
				else
				begin
					if(shift==0)
					begin
						count<=count+1;
					end
					shift<=1;
				end
			end			
			else if(data==Ctrl)
			begin
				if(is_last_f0==1)
				begin
					ctrl<=0;
					is_last_f0<=0;
				end
				else
				begin
					if(ctrl==0)
					begin
						count<=count+1;
					end
					ctrl<=1;
				end
			end
			else
			begin
				if(is_last_f0==1)
				begin
					state<=0;
					is_last_f0<=0;
				end
				else
				begin
					if(state==0)
					begin
						count<=count+1;
					end
					state<=1;
				end		
			end
		end end
	end
	

	
	
	decode_ascii_hex d_hex2(ascii[3:0],en,is_caps,shift,HEX2);
	decode_ascii_hex d_hex3(ascii[7:4],en,is_caps,shift,HEX3);
	
	decode_hex d_hex4(count[3:0],1'b1,HEX4);
	decode_hex d_hex5(count[7:4],1'b1,HEX5);
	
endmodule