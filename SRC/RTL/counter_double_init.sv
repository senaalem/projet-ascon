`timescale  1ns/1ps

module counter_double_init
	(
	 input logic		clock_i,
	 input logic		resetb_i,
	 input logic		ena_i,
	 input logic		init_a_i,
	 input logic		init_b_i,
	 output logic [3:0]	count_o
	 );

	logic [3:0]			count_s;

	always @(posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin
			count_s <= 0;
		end
		else begin
			if (ena_i == 1'b1) begin
				if (init_a_i == 1'b1)
					count_s <= 0;
				else if (init_b_i == 1'b1)
					count_s <= 6;
				else
					count_s <= count_s + 1;
			end
		end
	end // always @ (posedge clock_i, negedge resetb_i)

	assign count_o = count_s;
	
endmodule // counter_double_init
