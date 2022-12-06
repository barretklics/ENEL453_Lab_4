module phase_accumulator
#(parameter int
     N    = 13  //PHASE ACCUMULATOR LENGTH 2^N = 2^13 = 8192
    )
  (input  logic          clk,
                         EN,      
                         reset_n,
	input logic [N-1:0] phase_accum_len, //can store values from 8191 to 0
	
	input logic [N-1:0] tuning_word,
	
   output logic [N-1:0] phase);    
	

  always_ff @(posedge clk, negedge reset_n) 
  begin
    if(!reset_n) begin
      phase <= 0;
    end
	 
	 
    else if(EN) begin
		if (phase >= phase_accum_len) //phase word
		//	phase <= phase_accum_len - phase;
			phase <= 0;
		else 
			phase <= phase + tuning_word;//1
  end
 end
endmodule   
                                                         