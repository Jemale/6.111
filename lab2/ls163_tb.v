`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:59:25 09/18/2013
// Design Name:   ls163_lab2
// Module Name:   /afs/athena.mit.edu/user/j/l/jlockett/6.111/lab2/ls163_tb.v
// Project Name:  lab2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ls163_lab2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ls163_tb;

	// Inputs
	reg clk;
	reg ent;
	reg enp;
	reg load;
	reg clear;
	reg a;
	reg b;
	reg c;
	reg d;

	// Outputs
	wire qa;
	wire qb;
	wire qc;
	wire qd;
	wire rco;

	// Instantiate the Unit Under Test (UUT)
	ls163_lab2 uut (
		.clk(clk), 
		.ent(ent), 
		.enp(enp), 
		.load(load), 
		.clear(clear), 
		.a(a), 
		.b(b), 
		.c(c), 
		.d(d), 
		.qa(qa), 
		.qb(qb), 
		.qc(qc), 
		.qd(qd), 
		.rco(rco)
	);
   
	always #5 clk = !clk; //change state every 5ns
	initial begin
		// Initialize Inputs
		clk = 0;
		ent = 0;
		enp = 0;
		load = 0;
		clear = 0;
		a = 0;
		b = 0;
		c = 0;
		d = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	//////////////////////////////////////////////
	//
	clear = 1; 
	load = 0;     // note load is active low 
	a = 1;        // now load 8'b1001 to counter
	b = 0;       
	c = 0; 
	d = 1; 
	ent = 1;      // enp = ent = 1 to count
	enp = 1; 
	#20;          // wait for 20ns
	load = 1;
	//
	/////////////////////////////////////////////
	end
      
endmodule

