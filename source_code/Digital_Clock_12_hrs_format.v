`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:46 03/14/2021 
// Design Name: 
// Module Name:    Digital_Clock_12_hrFomrat 
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


module Digital_Clock_12_hrFomrat(
    input clk,					// system clock 100 MHz
    input center,				// center button for clock mode i.e selecting and deselecting clock mode
    input right,				// to toggle between minutes and hours
    input left,				// to toggle between minutes and hours
    input up,					// to increment hrs or minutes
    input down,				// to decrement hrs or minutes
    output [6:0] seg,		// 7 segment of the display
    output [5:0] an,			// to enable 4 seven bit display
    output AMPM_indicator_led,	// Light on indicates PM, light Off indicates AM
    output clock_mode_indicator_led // indicate clock in clock mode when light is on
    );
	 
	 /*setting ports for slow clock (1hz) for the clock*/
	 reg [31:0] counter = 0;   	// hrs 1 - 10, min 0-59, sec 0-59
	 parameter max_count = 625_000; //100_000_000 -> set this value while using FPGA board clock// 100Mhz/1Hz =100M(1 second resolution)
	 
	 /*setting up port fors hours and minutes, clock display*/
	 reg [5:0] hrs, min,sec = 0;		// hrs = 12 , min = 0-59, sec = 0-59
	 reg [3:0] sec_ones,sec_tens,min_ones, min_tens, hrs_ones, hrs_tens = 0; // initally all bits are set to 0
	 reg toggle = 0; // toggle between minutes and hours to change, 0 - minutes, 1-hours
	 
	 /*assigning inital value to indicator leds (AM/PM/clock mode)*/
	 reg pm = 0; // initially PM is set to zero
	 assign AMPM_indicator_led = pm; // initially led is set to 0, means the clock displays time in AM intially
	 reg clock_mode = 0;
	 assign clock_mode_indicator_led = clock_mode; // initally led is set to 0, means clock is not in clock mode
	 
    /*instantiating the seven segment module*/
	 SSM_Seven_Segment_Module SSM(clk,sec_ones,sec_tens,min_ones,min_tens,hrs_ones,hrs_tens,seg,an);
	 
	 /*ports for setting up time(sec,min,hrs) on clock, By default clock is not working in clock mode*/
	 /*and therefore using pushbuttons time can be adjusted, when the center button is pressed then */
	 parameter display_time = 1'b0;
	 parameter set_time = 1'b1;
	 reg current_mode = set_time; //set_time
	 
	 /*setting-up 1 second increment for clock and adjusting the new set time*/
	 always @(posedge clk) begin
			case(current_mode)
				display_time: begin 	//clock mode - 10:00AM to 11:59 PM
					if (center) begin	// if center button goes high, new time is adjusted, all counters are reset
						 clock_mode <= 0;
						 current_mode <= set_time;
						 /*Reset variable to prepare for set time mode*/
						 counter <= 0;
						 toggle <= 0;
						 sec <= 0;
					end
					
					if (counter < max_count) begin //time
						 counter <= counter + 1;
					end else begin
						 counter <= 0;
						 sec <= sec + 1;
					end
				end
//________________________________________________________________________________________________________________________________________________
	 /*setting up hours and minutes to set a new time (up and down button)*/
				set_time: begin
					if (center) begin // push center button commit time set tand return to clock mode
						 clock_mode <= 1;
						 current_mode <= display_time;
					end
					
					if (counter < (25_000)) begin //25_000_000 set this value while using FPGA board clock
					                              // setting - up clock speed to 4hz for pushbuttons
						 counter <= counter + 1;
					end else begin
						 counter <= 0;
						 case (toggle)
							   1'b0: begin // minutes change
									 if (up) begin
										  min <= min + 1;
									 end
									 if (down) begin // Dec minutes when you push BTN_down
										  if (min>0) begin
											   min <= min - 1;												
												end else if (hrs > 1) begin
												hrs <= hrs - 1;
												min <= 59;
										  end else if (hrs == 1) begin
												hrs <= 12;
												min <= 59;
										  end
									 end
									 
		/*Toggle between hours and minutes to set a new time (Right and left Button)*/
									 if (left || right ) begin // push left/right button to swap between hours/minutes
											toggle <= 1;
									 end
								end //end 1'b0
								
								1'b1: begin // hours change
									 if (up) begin // inc hours and when you push BTN_down
										  hrs <= hrs + 1;
									 end 
									 if (down) begin
											if(hrs>1) 
											begin
												hrs <= hrs -1;
											end
											else if (hrs == 1) 
												begin
												hrs <= 12;
												// AM_PM <= - AM_PM
												end
											end
										
											if ( right || left ) begin // push left/right buttons to swap between hours/minutes 
											toggle <= 0;
											end
									  end //end 1'b1
						      endcase	// end case (current bit)
								end
							end // end set_clock
					endcase //end case (Current Mode)

//________________________________________________________________________________________________________________________________________________

		/*Digital clock 12hrs format*/
				   if (sec >= 60) begin 	// after 60 secs, increment minutes
							sec <= 0;
							min <= min +1;
					end
					if (min >= 60) begin		// after 60 mins, increment hours 
							min <= 0;
							hrs <= hrs + 1;
					end
					if (hrs >= 24) begin		// after 12 hours, swap between AM and PM
						 hrs <= 0;
					end
					
		/*AM PM time*/
		
					if(clock_mode == 0) begin
						min_ones <= min%10;	// 1's of minutes
						min_tens <= min/10;		// 10's of mintutes
						sec_ones <= sec%10;	// 1's of minutes
						sec_tens <= sec/10;		// 10's of mintutes
						hrs_ones <= hrs%10;	// 1's of hours
						hrs_tens <= hrs/10;	// 10's of hours
						if(hrs>12) begin
							pm <= 1;
						end
					end
					// clock mode 1 
					else begin 					// 0 = AM, PM Time
						min_ones <= min%10;	// 1's of minutes
						min_tens <= min/10;		// 10's of mintutes
						sec_ones <= sec%10;	// 1's of minutes
						sec_tens <= sec/10;		// 10's of mintutes
						if (hrs<12) begin
							pm<=0;
							if (hrs == 0) begin
								hrs_ones <= 2;
								hrs_tens <= 1;
							end 
							else begin
								hrs_ones <= hrs%10;	// 1's of hours
								hrs_tens <= hrs/10;	// 10's of hours
						end
					end //end hours >= 12
						if (hrs>=12) begin
							pm <= 1;
							if (hrs == 12) begin
								hrs_ones <= 2;
								hrs_tens <= 1;
							end 
							else if(hrs <22) begin
								hrs_ones <= hrs%12;	// 1's of hours
								hrs_tens <= hrs/22;	// 10's of hours
							end
							else begin
							// 22 -> 10
							//(12+10)%22 = 0;
							//(24)/22 = 1;
								hrs_ones <= hrs%22;	// 1's of hours
								hrs_tens <= hrs/22;	// 10's of hours
						end
						  // pm <= 1;
					end  // end hours >= 12
				end 	  // end clock display
			end
						
endmodule
