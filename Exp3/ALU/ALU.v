module ALU(A,B,Op,Result,Carry,Overflow);
	input [3:0] A,B;
	input [2:0] Op;
	output reg [3:0] Result;
	output reg Carry,Overflow;
	reg [3:0] t_no_Cin;
	always @(*)
	begin
		case(Op)
			3'b111:begin
				{Carry,Result}=A+B;
				Overflow=(A[3]==B[3])&&(Result[3]!=A[3]);
				end
			3'b110:begin
				t_no_Cin={4{Op[1]}}^B;
				{Carry,Result}=A+t_no_Cin+Op[1];
				Overflow=(A[3]==t_no_Cin[3])&&(Result[3]!=A[3]);
				end
			3'b101:begin
				Result=~A;
				Carry=0;
				Overflow=0;
				end
			3'b100:begin
				Result=A&B;
				Carry=0;
				Overflow=0;
				end
			3'b011:begin
				Result=A|B;
				Carry=0;
				Overflow=0;
				end			
			3'b010:begin
				Result=A^B;
				Carry=0;
				Overflow=0;
				end
			3'b001:begin
				if(A[3]^B[3])
					Result=B[3];
				else if(A==B)
					Result=0;
				else
					begin
					t_no_Cin={4{Op[0]}}^B;
					{Carry,Result}=A+t_no_Cin+Op[0];
					Result=!Result[3];
					end
				Carry=0;
				Overflow=0;
				end
			3'b000:begin
				Result=(A==B);
				Carry=0;
				Overflow=0;			
				end
		endcase
	end
	
endmodule

//