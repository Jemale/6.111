`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:54:38 10/10/2013 
// Design Name: 
// Module Name:    divider 
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
module divider(
    input reset,
    input clock,
    output enable
    );


    parameter ticks  = 27000000;
    reg [24:0] count = 0; 
	 reg [24:0] next_count = 0;
	 
	 reg flag = 0;
	 
	 always @ * 
	 next_count = (count == ticks) ? 0 : count + 1;
	 
	 always @(posedge clock) begin
	    if (reset && !flag) begin 
		     count <= 0;
			  flag = 1;
		 end
		 else begin 
		    if (!reset) flag = 0;
		    count <= next_count;
		 end
	 end
	 
	 
	 assign enable = (count == ticks);
endmodule
