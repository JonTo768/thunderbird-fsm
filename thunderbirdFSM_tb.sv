// Thunderbird FSM testbench

module thunderbirdFSM_tb;

// declare tb signals
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

// initialize signals and clk generator (10 second cycles)
initial begin
	clk = 0;
	reset = 1;
	LEFT = 0;
	RIGHT = 0;
	HAZ = 0;
	forever #5 clk = ~clk;
end

// stimulus 
initial begin
	#10 reset = 0;

	// run through left sequence
	#10 LEFT = 1;
	#40;

	// run through right sequence
	LEFT = 0;
	RIGHT = 1;
	#40;

	// interrupt right sequence with HAZ
	#10 HAZ = 1;

	#10 HAZ = 0; RIGHT = 0;

	// interupt left sequence with HAZ
	#10 LEFT = 1;
	#20 HAZ = 1;

	#10 HAZ = 0; LEFT = 0;

	// HAZ from idle
	#10 HAZ = 1;

	#10 HAZ = 0;

	// Left and Rigth simultaneously -> LR3
	#10 LEFT = 1; RIGHT = 1;
	
	#20 $finish;
end
endmodule