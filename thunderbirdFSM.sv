// Thunderbird Finite State Machine


// Module header and port declerations
module thunderbirdFSM (
input logic LEFT, RIGHT, HAZ, clk, reset,
output logic [2:0] L_lights, R_lights
);

	// Declare state assignments
	/* 
	8 states: (need 3 bits)
	IDLE: 000, no lights on
	L1: 001, one left light on
	L2: 011, two left lights on
	L3: 010, all left lights on
	R1: 101, one right light on
	R2: 111, two right lights on
	R3: 110, all left lights on
	LR3: 100, all left and right lights on
	*/
	typedef enum logic [2:0] {
		IDLE = 3'b000,
		L1 = 3'b001,
		L2 = 3'b011,
		L3 = 3'b010,
		R1 = 3'b101,
		R2 = 3'b111,
		R3 = 3'b110,
		LR3 = 3'b100
	} state_t;

	state_t current_state, next_state;
	
	// Sequential Logic, state register (memory)
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			current_state <= IDLE;
		else 
			current_state <= next_state; // non blocking assignment in sequential blocks
						// current_state isnt assigned to next_state until the end of the block, irrelevant in this case
	end
	
	// Combinational Logic, next state logic
	always_comb begin
		// Default behavior to prevent X or latch. 
		next_state = IDLE;
		case (current_state)
			IDLE: begin
				if (HAZ || (LEFT && RIGHT))
					next_state  = LR3;
				else if (LEFT & ~HAZ & ~RIGHT) // same as if (LEFT)
					next_state = L1;
				else if (RIGHT & ~HAZ & ~LEFT) // same as if (RIGHT)
					next_state = R1;
				else if (~(LEFT | RIGHT | HAZ)) // same as non asserted, else
					next_state = IDLE;
			end

			L1: begin
				if (HAZ)
					next_state = LR3;
				else if (~HAZ)
					next_state = L2;

				// next_state  = (HAZ ? LR3:L2);
			end

			L2: begin
				if (HAZ)
					next_state = LR3;
				else if (~HAZ)
					next_state = L3;
				// next_state = (HAZ ? LR3:L3)
			end

			L3: begin
				next_state =  IDLE;
			end
				// Can exclude begin and end if one line

			R1: begin
				if (HAZ)
					next_state = LR3;
				else if (~HAZ)
					next_state = R2;
				// next_state = (HAZ ? LR3:R2)
			end

			R2: begin
				if (HAZ)
					next_state = LR3;
				else if (~HAZ)
					next_state = R3;
				// next_state = (HAZ ? LR3:R3)
			end

			R3: next_state = IDLE;

			LR3: next_state = IDLE;
			
			default: next_state = IDLE;
		endcase
	end

	// Output Logic (Moore Machine)
	always_comb begin
		// default
		L_lights = 3'b000;
		R_lights = 3'b000;
		case (current_state)
			IDLE: begin
				L_lights = 3'b000;
				R_lights = 3'b000;
			end
			L1: begin
				L_lights = 3'b001;
				R_lights = 3'b000;
			end
			L2: begin
				L_lights = 3'b011;
				R_lights = 3'b000;
			end
			L3: begin
				L_lights = 3'b111;
				R_lights = 3'b000;
			end
			R1: begin
				L_lights = 3'b000;
				R_lights = 3'b001;
			end
			R2: begin
				L_lights = 3'b000;
				R_lights = 3'b011;
			end
			R3: begin
				L_lights = 3'b000;
				R_lights = 3'b111;
			end
			LR3: begin
				L_lights = 3'b111;
				R_lights = 3'b111;
			end
			default: ; // already zeroed, in idle state

		endcase
	end

endmodule