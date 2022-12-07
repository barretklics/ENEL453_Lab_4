module AM_mod_damp
	(input logic [9:0] carry_sig,
	input logic clk,
	input logic reset_n,
	//input logic en,
	
	input logic [11:0] distance,
	
	

	output logic [9:0] AM_damp_sig);

	logic [9:0] message_sig;
	logic [19:0] inter;
	
	
	logic [13-1:0] tuning_word;


	
	
	always_ff @(posedge clk, negedge reset_n) begin
	
		inter <= carry_sig*distance/3300;
		//inter <= 1024*distance/2900 - 141;
		end
		
		
	always_comb
		begin
			if (distance > 3300)
				AM_damp_sig = carry_sig;
			else if (distance < 400)
				AM_damp_sig = 0;
			else
				//tuning_word = 20/2000;
				AM_damp_sig = inter;
			
			end
			
			
			
endmodule