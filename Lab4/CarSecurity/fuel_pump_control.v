`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:47:23 10/10/2013 
// Design Name: 
// Module Name:    fuel_pump_control 
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
module fuel_pump_control(
    input clock,
	 input reset,
    input brake_depressed,
    input hidden,
    input ignition,
    output fuel_pump_power
    );
    
	 reg started = 0;
	 reg fpp = 0;
	 
	 
	 always @(*) begin
	    if (!fpp) begin
	     fpp = brake_depressed && hidden && ignition;
		 end
		 else
		   fpp = ignition;
	 end
    
	 
	 assign fuel_pump_power = fpp;
	 
endmodule
