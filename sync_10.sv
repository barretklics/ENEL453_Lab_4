module sync_10(input logic clk,
					input logic [9:0] d,
					output logic [9:0] q);
					
	logic [9:0] n1;
	  always_ff@(posedge clk)
		begin
			n1 <= d;
			q <= n1;
		end
endmodule
			