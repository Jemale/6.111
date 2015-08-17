`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:33:39 10/11/2013
// Design Name:   fuel_pump_control
// Module Name:   /afs/athena.mit.edu/user/j/l/jlockett/6.111/Lab4/CarAlarmFSM/fuel_pump_test.v
// Project Name:  CarAlarmFSM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: fuel_pump_control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fuel_pump_test;

	// Inputs
	reg brake_depressed;
	reg hidden;
	reg ignition;

	// Outputs
	wire fuel_pump_power;

	// Instantiate the Unit Under Test (UUT)
	fuel_pump_control uut (
		.brake_depressed(brake_depressed), 
		.hidden(hidden), 
		.ignition(ignition), 
		.fuel_pump_power(fuel_pump_power)
	);

   
	initial begin
		// Initialize Inputs
		brake_depressed = 0;
		hidden = 0;
		ignition = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here


	   brake_depressed = 1;
	   hidden = 1;
      ignition = 1;

	   #5


	   hidden = 0;
	   
       #5
      brake_depressed = 0;
		
		#5
		
		ignition = 0;
		
		#5
		
		ignition = 1;
		  
		#5
		  $stop();
	   
	   
		    
	end
      
endmodule

