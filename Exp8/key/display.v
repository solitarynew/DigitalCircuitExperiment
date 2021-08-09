//This module put value in HEXS
//meanwhile, this module should act as simple state machine
module display(clk,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,data,asdata,spekey);
	output reg [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	output reg [3:0]spekey;
	input clk;
	input [7:0] data, asdata;
	
	
//inner signals
reg [3:0]offset; //capital to lowercase
reg [7:0]times;
reg [7:0]state;
reg up;
reg [7:0]myasdata;
reg [7:0]curdata;
reg [7:0]count;
//reg [7:0]shiftcount;
//reg [7:0]ctrlcount;
//reg capscount;


//states
parameter 
shiftready = 8'b00000001, //when shift is pressed down, display corresponding symbols
//this state is on until shift is released
ctrlready = 8'b00000010, //when ctrl is pressed down
//this state is on until shift is released
capsready = 8'b00000100, //when tab is pressed down, corresponding ascii code adds an offset of -32 or -2 in hex
//this state is on untin tab is pressed again.
nostate = 8'b00001000, //this state does nothing spetial
shiftctrl = 8'b00010000,
shiftcaps = 8'b00100000,
ctrlcaps = 8'b01000000,
allstates = 8'b10000000;


//initial module
initial
begin
offset = 0;
times = 0;
state = nostate;
up = 0;
myasdata = 0;
count = 0;
end



//always module
//assign spekey
always @ (posedge clk)
begin
	case(state)
	nostate: spekey <= 4'b0000;
	capsready: spekey <= 4'b0001;
	ctrlready: spekey <= 4'b0010;
	shiftready: spekey <= 4'b0100;
	shiftctrl: spekey <= 4'b0110;
	shiftcaps: spekey <= 4'b0101;
	ctrlcaps: spekey <= 4'b0011;
	allstates: spekey <= 4'b0111;
	default: spekey <= 0;
	endcase
end


//use shift/ctrl count to check whether shift/ctrl is released
//when caps is pressed down, state changes to the opposite direction
//shift: 0x12, ctrl: 0x14, caps: 0x58, up: 0xf0
//deal with states
always @ (posedge clk)//gaps?
begin
if(data == curdata)
begin
	state = state;
	curdata = data;
end
else if(data == 8'hf0)
begin
	up = 1;
	state = state;
	curdata = data;
	count = count - 1;
end
else begin
	
	if(data == 8'h12)
	begin
		if(up == 1)//取消shift
		begin
			case(state)
			shiftready: state = nostate;
			shiftctrl: state = ctrlready;
			shiftcaps: state = capsready;
			allstates: state = ctrlcaps;
			default: state = nostate;
			endcase
			curdata = 8'hf0;
			up = 0;
		end
		else begin
			case(state)
			nostate: state = shiftready;
			ctrlready: state = shiftctrl; 
			capsready: state = shiftcaps;
			ctrlcaps: state = allstates;
			default: state = shiftready;
			endcase
			curdata = data;
			times = times + 1;
			count = count + 1;
		end
	end
	else if(data == 8'h14)
		if(up == 1)
		begin
			case(state)
			ctrlready: state = nostate;
			shiftctrl: state = shiftready;
			ctrlcaps: state = capsready;
			allstates: state = shiftcaps;
			default: state = nostate;
			endcase
			curdata = 8'hf0;
			up = 0;
		end
		else begin
			case(state)
			nostate: state = ctrlready;
			shiftready: state = shiftctrl; 
			capsready: state = ctrlcaps;
			shiftcaps: state = allstates;
			default: state = ctrlready;
			endcase
			curdata = data;
			times = times + 1;
			count = count + 1;
		end
	else if(data == 8'h58)
	begin
		if(up == 0)
		begin
			case(state)
			nostate: state = capsready;
			shiftready: state = shiftcaps; 
			ctrlready: state = ctrlcaps;
			shiftctrl: state = allstates;
			
			capsready: state = nostate;
			shiftcaps: state = shiftready;
			ctrlcaps: state = ctrlready;
			allstates: state = shiftctrl;
			default: state = nostate;
			endcase
			curdata = data;
			times = times + 1;
			count = count + 1;
		end
		else begin
			curdata = 8'hf0;
			state = state;
			up = 0;
		end
	end
	else begin
		if(up == 0)
		begin
			curdata = data;
			times = times + 1;
			count = count + 1;
		end
		else begin
			curdata = 8'hf0;
			times = times;
			up = 0;
		end
	end
end
curdata = data;
if(state == shiftready 
		|| state == shiftcaps
		|| state == allstates
		|| state == shiftctrl)
	begin
		case(asdata)
		8'h30: myasdata = 8'h29;
		8'h31: myasdata = 8'h21;
		8'h32: myasdata = 8'h40;
		8'h33: myasdata = 8'h23;
		8'h34: myasdata = 8'h24;
		8'h35: myasdata = 8'h25;
		8'h36: myasdata = 8'h5e;
		8'h37: myasdata = 8'h26;
		8'h38: myasdata = 8'h2a;
		8'h39: myasdata = 8'h28;
		default: myasdata = asdata;
		endcase
	end
	else myasdata = asdata;
	
	if(state == capsready
		|| state == shiftcaps
		|| state == ctrlcaps
		|| state == allstates)
		offset = 2;
	else offset = 0;
end




//display
always @ (posedge clk)
begin
	if(count == 0)
	begin
		HEX0 <= 7'b1111111;
		HEX1 <= 7'b1111111;
		HEX2 <= 7'b1111111;
		HEX3 <= 7'b1111111;
	end
	else begin
		//scan code: no extra action
		case(data[3:0])
		0: HEX0 = 7'b1000000;
		1:	HEX0 = 7'b1111001;
		2: HEX0 <= 7'b0100100;
		3: HEX0 <= 7'b0110000;
		4: HEX0 <= 7'b0011001;
		5: HEX0 <= 7'b0010010;
		6: HEX0 <= 7'b0000010;
		7: HEX0 <= 7'b1111000;
		8: HEX0 <= 7'b0000000;
		9: HEX0 <= 7'b0010000;
		10: HEX0 <= 7'b0001000;
		11: HEX0 <= 7'b0000011;
		12: HEX0 <= 7'b1000110;
		13: HEX0 <= 7'b0100001;
		14: HEX0 <= 7'b0000110;
		15: HEX0 <= 7'b0001110;
		default: HEX0 <= 7'b1111111;
		endcase
		case(data[7:4])
		0: HEX1 <= 7'b1000000;
		1:	HEX1 <= 7'b1111001;
		2: HEX1 <= 7'b0100100;
		3: HEX1 <= 7'b0110000;
		4: HEX1 <= 7'b0011001;
		5: HEX1 <= 7'b0010010;
		6: HEX1 <= 7'b0000010;
		7: HEX1 <= 7'b1111000;
		8: HEX1 <= 7'b0000000;
		9: HEX1 <= 7'b0010000;
		10: HEX1 <= 7'b0001000;
		11: HEX1 <= 7'b0000011;
		12: HEX1 <= 7'b1000110;
		13: HEX1 <= 7'b0100001;
		14: HEX1 <= 7'b0000110;
		15: HEX1 <= 7'b0001110;
		default: HEX1 <= 7'b1111111;
		endcase
		
		case(myasdata[3:0])
		0: HEX2 <= 7'b1000000;
		1:	HEX2 <= 7'b1111001;
		2: HEX2 <= 7'b0100100;
		3: HEX2 <= 7'b0110000;
		4: HEX2 <= 7'b0011001;
		5: HEX2 <= 7'b0010010;
		6: HEX2 <= 7'b0000010;
		7: HEX2 <= 7'b1111000;
		8: HEX2 <= 7'b0000000;
		9: HEX2 <= 7'b0010000;
		10: HEX2 <= 7'b0001000;
		11: HEX2 <= 7'b0000011;
		12: HEX2 <= 7'b1000110;
		13: HEX2 <= 7'b0100001;
		14: HEX2 <= 7'b0000110;
		15: HEX2 <= 7'b0001110;
		default: HEX2 <= 7'b1111111;
		endcase
		case(myasdata[7:4] - offset)
		0: HEX3 <= 7'b1000000;
		1:	HEX3 <= 7'b1111001;
		2: HEX3 <= 7'b0100100;
		3: HEX3 <= 7'b0110000;
		4: HEX3 <= 7'b0011001;
		5: HEX3 <= 7'b0010010;
		6: HEX3 <= 7'b0000010;
		7: HEX3 <= 7'b1111000;
		8: HEX3 <= 7'b0000000;
		9: HEX3 <= 7'b0010000;
		10: HEX3 <= 7'b0001000;
		11: HEX3 <= 7'b0000011;
		12: HEX3 <= 7'b1000110;
		13: HEX3 <= 7'b0100001;
		14: HEX3 <= 7'b0000110;
		15: HEX3 <= 7'b0001110;
		default: HEX3 <= 7'b1111111;
		endcase
		
		//times
		case(times[3:0])
		0: HEX4 = 7'b1000000;
		1:	HEX4 = 7'b1111001;
		2: HEX4 = 7'b0100100;
		3: HEX4 = 7'b0110000;
		4: HEX4 = 7'b0011001;
		5: HEX4 = 7'b0010010;
		6: HEX4 = 7'b0000010;
		7: HEX4 = 7'b1111000;
		8: HEX4 = 7'b0000000;
		9: HEX4 = 7'b0010000;
		10: HEX4 = 7'b0001000;
		11: HEX4 = 7'b0000011;
		12: HEX4 = 7'b1000110;
		13: HEX4 = 7'b0100001;
		14: HEX4 = 7'b0000110;
		15: HEX4 = 7'b0001110;
		default: HEX4 = 7'b1111111;
		endcase
		case(times[7:4])
		0: HEX5 <= 7'b1000000;
		1:	HEX5 <= 7'b1111001;
		2: HEX5 <= 7'b0100100;
		3: HEX5 <= 7'b0110000;
		4: HEX5 <= 7'b0011001;
		5: HEX5 <= 7'b0010010;
		6: HEX5 <= 7'b0000010;
		7: HEX5 <= 7'b1111000;
		8: HEX5 <= 7'b0000000;
		9: HEX5 <= 7'b0010000;
		10: HEX5 <= 7'b0001000;
		11: HEX5 <= 7'b0000011;
		12: HEX5 <= 7'b1000110;
		13: HEX5 <= 7'b0100001;
		14: HEX5 <= 7'b0000110;
		15: HEX5 <= 7'b0001110;
		default: HEX5 <= 7'b1111111;
		endcase
	end
end


endmodule














/*
always @ (posedge clk)
begin
	if(data == 2'hF0)
	begin
		HEX0 <= 7'b1111111;
		HEX1 <= 7'b1111111;
		HEX2 <= 7'b1111111;
		HEX3 <= 7'b1111111;
		if(last == 0)
		begin
			times <= times + 1;
			last = 1;
		end
		else times <= times;
	end
	else begin
	last = 0;
	case(data[3:0])
	0: HEX0 = 7'b1000000;
	1:	HEX0 = 7'b1111001;
	2: HEX0 <= 7'b0100100;
	3: HEX0 <= 7'b0110000;
	4: HEX0 <= 7'b0011001;
	5: HEX0 <= 7'b0010010;
	6: HEX0 <= 7'b0000010;
	7: HEX0 <= 7'b1111000;
	8: HEX0 <= 7'b0000000;
	9: HEX0 <= 7'b0010000;
	10: HEX0 <= 7'b0001000;
	11: HEX0 <= 7'b0000011;
	12: HEX0 <= 7'b10000110;
	13: HEX0 <= 7'b0100001;
	14: HEX0 <= 7'b0000110;
	15: HEX0 <= 7'b0001110;
	default: HEX0 <= 7'b1111111;
	endcase
	case(data[7:4])
	0: HEX1 <= 7'b1000000;
	1:	HEX1 <= 7'b1111001;
	2: HEX1 <= 7'b0100100;
	3: HEX1 <= 7'b0110000;
	4: HEX1 <= 7'b0011001;
	5: HEX1 <= 7'b0010010;
	6: HEX1 <= 7'b0000010;
	7: HEX1 <= 7'b1111000;
	8: HEX1 <= 7'b0000000;
	9: HEX1 <= 7'b0010000;
	10: HEX1 <= 7'b0001000;
	11: HEX1 <= 7'b0000011;
	12: HEX1 <= 7'b10000110;
	13: HEX1 <= 7'b0100001;
	14: HEX1 <= 7'b0000110;
	15: HEX1 <= 7'b0001110;
	default: HEX1 <= 7'b1111111;
	endcase
	case(asdata[3:0])
	0: HEX2 <= 7'b1000000;
	1:	HEX2 <= 7'b1111001;
	2: HEX2 <= 7'b0100100;
	3: HEX2 <= 7'b0110000;
	4: HEX2 <= 7'b0011001;
	5: HEX2 <= 7'b0010010;
	6: HEX2 <= 7'b0000010;
	7: HEX2 <= 7'b1111000;
	8: HEX2 <= 7'b0000000;
	9: HEX2 <= 7'b0010000;
	10: HEX2 <= 7'b0001000;
	11: HEX2 <= 7'b0000011;
	12: HEX2 <= 7'b10000110;
	13: HEX2 <= 7'b0100001;
	14: HEX2 <= 7'b0000110;
	15: HEX2 <= 7'b0001110;
	default: HEX2 <= 7'b1111111;
	endcase
	case(asdata[7:4])
	0: HEX3 <= 7'b1000000;
	1:	HEX3 <= 7'b1111001;
	2: HEX3 <= 7'b0100100;
	3: HEX3 <= 7'b0110000;
	4: HEX3 <= 7'b0011001;
	5: HEX3 <= 7'b0010010;
	6: HEX3 <= 7'b0000010;
	7: HEX3 <= 7'b1111000;
	8: HEX3 <= 7'b0000000;
	9: HEX3 <= 7'b0010000;
	10: HEX3 <= 7'b0001000;
	11: HEX3 <= 7'b0000011;
	12: HEX3 <= 7'b10000110;
	13: HEX3 <= 7'b0100001;
	14: HEX3 <= 7'b0000110;
	15: HEX3 <= 7'b0001110;
	default: HEX3 <= 7'b1111111;
	endcase
	end

	case(times[3:0])
	0: HEX4 = 7'b1000000;
	1:	HEX4 = 7'b1111001;
	2: HEX4 = 7'b0100100;
	3: HEX4 = 7'b0110000;
	4: HEX4 = 7'b0011001;
	5: HEX4 = 7'b0010010;
	6: HEX4 = 7'b0000010;
	7: HEX4 = 7'b1111000;
	8: HEX4 = 7'b0000000;
	9: HEX4 = 7'b0010000;
	10: HEX4 = 7'b0001000;
	11: HEX4 = 7'b0000011;
	12: HEX4 = 7'b10000110;
	13: HEX4 = 7'b0100001;
	14: HEX4 = 7'b0000110;
	15: HEX4 = 7'b0001110;
	default: HEX4 = 7'b1111111;
	endcase
	case(times[7:4])
	0: HEX5 <= 7'b1000000;
	1:	HEX5 <= 7'b1111001;
	2: HEX5 <= 7'b0100100;
	3: HEX5 <= 7'b0110000;
	4: HEX5 <= 7'b0011001;
	5: HEX5 <= 7'b0010010;
	6: HEX5 <= 7'b0000010;
	7: HEX5 <= 7'b1111000;
	8: HEX5 <= 7'b0000000;
	9: HEX5 <= 7'b0010000;
	10: HEX5 <= 7'b0001000;
	11: HEX5 <= 7'b0000011;
	12: HEX5 <= 7'b10000110;
	13: HEX5 <= 7'b0100001;
	14: HEX5 <= 7'b0000110;
	15: HEX5 <= 7'b0001110;
	default: HEX5 <= 7'b1111111;
	endcase
end
*/

