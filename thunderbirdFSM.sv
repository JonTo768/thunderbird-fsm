// Thunderbird Finite State Machine


// Module header and port declarations
module thunderbirdFSM (
input logic LEFT, RIGHT, HAZ, clk, reset,
output logic [2:0] L_lights, R_lights
);

	// State type & State Register
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
	
	// State Register (Memory)
	always_ff @ (posedge clk or posedge reset) begin
		if (reset)
			current_state <= IDLE;
		else 
			current_state <= next_state;
	end
	
	// Next State Logic
	always_comb begin
		// Default to IDLE to prevent X behavior or latch. 
		next_state = IDLE;
		case (current_state)
			IDLE: begin
				if (HAZ || (LEFT && RIGHT))
					next_state  = LR3;
				else if (LEFT)
					next_state = L1;
				else if (RIGHT)
					next_state = R1;
				else
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

			L3: next_state =  IDLE;

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
		// Default to IDLE
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
			default: begin
				// IDLE
				L_lights = 3'b000;
				R_lights = 3'b000;
			end
		endcase
	end
endmodule
