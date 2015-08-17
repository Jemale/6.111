`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:40:06 10/15/2013
// Design Name:   AntiTheftModule
// Module Name:   C:/Users/Jemale/Documents/6.111/Test/AntiTheftTest.v
// Project Name:  Test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: AntiTheftModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module AntiTheftTest;

	// Inputs
	reg clock;
	reg reset;
	reg ignition;
	reg driver_door;
	reg passenger_door;
	reg reprogram;
	reg timer_expired;

	// Outputs
	wire [1:0] timer_interval;
	wire siren_on;
	wire status_indicator;
	wire start_timer;

	// Instantiate the Unit Under Test (UUT)
	AntiTheftModule uut (
		.clock(clock), 
		.reset(reset), 
		.ignition(ignition), 
		.driver_door(driver_door), 
		.passenger_door(passenger_door), 
		.reprogram(reprogram), 
		.timer_expired(timer_expired), 
		.timer_interval(timer_interval), 
		.siren_on(siren_on), 
		.status_indicator(status_indicator), 
		.start_timer(start_timer)
	);
   always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		ignition = 0;
		driver_door = 0;
		passenger_door = 0;
		reprogram = 0;
		timer_expired = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		
		#10
		
		reset = 0;
		
		#10
		
		//test that state machine goes into armed state
		ignition = 0;
		driver_door = 0;
		passenger_door = 0;
		
		#30
		
		
		//test that state machine goes into disarmed state
		ignition = 1;
		
		#30
		
		//turn off car
		ignition = 0;
		
		#20
		///should go to second disarmed state, wait for door to open
		driver_door = 1;
		
		#20
		//should go to third disarmed state, wait T_ARM_DELAY
		driver_door = 0;
		
		#50
      //goes back to armed state
      timer_expired = 1;

      #30

       //go to triggered state
       timer_expired = 0;
       driver_door = 1;		 
		 
		 #30
		 
		 //timer expires ---> go to sounding state
		 timer_expired = 1;
		 
		 #30
		 timer_expired = 0;
		 driver_door = 0;
		 passenger_door = 0;
		 
		 #30
		 
		 timer_expired = 1;
		 
		 #30
		 
		 timer_expired = 0;
		 passenger_door =1;
		 
		 #30
		 timer_expired  = 1;
		 
		 #30
		 timer_expired = 0;
		 driver_door = 0;
		 passenger_door = 0;
		
		 #30
		
		$stop();

	end
      
endmodule

