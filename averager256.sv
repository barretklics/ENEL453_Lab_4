module averager256
#(parameter int // Note, these are the generic default values. The actual values are in the instantiation.
     N    = 8,   // log2(number of samples to average over), e.g. N=8 is 2**8 = 256 samples
     bits = 11)  // number of bits in the input data to be averaged
  (input  logic          clk,
                         EN,      
                         reset_n,
   input  logic [bits:0] Din,     // input sample for moving average calculation
   output logic [bits:0] Q);      // 12-bit moving average of 256 samples
	
  logic [bits:0] REG_ARRAY [2**N:0];                                             
  logic [2*bits:0] sum = 0; //Gives Sum twice the amount of space of any given entry to account for adding these values up

  
  always_ff @(posedge clk, negedge reset_n) 
  begin
    if(!reset_n) begin
      for(int i = 0; i < 2**N+1; i++) //Sets all array values to 0
        REG_ARRAY[i] <= 0;
      Q <= 0;
		sum <= 0;
    end
    else if(EN) begin

	 
	 for(int i = 0; i < 2**N; i++) //Loops for every value in the array
		REG_ARRAY[i+1] <= REG_ARRAY[i]; //Shift all array entries down
	REG_ARRAY[0] <= Din; //Add input to array
	
	sum <= sum + REG_ARRAY[0] - REG_ARRAY[2**N]; //Add latest value to sum, subtract earliest

	Q <= sum/2**N; //Divide by amount of array slots
  end
 end
endmodule   
                                                         