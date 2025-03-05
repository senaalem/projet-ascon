`timescale 1ns / 1ps

/* module : permutateur avec ajout des OU exclusifs */
module permutator_xor import ascon_pack::*;
	(
		input type_state state_in_i,  // entrée : état-cible de la permutation (sur 5 * 64 = 320 bits)
		input logic[63:0] data64_i,   // entrée : données pour le OU exclusif en amont (sur 64 bits)
		input logic[255:0] data256_i, // entrée : données pour OU exclusif en aval (sur 256 bits)
		input logic[3:0] round_i,     // entrée : indice de ronde pour l'additionneur de constante (sur 4 bits)
		input logic clock_i,          // entrée : horloge pour le banc de registres (sur 1 bit)
		input logic resetb_i,         // entrée : reset pour le banc de registres (sur 1 bit)
		input logic xorup_select_i,   // entrée : sélecteur qui permet de piloter le OU exclusif en amont (sur 1 bit)
		input logic[1:0] xordn_select_i,   // entrée : selecteur qui permet de piloter le OU exclusif en aval (sur 1 bit)
		input logic input_select_i,   // entrée : sélecteur qui permet de piloter le multiplexeur en amont (sur 1 bit)
		input logic ena_reg_i,        // entrée : sélecteur qui permet d'écrire ou non dans le registre (sur 1 bit)
		output type_state state_out_o, // sortie : l'état permuté (sur 5 * 64 = 320 bits)
		output logic[63:0] cipher_o,
		output logic[127:0] tag_o
	);
	
	/*
	 * Ce module est une amélioration de la permutation avec mémorisation de l'état.
	 * Il a en plus de celui-ci deux modules qui réalisent un OU exclusif.
	 */

	type_state inmux_to_xorup_s, xorup_to_add_s, add_to_substit_s, substit_to_diff_s, diff_to_xordn_s, xordn_to_reg_s, reg_to_inmux_s; // signaux intermédiaires
	
	assign inmux_to_xorup_s = (input_select_i) ? reg_to_inmux_s : state_in_i; // multiplexeur amont, qui permet de sélectionner l'entrée
	
	/* module du OU exclusif en amont */
	xor_up xor_up_inst (
		.data_xor_up_i(data64_i),
		.ena_xor_up_i(xorup_select_i),
		.state_i(inmux_to_xorup_s),
		.state_o(xorup_to_add_s)
	);

	assign cipher_o = xorup_to_add_s[0];

	/* additionneur de constante */
	oconstant_adder oconstant_adder_inst (
		.constadd_addend_i(xorup_to_add_s),
		.round_i(round_i),
		.constadd_sum_o(add_to_substit_s)
	);

	/* couche de substitution */
	substitution_layer substitution_layer_inst (
		.substitution_target_i(add_to_substit_s),
		.substitution_substitute_o(substit_to_diff_s)
	);
	
	/* couche de diffusion */
	diffusion_layer diffusion_layer_inst (
		.diffusion_target_i(substit_to_diff_s),
		.diffusion_diffused_o(diff_to_xordn_s)
	);

	/* module du OU exclusif aval */
	xor_down xor_down_inst (
		.data_xor_down_i(data256_i),
		.ena_xor_down_i(xordn_select_i),
		.state_i(diff_to_xordn_s),
		.state_o(xordn_to_reg_s)
	);

	assign tag_o = {xordn_to_reg_s[3], xordn_to_reg_s[4]};
	
	/* banc de registres */
	register_state_we register_state_we_inst (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.we_i(ena_reg_i),
		.register_i(xordn_to_reg_s),
		.register_o(reg_to_inmux_s)
	);

	assign state_out_o = reg_to_inmux_s; // le signal de sortie est celui-ci
endmodule : permutator_xor
