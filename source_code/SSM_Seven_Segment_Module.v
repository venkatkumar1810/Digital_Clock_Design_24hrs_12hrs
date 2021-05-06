`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:46 03/14/2021 
// Design Name: 
// Module Name:    SSM_Seven_Segment_Module 
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

module SSM_Seven_Segment_Module(
	
	/* Declarations of Inputs and Outputs */
    input clk, // sytem clock with 100MHz, 3 boards
	 input [3:0] sec_ones,
    input [3:0] sec_tens,
	 input [3:0] min_ones, //0-9, 9 --> 1001 
    input [3:0] min_tens,
    input [3:0] hrs_ones,
    input [3:0] hrs_tens, //1 numbers
	 output reg [6:0] seg,
    output reg [5:0] an
    );
	/*port identificcations declaring wires and registers*/
	reg [1:0] digit_display = 0;
	reg [6:0] display [3:0];
	
	reg [18:0] counter = 0;
	parameter max_count = 500_000; //1000Mhz/100Hz = 1M divided by 2 = 500,000
	wire [3:0] four_bit [5:0]; 	 //[3:0]
	
	/*Assigning values that needs to be reflected on the 7_Segement display*/
	assign four_bit[0] = sec_ones;
	assign four_bit[1] = sec_tens;
	assign four_bit[2] = min_ones;
	assign four_bit[3] = min_tens;
	assign four_bit[4] = hrs_ones;
	assign four_bit[5] = hrs_tens;
	
	/*100 Hz slow clock for enabling each segment each segment at refresh 
	  of 10ms clk display counter */
	  
	always @(posedge clk) begin
	   if (counter < max_count ) begin
			counter <= counter +1;
	   end else 
		begin
			digit_display <= digit_display +1;
			counter <= 0;
	   end
		/*BCD to seven segment display, check for values for min and hrs*/
		case(four_bit[digit_display])
			4'b0000 :display[digit_display] <= 7'b1000000; //0
			4'b0001 :display[digit_display] <= 7'b1111001; //1
			4'b0010 :display[digit_display] <= 7'b0100100; //2
			4'b0011 :display[digit_display] <= 7'b0110000; //3
			4'b0100 :display[digit_display] <= 7'b0011001; //4
			4'b0101 :display[digit_display] <= 7'b0010010; //5
			4'b0110 :display[digit_display] <= 7'b0000010; //6
			4'b0111 :display[digit_display] <= 7'b1111000; //7
			4'b1000 :display[digit_display] <= 7'b0000000; //8
			4'b1001 :display[digit_display] <= 7'b0011000; //9
			4'b1010 :display[digit_display] <= 7'b0001000; //10 A
			4'b1011 :display[digit_display] <= 7'b0000011; //11 B
			4'b1100 :display[digit_display] <= 7'b1000110; //12 C
			4'b1101 :display[digit_display] <= 7'b0100001; //13 D
			4'b1110 :display[digit_display] <= 7'b0000110; //13 E
			default: display[digit_display] <= 7'b0001110; //Otherwise F
			
	   endcase
		/*Enabling each segment and displaying the digit*/
		case(digit_display) //cycles through display
				0: begin
					an <= 6'b111110;
					seg <= display[0];
				end
				
				1: begin
					an <= 6'b111101;
					seg <= display[1];
				end
				
				2: begin
					an <= 6'b111011;
					seg <= display[2];
				end
				
				3: begin
					an <= 6'b110111;
					seg <= display[3];
				end
				
				4: begin
					an <= 6'b101111;
					seg <= display[4];
				end
				
				5: begin
					an <= 6'b011111;
					seg <= display[5];
				end
				
			endcase
		end//slow clock end
endmodule
