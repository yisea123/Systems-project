
module lab2 (clk, go, pwm, posRed, pwm_check, left_check, right_check);
 
// Inputs
 input clk, go, posRed;

 // Outputs
 output pwm, pwm_check, left_check, right_check;
 
// Asuming clock c = 50 MHz therefore clock period = 20 ns
 // and 256 steps
 // t0 = 20ms, p = t0/c = 1'000'000 - number of clock ticks for one whole cycle
 // t1 = 1 ms, P = t1/c = 50'000 - numbder of clock ticks for one 1ms
 // lenght = t1 + p/256 * (ASCII value)

 parameter [16:0] PWM_length_left = 50000; //should be 1 ms
 parameter [16:0] PMW_length_mid = 65000;
 parameter [16:0] PWM_length_right = 100000; //should be 2 ms

 reg [20:0] counter = 0;
 reg [9:0] cycleCounterIncreaser = 0;
 reg [1:0] cycleCounter = 0;
 reg pwm;
 reg left_check, right_check, pwm_check;
 reg [4:0] go_count = 0;
 reg [1:0] active = 0;
 reg [2:0] x;

	 always @(posedge clk) begin

		 if(go) begin
			 active = 1;
			 go_count = go_count +1;
		 end
		
		if (posRed == 1) begin
			active = 0;
			counter = counter+1;
			
			if(cycleCounterIncreaser <= 50) begin
				if (counter <= PWM_length_right) pwm = 1;
				else pwm = 0;
			end
			
			if (counter > 999999) begin
				counter = 0;
				cycleCounterIncreaser = cycleCounterIncreaser+1;
				if (cycleCounterIncreaser >= 100) cycleCounterIncreaser = 0;
			 end
		end

		 if(active == 1) begin

			 counter = counter+1; // Increase steps counter

			 if(cycleCounterIncreaser <= 50) begin
				 case (cycleCounter)
					 0: begin // First two cycles, first initial
						 left_check = 1;
						 right_check = 0;
						 if (counter <= PWM_length_left) pwm = 1;
						 else pwm = 0;
					 end

					 1: begin // Next two cycles, second initial
						 left_check = 0;
						 right_check = 1;
						 if (counter <= PWM_length_right) pwm = 1;
						 else pwm = 0;
					 end
				 endcase
			 end
			 // When full cycle complete, go from beginning, increse cycle counter
			 if (counter > 999999) begin
				counter = 0;
				cycleCounterIncreaser = cycleCounterIncreaser+1;
				if (cycleCounterIncreaser >= 100) begin
					if (cycleCounter == 1) cycleCounter = 0;
					else cycleCounter = cycleCounter+1;
					cycleCounterIncreaser = 0;
					active = 0;
				end
			 end
			 pwm_check <= pwm;
		 end
	 end
 
endmodule