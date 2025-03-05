`timescale  1ns/1ps

module xor_up import ascon_pack::*;
	(
	 input logic [63:0]	 data_xor_up_i,
	 input logic		 ena_xor_up_i,
	 input type_state 	 state_i,
	 output type_state 	 state_o
	 );

	// Upstream XOR
	assign state_o[0] = (ena_xor_up_i) ? state_i[0] ^ data_xor_up_i : state_i[0];
	assign state_o[1] = state_i[1];
	assign state_o[2] = state_i[2];
	assign state_o[3] = state_i[3];
	assign state_o[4] = state_i[4];

endmodule : xor_up
