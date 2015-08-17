`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:49:33 10/10/2013 
// Design Name: 
// Module Name:    siren_generator 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module siren_generator(
    input reset,
    input clock,
    output siren_out
    );

   parameter S_LOW_FREQ  = 1'b0; //400hz- 67500 counts
   parameter S_HIGH_FREQ = 1'b1; //700hz~ 38571 counts
	
	parameter TWO_SECONDS = 25'd54000000;
  

   parameter LOW_COUNT   = 25'd67500;
   parameter HIGH_COUNT  = 25'd38572;

    
   reg siren_output = 0;
   reg [25:0] count, next_count = 25'd0;
	reg [25:0] count_siren, next_count_siren = 25'd0;
	reg state, next_state = 0;
	
	reg flag = 0;
	
	always @ *  begin
	   //need to create alternating pattern of 1s and 0s
		if (reset && !flag) begin 
				next_count_siren = 25'd0;
				next_state = S_LOW_FREQ;
				next_count = 25'd0;
				flag = 1;
				end
      else /*if (siren_on)*/ begin  //rid siren-on ==> siren but no blinking
		      if (!reset) flag = 0;
			   //case(state)
                 //S_LOW_FREQ: 
					     //begin
     					     //next_state = (count == TWO_SECONDS) ? S_HIGH_FREQ : state;
							  if (count_siren > LOW_COUNT) 
							    begin
                           siren_output = !siren_output;
									next_count_siren = 25'd0;
                         end	
                       else
                         next_count_siren = count_siren + 1;							  
						  //end
						  
//					  S_HIGH_FREQ:
//                     begin
//    							next_state = (count == TWO_SECONDS) ? S_LOW_FREQ  : state;
//                        
//								if (count_siren > HIGH_COUNT) 
//							    begin
//                           siren_output = !siren_output;
//									next_count_siren = 25'd0;
//                         end
//								else
//								   next_count_siren = count_siren + 1;	 
//                        
//   						end	
							
//	              default begin 
//           					  next_state = S_LOW_FREQ;
//								  next_count = 25'd0;
//								  next_count_siren = 25'd0;
//								  end
//				 endcase
				  
				 next_count = (count == TWO_SECONDS) ? 25'd0 : count + 1;
	      end
		end
    
	 
	 reg rsiren_output = 0;
	 
	 always @ (posedge clock) begin    
	     state <= next_state;
		  count <= next_count;
		  count_siren <= next_count_siren;
		  rsiren_output <= siren_output;
	 end
	 
 assign siren_out = rsiren_output;
endmodule
