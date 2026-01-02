// Thunderbird FSM testbench

module thunderbirdFSM_tb;

// Declare tb Signals
logic clk, reset, LEFT, RIGHT, HAZ;
logic [2:0] L_lights, R_lights;

// instantiate UUT
thunderbirdFSM UUT (
.clk(clk),
.reset(reset),
.LEFT(LEFT),
.RIGHT(RIGHT),
.HAZ(HAZ),
.L_lights(L_lights),
.R_lights(R_lights)
);

// Initialize Signals and clk Generator (10-second cycles)
initial begin
	clk = 0;
	reset = 1;
	LEFT = 0;
	RIGHT = 0;
	HAZ = 0;
	forever #5 clk = ~clk;
end

// Stimulus 
initial begin
	#10 reset = 0;

	// Run through left sequence
	#10 LEFT = 1;
	#40;

	// Run through right sequence
	LEFT = 0;
	RIGHT = 1;
	#40;

	// Interrupt right sequence with HAZ
	#10 HAZ = 1;

	#10 HAZ = 0; RIGHT = 0;

	// Interrupt left sequence with HAZ
	#10 LEFT = 1;
	#20 HAZ = 1;

	#10 HAZ = 0; LEFT = 0;

	// HAZ from IDLE
	#10 HAZ = 1;

	#10 HAZ = 0;

	// Left and Right Simultaneously -> LR3
	#10 LEFT = 1; RIGHT = 1;
	
	#20 $finish;
end

endmodule
