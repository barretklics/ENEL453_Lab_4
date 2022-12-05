module point_selector
  (input  logic [1:0]            s,
   output logic [5:0] p);
  
  always_comb
	case(s)
		2'b00 : p = 6'b000000;
		2'b01 : p = 6'b000100; 
      2'b10 : p = 6'b001000;
		2'b11 : p = 6'b000000;
		
		default: p = 6'b000000;
	endcase
		
		
endmodule