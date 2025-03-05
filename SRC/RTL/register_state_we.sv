`timescale 1ns / 1ps

/* module du registre d'état avec autorisation d'écriture */
module register_state_we import ascon_pack::*;
	(
		input logic clock_i,         // entrée : horloge
		input logic resetb_i,        // entrée : reset
		input logic we_i,            // entrée : permet de piloter l'écriture (ou non) dans le registre
		input type_state register_i, // entrée : état à stocker dans le registre (sur 320 bits)
		output type_state register_o // sortie : état stocké dans le registre (sur 320 bits)
	);

	type_state register_s; // permet la mémorisation

	always_ff @(posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin 
			register_s <= {64'h0, 64'h0, 64'h0, 64'h0, 64'h0}; // si le reset est à l'état bas, on efface la mémoire
		end
		else begin 
			if (we_i == 1'b1) begin
				register_s <= register_i; // si l'écriture est autorisée, on lit l'entrée
			end
			else begin
				register_s <= register_s; // sinon, on garde ce qui était écrit précedemment
			end
		end
	end
	assign register_o = register_s;

endmodule : register_state_we
