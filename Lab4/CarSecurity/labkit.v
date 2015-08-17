
///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
// For Labkit Revision 004
//
//
// Created: October 31, 2004, from revision 003 file
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// CHANGES FOR BOARD REVISION 004
//
// 1) Added signals for logic analyzer pods 2-4.
// 2) Expanded "tv_in_ycrcb" to 20 bits.
// 3) Renamed "tv_out_data" to "tv_out_i2c_data" and "tv_out_sclk" to
//    "tv_out_i2c_clock".
// 4) Reversed disp_data_in and disp_data_out signals, so that "out" is an
//    output of the FPGA, and "in" is an input.
//
// CHANGES FOR BOARD REVISION 003
//
// 1) Combined flash chip enables into a single signal, flash_ce_b.
//
// CHANGES FOR BOARD REVISION 002
//
// 1) Added SRAM clock feedback path input and output
// 2) Renamed "mousedata" to "mouse_data"
// 3) Renamed some ZBT memory signals. Parity bits are now incorporated into 
//    the data bus, and the byte write enables have been combined into the
//    4-bit ram#_bwe_b bus.
// 4) Removed the "systemace_clock" net, since the SystemACE clock is now
//    hardwired on the PCB to the oscillator.
//
///////////////////////////////////////////////////////////////////////////////
//
// Complete change history (including bug fixes)
//
// 2006-Mar-08: Corrected default assignments to "vga_out_red", "vga_out_green"
//              and "vga_out_blue". (Was 10'h0, now 8'h0.)
//
// 2005-Sep-09: Added missing default assignments to "ac97_sdata_out",
//              "disp_data_out", "analyzer[2-3]_clock" and
//              "analyzer[2-3]_data".
//
// 2005-Jan-23: Reduced flash address bus to 24 bits, to match 128Mb devices
//              actually populated on the boards. (The boards support up to
//              256Mb devices, with 25 address lines.)
//
// 2004-Oct-31: Adapted to new revision 004 board.
//
// 2004-May-01: Changed "disp_data_in" to be an output, and gave it a default
//              value. (Previous versions of this file declared this port to
//              be an input.)
//
// 2004-Apr-29: Reduced SRAM address busses to 19 bits, to match 18Mb devices
//              actually populated on the boards. (The boards support up to
//              72Mb devices, with 21 address lines.)
//
// 2004-Apr-29: Change history started
//
///////////////////////////////////////////////////////////////////////////////

module labkit (beep, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
   assign audio_reset_b = 1'b0;
   assign ac97_synch = 1'b0;
   assign ac97_sdata_out = 1'b0;
   // ac97_sdata_in is an input

   // VGA Output
   assign vga_out_red = 8'h0;
   assign vga_out_green = 8'h0;
   assign vga_out_blue = 8'h0;
   assign vga_out_sync_b = 1'b1;
   assign vga_out_blank_b = 1'b1;
   assign vga_out_pixel_clock = 1'b0;
   assign vga_out_hsync = 1'b0;
   assign vga_out_vsync = 1'b0;

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b0;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b0;
   assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = 1'b0;
   assign tv_in_i2c_data = 1'bZ;
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_clk = 1'b0;
   assign ram0_cen_b = 1'b1;
   assign ram0_ce_b = 1'b1;
   assign ram0_oe_b = 1'b1;
   assign ram0_we_b = 1'b1;
   assign ram0_bwe_b = 4'hF;
   assign ram1_data = 36'hZ; 
   assign ram1_address = 19'h0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_clk = 1'b0;
   assign ram1_cen_b = 1'b1;
   assign ram1_ce_b = 1'b1;
   assign ram1_oe_b = 1'b1;
   assign ram1_we_b = 1'b1;
   assign ram1_bwe_b = 4'hF;
   assign clock_feedback_out = 1'b0;
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

   // LED Displays
/*   assign disp_blank = 1'b1;
   assign disp_clock = 1'b0;
   assign disp_rs = 1'b0;
   assign disp_ce_b = 1'b1;
   assign disp_reset_b = 1'b0;
   assign disp_data_out = 1'b0;*/
   // disp_data_in is an input


   // Buttons, Switches, and Individual LEDs
   //assign led = 8'h00;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
  // assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3 = 32'hZ;
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;
			    
////////////////////////////////////////////////////////////////////////////
  //
  // Reset Generation
  //
  // A shift register primitive is used to generate an active-high reset
  // signal that remains high for 16 clock cycles after configuration finishes
  // and the FPGA's internal clocks begin toggling.
  //
  ////////////////////////////////////////////////////////////////////////////
  wire reset;
  SRL16 reset_sr(.D(1'b0), .CLK(clock_27mhz), .Q(reset),
	         .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
  defparam reset_sr.INIT = 16'hFFFF;

/////////////////////////////////////////////////////////////////
     //List/Syncronize Sensors/Actuators
     //
     //
     //
     ///////////////////////////////////////////////////////////
wire alarm_system_reset;
wire hidden_switch, brake_switch, ignition_switch;
   
//syncronize them
synchronize hidden_switch_sync( .clk(clock_27mhz), .in(~button0), .out(hidden_switch));
synchronize brake_switch_sync ( .clk(clock_27mhz), .in(~button1), .out(brake_switch));
debounce    ignition_switch_db(.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[7]), .clean(ignition_switch));

   
   
   
   
wire driver_door, passenger_door;
synchronize driver_door_sync (.clk(clock_27mhz), .in(~button2), .out(driver_door));
synchronize passenger_door_sync (.clk(clock_27mhz), .in(~button3), .out(passenger_door));

  
wire reprogram;
synchronize reset_sync (.clk(clock_27mhz), .in(~button_down), .out(alarm_system_reset));
synchronize reprogram_sync(.clk(clock_27mhz), .in(~button_enter), .out(reprogram));



wire [1:0] timer_parameter_selector;
debounce   timer_param_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[5]), .clean(timer_parameter_selector[1]));
debounce   timer_param2_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[4]), .clean(timer_parameter_selector[0]));


wire [3:0] timer_value;
debounce   timer_value_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[3]), .clean(timer_value[3])); 
debounce   timer_value2_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[2]), .clean(timer_value[2]));   
debounce   timer_value3_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[1]), .clean(timer_value[1]));   
debounce   timer_value4_db (.reset(alarm_system_reset), .clock(clock_27mhz), .noisy(switch[0]), .clean(timer_value[0]));   
  

wire status_light, fuel_pump_power, siren_enable, siren_output;

   
           
  
/////////////////////////////////////////////////////////////////
  //
  //Instantiate Modules
  //
  //
  //
  //
  //
  ///////////////////////////////////////////////////////////////  


fuel_pump_control fuel_power(.clock(clock_27mhz), .reset(alarm_system_reset), .brake_depressed(brake_switch), .hidden(hidden_switch), .ignition(ignition_switch), .fuel_pump_power(fuel_pump_power));

wire hz_enable, start_timer, expired;



wire [1:0] interval;
wire [3:0] value;
divider _divider(.reset(start_timer), 
.clock(clock_27mhz), 
.enable(hz_enable)); 

wire [3:0] timer_count;
wire [1:0] timer_state;
time_parameters timer_params(.reset(alarm_system_reset), 
.clock(clock_27mhz), 
.parameter_selector(timer_parameter_selector), 
.time_value(timer_value), //the input timer value
.reprogram(reprogram),
.interval(interval),  
.value(value) //the output timer value
); 




wire timer_reset;

timer _timer (.reset(timer_reset), 
.clock(clock_27mhz), 
.enable(hz_enable), 
.value(value),   //the input value
.start(start_timer), 
.expired(expired), 
.timer_count(timer_count), 
.out_state(timer_state)
);




wire siren_reset;
synchronize siren_reset_sync (.clk(clock_27mhz), .in(~button_up), .out(siren_reset));


SirenGenerator siren(.clock_27mhz(clock_27mhz),
.siren_in(siren_enable),
.siren_out(siren_output));
////700hz
//wire high_out;
//siren_generator2 siren(.reset(siren_enable), 
//.clock(clock_27mhz), 
//.siren_out(high_out));
//
/////two different siren generators
//
////400 hz
//wire low_out;
//siren_generator siren2(.reset(siren_enable),
//.clock(clock_27mhz),
//.siren_out(low_out));
//
//reg switched_siren_out = 0;
//reg new_siren = 0;
//reg [25:0]count = 0;
//reg toggle = 1;
//reg start_siren = 0;
//
//always @ (posedge clock_27mhz) begin 
//    //switch between two sirens
//	 if (!start_siren) begin
//	    switched_siren_out <= low_out;
//		 start_siren <= 1;
//	 end
//	 if (siren_enable) begin
//		 if (count >= 25'd54000000) begin 
//		    //switch siren
//			 toggle <= !toggle;
//    	    switched_siren_out  <= toggle ? low_out : high_out; 
//	       count <= 25'b0;
//	    end
//		 else count <= count + 1;
//		 
//		 new_siren <= switched_siren_out;
//	 end
//	 else  begin
//	        count <= 25'b0;
//			  new_siren <= 0;
//	 end
//	
//end
//	

wire out_led_enable;
	 
wire [2:0] fsm_state;
AntiTheftModule anti_theft(.clock(clock_27mhz),
.reset(alarm_system_reset),
.ignition(ignition_switch),
.driver_door(driver_door),
.passenger_door(passenger_door),
.reprogram(reprogram),
.timer_expired(expired),
.timer_interval(interval),
.siren_on(siren_enable),
.status_indicator(status_light),
.start_timer(start_timer), 
.out_state(fsm_state),
.out_led_enable(out_led_enable),
.out_timer_reset(timer_reset));

wire [63:0] display_value;

assign display_value = {{1'b0, fsm_state},  {2'b0, timer_state}, 
                         {3'b0,hz_enable}, {2'b0,passenger_door, driver_door},
								 
								 {3'b0, out_led_enable}, 
								 {2'b0, timer_parameter_selector},
								 {timer_value}
								 ,31'b0, switch[6] , timer_count};
								 
display_16hex hexdisplay(.reset(alarm_system_reset), .clock_27mhz(clock_27mhz),
.data(display_value),
.disp_blank(disp_blank),
.disp_clock(disp_clock),
.disp_rs(disp_rs),
.disp_ce_b(disp_ce_b),
.disp_reset_b(disp_reset_b),
.disp_data_out(disp_data_out));


assign led[0] = ~status_light;
assign led[1] = ~fuel_pump_power;
//assign led[7:3] = 5'b1;

assign led[2] = switch[6];
assign led[3] = switch[6];
assign led[4] = switch[6];
assign led[5] = switch[6];
assign led[6] = switch[6];
assign led[7] = switch[6];

assign user1[4] = 0;//low_out;
assign user1[5] = 0;//high_out;

//16bits
//assign analyzer4_data = {start_timer, 1'b1, 14'b0};

assign user1[1] = 0;//new_siren;
assign user1[0] = siren_output;
assign user1[3] = 0;
assign user1[31:6] = 0;
assign user1[2] = 0;
 




//wire divider_test_enable;
/////testing
//divider test_divider(.reset(1), .clock(clock_27mhz), .enable(divider_test_enable));
//
//assign analyzer1_data [0] = divider_test_enable; 
//assign analyzer1_data[15:1] = 15'b0;
//assign user1[2]  = divider_test_enable;


endmodule
