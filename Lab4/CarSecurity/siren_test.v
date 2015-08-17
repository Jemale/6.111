`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:50:56 10/16/2013
// Design Name:   siren_generator
// Module Name:   C:/Users/Jemale/Documents/6.111/Test/siren_test.v
// Project Name:  Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: siren_generator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module siren_test;

	// Inputs
	reg siren_on;
	reg clock;
	reg reset;

	// Outputs
	wire siren_out;

	// Instantiate the Unit Under Test (UUT)
	siren_generator uut ( 
	   .reset(reset),
		.siren_on(siren_on), 
		.clock(clock), 
		.siren_out(siren_out)
	);
   
	always #5 clock = ~clock;
	initial begin
		// Initialize Inputs
		siren_on = 0;
		clock = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#5
      //reset = 1;
		
		#10
		
	//	reset = 0;
		
		#10
		//see if siren comes on
		siren_on = 1;
		
		//wait long time to see siren
		#54000000
		
		$stop();
	end
      
endmodule

