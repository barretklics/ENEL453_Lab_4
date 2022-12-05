module DDS 

#(parameter int
	amp_width = 10, //2**N data width. 2**10 = 1024
	table_size_n = 13			  //2**N table index size. 2**13 = 8192. this will also be 
	)


	(
		input logic clk, //system clock. Tuned to accept 50MHz
						reset_n,
						en,
					

	input logic[table_size_n-1:0] tuning_word, //Tuning word (how much to increment phase by. Max = LUT value. Space required
	
	output logic [amp_width-1:0] amplitude
	
	);
	
	
	
//Max phase is dec 2**13 = 8192
	logic [amp_width-1:0] amplitude_bus;
	
	logic [table_size_n-1:0] phase_bus;
	
	
	assign amplitude = amplitude_bus; // 
	
	
	
//Instantiate accumulator
phase_accumulator #(.N(table_size_n))

			phase_accumulator_ins(.clk(clk), //runs on system clock
														.EN(en),  //elaways enabled
														.reset_n(reset_n),
														.phase_accum_len(N-1),
														.tuning_word(tuning_word),
														.phase(phase_bus)
														);
														
														
														
														
sine_generator #(.amp_width(amp_width),
						.table_size_n(table_size_n))

						
						
 singen_ins(.clk(clk), //takes phase, gives angle
									.reset_n(reset_n),
									.phase_in(phase_bus),
									.amp_out(amplitude_bus) //sin(x) in hex
									);		
endmodule	