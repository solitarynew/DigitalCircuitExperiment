	always @(posedge en_clk)
	begin
		if(modify_cnt<MAX)...
		else if(modify_cnt==MAX)...

		if(modify_cnt%GEN_FREQ==0)
		begin...
		end

		if(modify_cnt%KB_FREQ==0)
		begin...
		end
		else if(kb_signal)
		begin
			if(kb_cnt<128)
			begin...
			end
			else if(kb_cnt==128)
			begin...
			end
		end

		if(modify_cnt%FALL_FREQ==0)
		begin...
		end
		else if(fall_signal)
		begin
			if(fall_cnt<128)
			begin...
			end
			else if(fall_cnt==128)
			begin...
			end
		end

		if(light_idx!=0)
		begin
			if(light_cnt<12500000)...
			else
			begin...
			end			
		end
	end