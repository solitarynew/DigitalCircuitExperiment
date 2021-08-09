module ps2_keyboard(clk,clrn,ps2_clk,ps2_data,data,nextdata_n,ready);
	input clk,clrn,ps2_clk,ps2_data; 
	input nextdata_n; 
	output [7:0] data; 
	output reg ready;
	reg overflow;	// fifo overflow 
	// internal signal, for test 
	reg [9:0] buffer;	// ps2_data bits
	reg [7:0] fifo[7:0];	// data fifo
	reg [2:0] w_ptr,r_ptr;	// fifo write and read pointers
	reg [3:0] count; // count ps2_data bits 
	// detect falling edge of ps2_clk 
	reg [2:0] ps2_clk_sync;
	integer i;
	
	initial begin
		for(i = 0; i < 8 ; i = i + 1)
			fifo[i] = 0;
	end
	
	always @(posedge clk) 
	begin 
		ps2_clk_sync <= {ps2_clk_sync[1:0],ps2_clk}; 
	end

	
	wire sampling = ps2_clk_sync[2] & ~ps2_clk_sync[1];

	
	always @(posedge clk) 
	begin 
		if (clrn == 0) // reset
		begin  
				count <= 0; w_ptr <= 0; r_ptr <= 0; overflow <= 0; ready<= 0; 
		end 
		else 
		begin
			if ( ready ) // read to output next data 
			begin 
				if(nextdata_n == 1'b0) //read next data 
				begin
					fifo[r_ptr] = 0;
					r_ptr <= r_ptr + 3'b1;
					if(w_ptr==(r_ptr+1'b1)) //empty 
						ready <= 1'b0;
				end 
			end 
			if (sampling) 
			begin 
				if (count == 4'd10) 
				begin
					if ((buffer[0] == 0) && (ps2_data) && (^buffer[9:1])) 
					begin 
						fifo[w_ptr] <= buffer[8:1]; // kbd scan code 
						w_ptr <= w_ptr+3'b1; 
						ready <= 1'b1;
						overflow <= overflow | (r_ptr == (w_ptr + 3'b1)); 
					end 
					count <= 0;	// for next
				end 
				else 
				begin
					buffer[count] <= ps2_data; // store ps2_data 
					count <= count + 3'b1;
				end 
			end 
		end 
	end 
	
	assign data = fifo[r_ptr]; //always set output data
	
endmodule