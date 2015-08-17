`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:51 10/10/2013 
// Design Name: 
// Module Name:    time_parameters 
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
module time_parameters(
    input reset,
	 input clock,
    input [1:0] parameter_selector, //from switch
    input [3:0] time_value,     //from switch
    input reprogram,
    input [1:0] interval,
    output [3:0] value
    );
    
	 parameter T_ARM_DELAY       = 2'b00;
	 parameter T_DRIVER_DELAY    = 2'b01;
	 parameter T_PASSENGER_DELAY = 2'b10;
	 parameter T_ALARM_ON        = 2'b11;
	 
	 reg [3:0] next_arm_delay, next_driver_delay, next_passenger_delay, next_alarm_on;
	 reg [3:0] arm_delay, driver_delay, passenger_delay, alarm_on;
	 
	 reg [3:0] next_value;
	 always @ * begin
	    if (reset)   begin 
		         next_arm_delay      = 4'b0110; //6
               next_driver_delay   = 4'b1000; //8
               next_passenger_delay=	4'b1111;//15
               next_alarm_on       = 4'b1010; //10

               next_value =  arm_delay;					
	    end
	    else if (reprogram) begin
		     case (parameter_selector)
			      T_ARM_DELAY:        next_arm_delay = time_value;
					
					T_DRIVER_DELAY:     next_driver_delay = time_value;
					
					T_PASSENGER_DELAY:  next_passenger_delay = time_value;
					 
					T_ALARM_ON:         next_alarm_on = time_value;
					
			      //default:  next_arm_delay = arm_delay;//improper parameter selected, do nothing
				endcase
		 end
		 else begin
		     case (interval)
			      T_ARM_DELAY:       next_value = arm_delay;  
					
					T_DRIVER_DELAY:    next_value = driver_delay;
					
					T_PASSENGER_DELAY: next_value = passenger_delay;
					
					T_ALARM_ON:        next_value = alarm_on;
					
			      default: next_value = arm_delay;
			  endcase
       end
       end
		 
		 
		 always @(posedge clock) begin
		   arm_delay <= next_arm_delay;
			driver_delay <= next_driver_delay;
			passenger_delay <= next_passenger_delay;
			alarm_on <= next_alarm_on;
			
		end
		 assign value = next_value;
endmodule
