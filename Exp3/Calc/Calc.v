module Calc(A,B,Cin,Result,Carry,Overflow,Zero);
	input [3:0] A,B;
	input Cin;
	output reg [3:0] Result;
	output reg Carry,Overflow,Zero;
	reg [3:0] t_no_Cin;
	
	always @(*)
	begin
		case(Cin)
		1:begin
			{Carry,Result}=A+B;
			Overflow=(A[3]==B[3])&&(Result[3]!=A[3]);
			Zero=(Result==0);
		end
		0:begin
			t_no_Cin={4{Cin}}^B;
			{Carry,Result}=A+t_no_Cin+Cin;
			Overflow=(A[3]==t_no_Cin[3])&&(Result[3]!=A[3]);
			Zero=(Result==0);
		end
		endcase
		
	end
		
endmodule		
