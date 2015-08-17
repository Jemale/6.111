`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:19 10/10/2013 
// Design Name: 
// Module Name:    Anti-TheftModule 
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
module AntiTheftModule(
    input clock,
    input reset,
    input ignition,
    input driver_door,
    input passenger_door,
    input reprogram,
    input timer_expired,
    output [1:0] timer_interval,
    output siren_on,
    output status_indicator,
    output start_timer,
	 output [2:0] out_state,
	 output out_led_enable,
	 output out_timer_reset,
	 output siren_reset
    );

   parameter STATE_ARMED     = 3'b000;
   parameter STATE_TRIGGERED = 3'b001;
   parameter STATE_SOUNDING  = 3'b010;
   parameter STATE_SOUNDING2 = 3'b011;
   parameter STATE_DISARMED  = 3'b100;
   parameter STATE_DISARMED_DOOR_OPEN  = 3'b101;
   parameter STATE_DISARMED_WAIT = 3'b110;
	
	
   parameter T_ARM_DELAY       = 2'b00;
	parameter T_DRIVER_DELAY    = 2'b01;
	parameter T_PASSENGER_DELAY = 2'b10;
	parameter T_ALARM_ON        = 2'b11; 
   
	reg [1:0] interval_reg;
	reg timer_reset = 0;
	reg ntimer_reset= 0;
	reg reg_start_timer = 0;
	reg reg_status_indicator = 0;
	reg reg_siren_on = 0;
	
	reg out_siren_reset = 0;
   reg rsiren_reset   = 0;
   
   	
   wire led_toggle;
	reg led_enable = 1'b0;
	divider led_timer(.clock(clock), .reset(1), .enable(led_toggle));

   reg [2:0] state, next_state;
	always @(*) begin
      //implement state transition diagram
		if (reset) next_state = STATE_ARMED;
		else if (reprogram) begin
		  next_state = STATE_ARMED;
		  ntimer_reset = 1;
		end
		else if (ignition) next_state = STATE_DISARMED;
		else case(state)
		   STATE_ARMED: 
			    begin
                  ntimer_reset = 0;				 
						if (driver_door || passenger_door) begin
						  next_state = STATE_TRIGGERED;
                    	
                    end						  
						else 
						next_state = state;		
						
						if (led_toggle) led_enable = !led_enable;
						reg_start_timer = 0;
						reg_siren_on    = 0;
                 reg_status_indicator = led_enable;
                 rsiren_reset = 0;					  
						
				 end
			STATE_TRIGGERED: 
             begin
				      interval_reg = passenger_door ? T_PASSENGER_DELAY : T_DRIVER_DELAY;
				      if (timer_expired) next_state =  STATE_SOUNDING;
						else next_state = state;
						reg_start_timer = 1;
						reg_siren_on    = 0;
                 reg_status_indicator = 1;
                 rsiren_reset = 0	;				  
				 end
			STATE_SOUNDING:
             begin
				      if( !driver_door && !passenger_door) next_state =  STATE_SOUNDING2;
                  else next_state = state; //fix
						
						reg_start_timer = 0;
						reg_siren_on    = 1;
                  reg_status_indicator = 1;
						rsiren_reset = 1;
				 end
			STATE_SOUNDING2: 
             begin  
                  interval_reg = T_ALARM_ON;
						reg_start_timer = 1;
						reg_siren_on    = 1;
                  reg_status_indicator = 1;	
						
				      if (timer_expired) next_state = STATE_ARMED;
						else next_state = state;
				 end
			STATE_DISARMED: 
             begin
				      if (!ignition && (driver_door || passenger_door)) next_state = STATE_DISARMED_DOOR_OPEN;
						else next_state = state;
						
						reg_start_timer = 0;
							reg_siren_on    = 0;
                 reg_status_indicator = 0;	
				 end
			STATE_DISARMED_DOOR_OPEN: 
             begin
				      ntimer_reset = 0;
						reg_start_timer = 0;
						reg_siren_on    = 0;
                  reg_status_indicator = 0;	
					  
				      if (!driver_door && !passenger_door) next_state = STATE_DISARMED_WAIT;
                  else next_state = state;						
				 end
			STATE_DISARMED_WAIT: 
             begin
				      interval_reg = T_ARM_DELAY;
						reg_start_timer = 1;
							reg_siren_on    = 0;
                 reg_status_indicator = 0;	
					  
						if (driver_door || passenger_door) begin 
						   next_state = STATE_DISARMED_DOOR_OPEN;
							ntimer_reset = 1;
						end
						//need to reset timer
				      else if(timer_expired) next_state = STATE_ARMED;
						else next_state = state;
				 end
			default: next_state = STATE_ARMED;
		endcase
	end
			    
   
   reg [1:0] ntimer_interval;
   reg nsiren_on, nstatus_indicator, nstart_timer, nout_led_enable, nout_timer_reset;
   	

   always @ (posedge clock)begin
      state            <= next_state;
		timer_reset       <= ntimer_reset;
		
		nstart_timer      <= reg_start_timer;//((next_state == STATE_TRIGGERED) ||  (next_state == STATE_SOUNDING2) || (next_state == STATE_DISARMED_WAIT));
      
	   nstatus_indicator <= reg_status_indicator;//(next_state == STATE_ARMED) ? led_enable : ((next_state == STATE_TRIGGERED) || (next_state == STATE_SOUNDING) || (next_state == STATE_SOUNDING2)) ? 1 : 0;
	
	   nsiren_on         <= reg_siren_on;//((next_state == STATE_SOUNDING) || (next_state == STATE_SOUNDING2));
      ntimer_interval   <=  interval_reg;

      nout_led_enable   <=  led_enable;
	   nout_timer_reset   <=  reset ? reset : ntimer_reset;   

  end
   
	//assign n;
	assign start_timer      = nstart_timer;//((state == STATE_TRIGGERED) ||  (state == STATE_SOUNDING2) || (state == STATE_DISARMED_WAIT));
	
	assign status_indicator =  nstatus_indicator;//(state == STATE_ARMED) ? led_enable : ((state == STATE_TRIGGERED) || (state == STATE_SOUNDING) || (state == STATE_SOUNDING2)) ? 1 : 0;
	
	assign siren_on         =  nsiren_on;//((state == STATE_SOUNDING) || (state == STATE_SOUNDING2));
   assign timer_interval   =  ntimer_interval;//interval_reg;
	assign out_state        =  state;
   assign out_led_enable   =  nout_led_enable;
 	assign out_timer_reset  =  nout_timer_reset;//reset ? reset : timer_reset;  

   assign siren_reset      =  out_siren_reset;	

endmodule
