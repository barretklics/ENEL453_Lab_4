// top level module
// Watch out for case sensitivity when translating from VHDL.
// Also note that the .QSF is case sensitive.

module top_level
 (input  logic       clk,
  input  logic       reset_n,
  input  logic       key_enable, //ADDED, assigned to key0, note is active low
  input  logic [9:0] SW,
  output logic [9:0] LEDR,
  output logic [7:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
  output logic D0,D1,D2,D3,D4,D5,D6,D7,D8,D9);
  
  logic [3:0]  Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5;   
  logic [5:0]  DP_in, Blank;


  
  //Switches

  logic [12:0] switch_inputs;
  
  assign LEDR[9:0]         = sync_SW[9:0]; // gives visual display of the switch inputs to the LEDs on board
  assign switch_inputs     = {5'b00000,sync_SW[7:0]};
    
  
  //-------------------Storage out
  logic [15:0] storage_out;
  logic [9:0] sync_SW;
  logic en; //enable
  
  
	//ADC and Related
  	logic [11:0] voltage_bus;
	logic [11:0] distance_bus;
	logic [11:0] ADC_out;									
	logic [15:0] distance_decimal;
	logic [15:0] voltage_decimal;  	

  
 
  //Mux out code
  logic [15:0] mux_out;
  assign Num_Hex0 = storage_out[3:0]; 
  assign Num_Hex1 = storage_out[7:4];
  assign Num_Hex2 = storage_out[11:8];
  assign Num_Hex3 = storage_out[15:12];
  assign Num_Hex4 = 4'b0000;
  assign Num_Hex5 = 4'b0000;   
  
	//Mux modulation
	logic [9:0] carry_sig;
	logic [9:0] AM_sig;
	logic [9:0] AM_damp_sig;
	logic [9:0] FM_sig;
	//logic [9:0] output_sig;
  
  
  
  //Instantiate lower level modules

  
  
  //Synchronizer/Debouncer/Value Saver
  	sync_10 sync_10_ins(.clk(clk),
								.d(SW), //unsynced input
								.q(sync_SW) //synced output
								);
	
	debounce debounce_ins(.clk(clk),
									.reset_n(reset_n),
									.button(key_enable),
									.result(en)
									);
  
  	storage storage_ins(.clk(clk),
							  .reset_n(reset_n),
	
							  .d(mux_out),

							  .enable(en),
							  //.enable(key_enable),
							  .q(storage_out)
							  );
  
  
  //Formatting
  //point_selector
  point_selector point_selc_ins(.s(sync_SW[9:8]),
										.p(DP_in)
										);

//Blank = 
 blanking blanking_ins(    .Num_Hex0(Num_Hex0),
                            .Num_Hex1(Num_Hex1),
                            .Num_Hex2(Num_Hex2),
                            .Num_Hex3(Num_Hex3),
                            .Num_Hex4(Num_Hex4),
                            .Num_Hex5(Num_Hex5),
									 .DP_in(DP_in),
									 .q(Blank)
									 );									
									
										
//SevenSegment and tools
  //ADC

	
//MUX4TO1
MUX4TO1 Mux_ins(.in1(switch_inputs),
					.in2(distance_decimal),
					.in3(voltage_decimal),
					.in4(ADC_out),					
					.s(sync_SW[9:8]),
					.mux_out(mux_out)
);
	
MUX4TO1 #(.width(10)) 

Mod_Mux_ins(.in1(carry_sig),
					.in2(AM_sig),
					.in3(FM_sig),
					.in4(AM_damp_sig),					
					.s(sync_SW[9:8]),
					.mux_out(DAC_bus)
					);
	
	
 //SevenSegment SevenSegment_ins(.*); // (.*) doesn't work for VHDL files, and instance name was too long
 SevenSegment SevenSeg_ins(.Num_Hex0(Num_Hex0),
                            .Num_Hex1(Num_Hex1),
                            .Num_Hex2(Num_Hex2),
                            .Num_Hex3(Num_Hex3),
                            .Num_Hex4(Num_Hex4),
                            .Num_Hex5(Num_Hex5),
                            .Hex0(HEX0),
                            .Hex1(HEX1),
                            .Hex2(HEX2),
                            .Hex3(HEX3),
                            .Hex4(HEX4),
                            .Hex5(HEX5),
                            .DP_in(DP_in),
									 .Blank(Blank));
 
binary_bcd binary_bcd_ins_voltage(.clk(clk),                          
                            .reset_n(reset_n),                                 
                            .binary(voltage_bus),    
                            .bcd(voltage_decimal));
									 
binary_bcd binary_bcd_ins_distance(.clk(clk),                          
                        .reset_n(reset_n),                                 
                        .binary(distance_bus),    
                        .bcd(distance_decimal));									 
									 							 
ADC_Data ADC_Data_ins(.clk(clk),
									.reset_n(reset_n),
									.voltage(voltage_bus),
									.distance(distance_bus),
									.ADC_raw(),
									.ADC_out(ADC_out));
									
	
	
	
	
	
//DDS	
	
	
	
	logic[9:0] DAC_bus;
	logic dds_en;
	
	/*
	FM_Modulator #(.min_dist(400),
							.max_dist(2000),
							)
	FM_Modulator_ins(.distance(distance_bus)
	*/
	
	
	downcounter #(.period(1))
	
	downcounter_dds_clock(.clk(clk),
									.reset_n(reset_n),
									.enable(1),
									.zero(dds_en)
									);
	
	
	
	
	
	DDS #(.amp_width(10),
			.table_size_n(13)
		)

	DDS_ins(.clk(clk), //system clock. Tuned to accept 500KHz
				.reset_n(reset_n),
				.en(1),
				.tuning_word(49), //Tuning word (how much to increment phase by. Max = LUT value. Space required 49
				.amplitude(carry_sig)
		
	);
	
	
	assign D0 = DAC_bus[0];
	assign D1 = DAC_bus[1];
	assign D2 = DAC_bus[2];
	assign D3 = DAC_bus[3];
	assign D4 = DAC_bus[4];
	assign D5 = DAC_bus[5];
	assign D6 = DAC_bus[6];
	assign D7 = DAC_bus[7];
	assign D8 = DAC_bus[8];
	assign D9 = DAC_bus[9];

	
	AM_mod AM_mod_ins(.clk(clk), .reset_n(reset_n), .en(en), .carry_sig(carry_sig), .distance(distance_bus), .AM_sig(AM_sig));
	
	AM_mod_damp AM_mod_damp_ins(.clk(clk), .reset_n(reset_n), .en(en), .carry_sig(carry_sig), .distance(distance_bus), .AM_damp_sig(AM_damp_sig));
	
	FM_mod FM_mod_ins(.clk(clk), .reset_n(reset_n), .en(en), .carry_sig(carry_sig), .distance(distance_bus), .FM_sig(FM_sig));
		

endmodule
