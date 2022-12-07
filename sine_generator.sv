module sine_generator 
#(parameter int
	amp_width = 10, //2**N data size. 
	table_size_n = 13
	)


(
  input  logic        clk, reset_n,
  input  logic [table_size_n-1:0] phase_in, //input phase
  
  output logic [amp_width:0] amp_out);

  
  
  logic [11:0] sin[2**13/4:0]; // i.e. [data_width-1:0] my_rom[2**addr_width-1:0];
  
  initial begin // normally we don't use initial in RTL code, this is an exception
    $readmemh("sine_rom.txt",sin); // reads hexadecimal data from v2d_rom and places into my_rom
  end

  
  
    always_ff @(posedge clk, negedge reset_n) begin
    if (!reset_n)
      amp_out <= 0;

		else	
		
			
			if ((0 <= phase_in) & (phase_in <= 2048)) amp_out <= 1022 + sin[phase_in];
			else if ((2048 <= phase_in) & (phase_in <= 4096)) amp_out <= 1022 + sin[4096 - phase_in];
			else if ((4096 <= phase_in) & (phase_in <= 6144)) amp_out <= 1022 - sin[phase_in-4096];
			else if ((6144 <= phase_in) & (phase_in <= 8192)) amp_out <= 1022 - sin[8192-phase_in];
			
			
		//	else if ((180 <= x) & (x <= 270)) q <= sin[270 - x];
		//	else if ((270 <= x) & (x <= 360)) q <= sin[x];
			end
			
  /*
	if ((0 <= x) & (x <= 90)) q = 50 + sin[x];
	else if ((90 <= x) & (x <= 180)) q = 50 + sin[180 - x];

	else if ((180 <= x) & (x <= 270)) q = sin[270 - x];
	else if ((270 <= x) & (x <= 360)) q = sin[x];
	
	//TOUPDATE these as params
	
	if ((0 <= phase_in) & (phase_in <= 2**(table_size_n-2))) amp_out <= ((2**(table_size_n-3))-2) + sin[phase_in];
			else if ((2**(table_size_n-2) <= phase_in) & (phase_in <= (2**(table_size_n-1)))) amp_out <= ((2**(table_size_n-3))-2) + sin[(2**(table_size_n-1)) - phase_in];
			else if ((2**(table_size_n-1) <= phase_in) & (phase_in <= ((2**(table_size_n-3))*6))) amp_out <= ((2**table_size_n-3)-2) - sin[phase_in-(2**(table_size_n-1))];
			else if ((((2**(table_size_n-3))*6) <= phase_in) & (phase_in <= 2**table_size_n)) amp_out <= ((2**(table_size_n-3))-2) - sin[(2**table_size_n)-phase_in];
			if ((0 <= phase_in) & (phase_in <= 2048)) amp_out <= 1022 + sin[phase_in];
			else if ((2048 <= phase_in) & (phase_in <= 4096)) amp_out <= 1022 + sin[4096 - phase_in];
			else if ((4096 <= phase_in) & (phase_in <= 6144)) amp_out <= 1022 - sin[phase_in-4096];
			else if ((6144 <= phase_in) & (phase_in <= 8192)) amp_out <= 1022 - sin[8192-phase_in];
	
*/

endmodule