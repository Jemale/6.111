`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:55 10/11/2013 
// Design Name: 
// Module Name:    timer 
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
module timer(
    input reset,
    input clock,
    input enable,
    input [3:0] value,
    input start,
    output  expired,
	 output [3:0] timer_count,
	 output [1:0] out_state
    );

   parameter IDLE          = 2'b00;
   parameter LOAD_VALUE    = 2'b01;
   parameter COUNTING      = 2'b10;
   parameter EXPIRED       = 2'b11;

   
   reg  [3:0] count, next_count;
   reg [1:0]  state, next_state;

   //fill in timer transition diagram
   always @ * begin 
      if (reset){next_state, next_count} = {IDLE, 4'b0};
		else case (state)
           IDLE:      
			     begin  
				    next_state =  start ? LOAD_VALUE : state;
					 next_count = 0;
               end

           LOAD_VALUE: 
                begin
     					 next_state  = COUNTING;
                   next_count  = value;    						 
                end
                 
           COUNTING:
                begin
    					 next_state =  expired ? EXPIRED : state;
						 next_count =  expired ? 4'b0 : enable ? count - 1 : count;
                end
  
           EXPIRED: 
                begin
 					     next_state = IDLE;
						  next_count = 4'b0;
                end
               
          // default: {next_state, next_count} = {state, count};
      endcase // case (state)
   end // always @ *
   
  

   always @ (posedge clock) begin  
		 count <=next_count;
		 state <= next_state;
   end
    
   assign expired = (state == COUNTING &&  count ==  0);
	assign timer_count = count;
	assign out_state = state;
endmodule
