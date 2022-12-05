module blanking
	(input  logic [7:0] Num_Hex5, Num_Hex4, Num_Hex3, Num_Hex2, Num_Hex1, Num_Hex0,
	 input logic [5:0] DP_in,
	 output logic [5:0] q); //output
	 
	//inputs are, displays, button
	//output to mux//
	
	

	always_comb
	begin

	//      Blank 5 if zero      and not decimal point   & leftmost has not been blank
		q[5] = (Num_Hex5 == 6'b000000) & !(DP_in[5]);
		q[4] = (Num_Hex4 == 6'b000000) & !(DP_in[4]) & (q[4 + 1]);
		q[3] = (Num_Hex3 == 6'b000000) & !(DP_in[3]) & (q[3 + 1]);
		q[2] = (Num_Hex2 == 6'b000000) & !(DP_in[2]) & (q[2 + 1]);
		q[1] = (Num_Hex1 == 6'b000000) & !(DP_in[1]) & (q[1 + 1]);
		q[0] = (Num_Hex0 == 6'b000000) & !(DP_in[0]) & (q[0 + 1]);
		
		//Need to not blank a zero if the number to the left is set
		
	end
	
endmodule			