`timescale  1ns/1ps

module register_state import ascon_pack::*;
	(
	 input logic	clock_i,
	 input logic	resetb_i,
	 input		type_state register_i,
	 output		type_state register_o
	 );

	// Register
	always @ (posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 
			register_o <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0};
		end
		else begin
			register_o <= register_i;
		end
	end

endmodule : register_state
