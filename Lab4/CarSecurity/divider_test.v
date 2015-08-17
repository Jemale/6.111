`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:34:40 10/11/2013
// Design Name:   divider
// Module Name:   /afs/athena.mit.edu/user/j/l/jlockett/6.111/Lab4/CarAlarmFSM/divider_test.v
// Project Name:  CarAlarmFSM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module divider_test;

	// Inputs
	reg clock;
	reg reset;
	
	//output
	wire enable;

	// Instantiate the Unit Under Test (UUT)
	divider uut (
		.clock(clock),
		.reset(reset),
		.enable(enable)
	);
   
	always #5 clock = !clock; //set clock period
	initial begin
		// Initialize Inputs
		clock = 0;
      reset = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		#3000000000;
      
		$stop();
	end
      
endmodule

