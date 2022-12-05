module storage
#(int                      width = 16)
	(input  logic        clk,
								reset_n,
    input logic [width-1:0] d, //values from mux out
	 input logic enable, //button to save value to register FUNCTIONS as an enable
	 output logic [width-1:0] q); //output
	 
	//inputs are, displays, button
	//output to mux//
	
	
  always_ff@(posedge clk, negedge reset_n) begin
    if (!reset_n) 		 // reset it active low
      q <= '0; // Storage out gets 0 (resets stored value)
		
    //else if (!enable)//if enable is on, dont change
	 else if (!enable)//if enable is on, dont change
			q <= q;
	 else //not resetting or enabled, do nothing
		q <= d;
	 
	 end
	 
endmodule