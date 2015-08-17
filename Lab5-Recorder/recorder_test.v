`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:56:52 10/24/2013
// Design Name:   recorder
// Module Name:   /afs/athena.mit.edu/user/j/l/jlockett/6.111/Lab5-Recorder/recorder_test.v
// Project Name:  Lab5-Recorder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: recorder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module recorder_test;

	// Inputs
	reg clock;
	reg reset;
	reg playback;
	reg ready;
	reg filter;
	reg [7:0] from_ac97_data;

	// Outputs
	wire [7:0] to_ac97_data;

	// Instantiate the Unit Under Test (UUT)
	recorder uut (
		.clock(clock), 
		.reset(reset), 
		.playback(playback), 
		.ready(ready), 
		.filter(filter), 
		.from_ac97_data(from_ac97_data), 
		.to_ac97_data(to_ac97_data)
	);
always #5 clock = !clock;
	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		playback = 0;
		ready = 0;
		filter = 0;
		from_ac97_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		
		#10
		
		reset = 0;
		
		#10
		
		
		//set up data in 
		playback = 0; 
		from_ac97_data = 8'd5;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd17;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd9;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		
      from_ac97_data = 8'd21;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd66;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd75;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd43;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		from_ac97_data = 8'd12;
		
		#10
		
		ready = 1;
		
		#10
		ready = 0;
		
		#10
		
		//change the data
		
		#50
		
		//now playback
		playback = 1;
		
		#10
		
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		ready = 1;
		
		#20
		
		ready = 0;
		
		#20
		
		
		#100

		
	end
      
endmodule

