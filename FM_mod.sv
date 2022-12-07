module FM_mod
	(//input logic [13-1:0] tuning_word,
	input logic clk,
	input logic reset_n,
	input logic en,
	
	input logic [11:0] distance,
	
	

	output logic [9:0] FM_sig);

	logic [9:0] message_sig;
	logic [19:0] inter;
	
	
	logic [13-1:0] tuning_word;
	

	DDS #(.amp_width(10),
			.table_size_n(13)
		)

	DDS_ins(.clk(clk), //system clock. Tuned to accept 500KHz
				.reset_n(reset_n),
				.en(en),
				.tuning_word(tuning_word), //Tuning word (how much to increment phase by. Max = LUT value. Space required 49
				.amplitude(message_sig)
		
	);


	always_ff @(posedge clk, negedge reset_n) begin
		//inter <= carry_sig*message_sig;
		//FM_sig <= inter/1024;
		end
		
	always_comb
		begin
			if (distance > 3300) begin
				tuning_word = 508;
				FM_sig = message_sig;
				end
			else if (distance < 400) begin
				tuning_word = 475;
				FM_sig = message_sig;
				end
			else begin
				//tuning_word = 33/3300;
				tuning_word = (33*distance)/2900 + 470;
				FM_sig = message_sig;
				end
			
			end
			
			
			
endmodule