

DDS MINI PROJECT

DIGITAL CLOCK IMPLEMENTATION

**SUBMITTED BY:**

**C.MASTHANAIAH – 191792CS115**

**KINTALI PRAVEEN – 191753CS129**

**K.SRINIVAS KALYAN – 191807CS130**

**M.L.S.V.SANDEEP – 191927CS226**

**Y.VENKAT KUMAR – 191803CS263**





\1. RESOURCE COLLECTION & DESIGN

§

§

KINTALI PRAVEEN

M.L.S.V.SANDEEP

\2. CODE IMPLEMENTATION

§

§

§

Y.VENKAT KUMAR

C.MASTHANAIAH

K.SRINIVAS KALYAN

CONTRIBUTIONS

\3. SIMULATION

§

§

Y.VENKAT KUMAR

C.MASTHANAIAH

\4. REPORT & PPT MAKING

§

§

§

K.SRINIVAS KALYAN

M.L.S.V.SANDEEP

KINTALI PRAVEEN





\1. PROJECT INFORMATION

\2. DESIGN PROCEDURE

\3. ADVANTAGES AND DISADVANTAGES

\4. SIMULATION PROCEDURE

\5. SIMULATION RESULTS

\6. CONCLUSION

CONTENTS

\7. REFERENCES





**PROJECT NUMBER: 10**

**PROBLEM STATEMENT:**

You have a circuit that represents a digital watch. The watch displays the time in the 12-Hour

format: Hour: Minute: Second. But due to some error, the watch displays time in 24-Hour format.

Design, implement, and synthesize the clock that can auto-detect and auto-correct the fault when it

exists.

**PLATFORM USED FOR DESIGNING:**

-Xilinx ISE Design Suite 14.7 for FPGA design





**DESIGN PROCEDURE**

We have implemented a 12-Hour format clock. After that, we modified it to a 24-hour format

through a switch model which asks the user to switch between the 24-hour and 12-Hour format

(in fact this switch is used as an error switch. When switch is on 24-Hour format, we treat it as

error and when switch is on 12-Hour format, it shows the corrected 12 -Hour format from 24 -

Hours at any time we switch to it). It displays **Hours**, **Minutes**, and **Seconds** through four 7-bit

segments. The following model consists of two files

\1. Digital\_Clock\_12\_hrs\_format.v

2.SSM\_Seven\_Segment\_Module.v

**Fig.** Design Diagram





**IMPLEMENTATION**

The file **Digital\_Clock\_12\_hrs\_format.v** is to generate a four **7-segment code** to display the

time by taking inputs which set the time through an interactive way on the board we implement it . By

default, it is set to 12:00:00 AM. When it runs, it quickly changes to 12:00:00 AM .

We use 5 controls to set the time.

\1. Center

\2. Up

\3. Down

\4. Left

\5. AM-PM LED Indicator

**Center** is a switch which on click moves from **set mode** to **display mode** on click**. Up** is used

to increase the number while setting (once it is 9 then jump to 0 again). Similarly **Down** to decrease the

number. **Left** is to shift between the 7-segment‘s. **AM-PM indicator** shows whether the set time is in

AM or PM.

The **SSM\_Seven\_Segment\_Module.v** file takes the input of six **7-segment** codes and

displays the Time and AM\_PM led based on the cases implemented for all four blocks one after the

other





**CODE WALKTHROUGH**

The above piece of code displays the usage of setting current mode:

**Current Mode** : This is used to toggle between the set\_time mode and display\_time mode. Initially

the current mode is set to 1 i.e., set\_time mode. It allows us to set a specific time initially, if no time

is set, then the system takes 12:00:00AM as default time.

When we change the current mode to 0. The clock starts running from the time which is set

during set\_time mode.





**CODE WALKTHROUGH (CONTD.)**

The above piece of code sets the link between Hours, Minutes and Seconds. As soon as

the second reaches ‘60’ , it is set to 0 and minutes increment by 1. Similarly , as the minute

reaches ‘60’ , it is set to 0 and hours increment by 1. And finally as the hour reaches 24, it is set to

‘0’ and the day changes (which is not shown in our project).





This piece of code shows the

solving part of the problem statement. The

code displays the set time(24 hr format) in

12 hr format. When it set time is in 12 hr

format. It just extract the digits from the

hours and displays them. If the set time is

above 12, then the above code is used to

convert it into 12 hour format and the pm

indicator set to 1.





**RTL DIAGRAMS**

**Top module:**

**Inputs:**

CEN: Selecting Clock Mode.

UP: Increment Value.

DOWN: Decrement Value.

RT: Toggle between Hours and minutes.

LF: Toggle between Hours and minutes.

**Outputs:**

[6:0] seg: 7 bit binary which is required to display digits in seven segment display.

[5:0] an: 6 bits enable which allows us to distinguish between the 4 display units (hrs\_tens,

hrs\_ones, min\_tens, min\_ones, sec\_tens, sec\_ones).





This piece of code

shows the conversion of 4 digit

binary (BCD) into seven

segment display:

It is used to display the

given number in the seven

segment display box. Each

display unit is divided into seven

segments in order to display a

digit in it. The 4 big input shows

the binary form of the number to

be displayed. and there is a 7 bit

output assigned for each binary

number. In the 7 bit binary, the

digit 0 shows that the respective

bulb in the display is on and the

bulb is off when the bit is 1.





**SEVEN SEGMENT DISPLAY**

The following figure shows the display

of digits in the seven segment display unit.

Each digit is shown when a certain

combination of 7 bits is given as input. The

numbers shown on each digit implies that the

certain bits must be given 0 and the rest

should be given 1 in the seven bit binary.

Hence, the above piece of code assign the unique 7 bit binary for each digit,

to show in the seven segment display.





**Segment and Enable:**

This piece of code helps to update

the time, so when there is a change in the

time, the enable(an) triggers the specific

digit in the display box and the

segment(seg) gets the respective

updated digit. and all the 6 digits gets

updated as the enable triggers each bit.





**RTL DIAGRAMS**

**Seven Segment Module:**

**Inputs:**

Clk: The system clock with 100Mhzs frequency and Basys

3 board.

Hrs\_tens: tens digit of hours.

Hrs\_ones: unit digit of hours.

Min\_tens: tens digit of minutes.

Min\_ones: unit digit of minutes.

Sec\_tens: tens digit of seconds.

Sec\_ones: unit digit of seconds.

**Outputs:**

The outputs are same as in the top module as the output will be a combination of both the modules.

We basically use wires to connect the outputs to the display box.





**SIMULATION PROCEDURE**

The hours and minutes are broken into tens and ones . The model will take 5 inputs as

mentioned above in the Implementation section. When we press the center button, it moves

between set mode and display mode based on the previous state. It changes the mode whenever a

user presses the center button .

Once the center button enables the display mode , it starts with the value set during the set

mode and runs the clock from that point. If it enables the set mode , then the clock stops until it is

pressed again. During the set mode , it allows the user to set the time using the other 4 controls i.e.,

left ,right, up, down. Left is used to shift from one block to immediate left block except for the

leftmost block for which it shifts to the rightmost block .

Similarly right is used to shift from one block to immediate right except for the rightmost block

for which it moves to the left most block . the block which is under change is indicated with blinking

action (same as cursor in PPT).

When the user increases the minutes beyond 59 ,it reflects in the hours(increase by

one),resetting the minutes to zero. But when the user goes beyond 12 it alters the AM\_PM indicator

LED and reset the hours to 1. Once the user got the desired time then he needed to click the center

button to start the clock.





**RESULTS TABLE**

We have auto-corrected the 24-hours format into 12-hours format .





**POWER REPORT**





**SOLVING**

As we have given 24-Hour format to convert to 12-Hour format

whenever the time exceeds 12PM, we need to change only hours

segments by decreasing it by 12 hours and turning on the AM\_PM

indicator LED. It can be auto corrected by the Switch already mentioned

in the introduction section . Whenever the time is set , it check the switch

whether it should display in 24-Hours format or 12-Hours format . When

the Switch is changed from 24-Hours-format to 12-Hours format, the

program checks whether the set time is greater than 12 or not . If it is

greater than 12 ,it is changed to 12-hours format and enables the LED .





**ADVANTAGES AND DISADVANTAGES**

**ADVANTAGES**

**DISADVANTAGES**

Set Mode helps us to set the time we wish and

run the clock from there.

While setting the time we must ensure that

AM\_PM Led is on if we wish to set the time in

PM.

AM\_PM LED Indicator helps us to know

whether the displayed time is in AM | PM.

We aren't giving the output signals

simultaneously, rather we change each

segment of the 4 blocks one after the other .But

it is changed in a short time such that we don't

observe this disadvantage .

Speed of the clock that we designed is equal to

the speed of the system clock. So, whenever

we set a time to the clock it runs parallel to the

system clock.

It only displays the hours and minutes block due

to restrictions on the FPGA board.

We can alter the speed at which the clock runs

in the code.

While setting the time in set\_mode, it is possible

to change only minutes and hours while the

seconds cant be changed manually.





**SIMULATION RESULTS**

**Timing Diagrams:**

◦ Timing diagrams are extracted using Xilinx design suite.

The following are the different cases where timing diagram shows changes.

◦ Clock runs when clock mode is 1, allows us to set time when clock mode =0.





·

Seconds coming back to 0 after it exceeds 59, Minutes coming back to 0 after it exceeds 59, hours

coming back to 0 after it exceeds 23.

Increment of minute for every cycle of seconds, increment of hours for every cycle of minutes.





·

When clock mode is off and the time is set in 24 hr format, when the clock runs, the digits are

displayed in 12 hr format(problem statement).





·

**AM/PM Conversion**

When the time is set to 11:59:00AM and the clock is set to display mode, we can observe

that as soon as the clock time exceeds 12:00:00 noon, the AM/PM indicator changes from 0 to

1, which shows that the time time changes from AM to PM.





**CONCLUSION**

This project gave us the knowledge about working of counters and digital clocks. By

implementing verilog code , We have gained experience about hardware design with the

help of Xilinx ISE Design Suite.

We have verified the working of the digital clock we designed with the

system clock(PC).

**REFERENCES**

§

§

§

<https://youtu.be/pFHKVLrjOSk>

<https://youtu.be/YM8s4SfHBPU>

<https://youtu.be/8_Um6Cx6bD8>





THANK YOU

