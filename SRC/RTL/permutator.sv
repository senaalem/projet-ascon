`timescale 1ns / 1ps

/* module : permutation avec mémorisation de l'état */
module permutator import ascon_pack::*;
	(
		input type_state state_in_i,  // entrée : état-cible (sur 5 * 64 = 320 bits)
		input logic[3:0] round_i,     // entrée : indice de ronde (sur 4 bits)
		input logic clock_i,          // entrée : horloge (sur 1 bit)
		input logic resetb_i,         // entrée : reset (sur 1 bit)
		input logic input_select_i,   // entrée : sélecteur de l'entrée (sur 1 bit)
		output type_state state_out_o // sortie : état permuté (sur 5 * 64 = 320 bits)
	);
	
	/* la permutation se fait grâce à 4 modules en série avec un multiplexeur en amont */

	type_state mux_to_add_s, add_to_substit_s, substit_to_diff_s, diff_to_reg_s, reg_to_mux_s; // déclaration des signaux intermédiaires
	
	/* 
	 * Ce multiplexeur permet de sélectionner si l'entrée vient de l'extérieur ou 
	 * du banc de registres pour permettre d'enchaîner (ou non) les permutations. 
	 */
	assign mux_to_add_s = (input_select_i) ? reg_to_mux_s : state_in_i;
	
	/* l'additionneur de constante */
	oconstant_adder oconstant_adder_inst (
		.constadd_addend_i(mux_to_add_s),
		.round_i(round_i),
		.constadd_sum_o(add_to_substit_s)
	);

	/* la couche de substitution */
	substitution_layer substitution_layer_inst (
		.substitution_target_i(add_to_substit_s),
		.substitution_substitute_o(substit_to_diff_s)
	);
	
	/* la couche de diffusion */
	diffusion_layer diffusion_layer_inst (
		.diffusion_target_i(substit_to_diff_s),
		.diffusion_diffused_o(diff_to_reg_s)
	);
	
	/* la banc de registres */
	register_state register_state_inst (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.register_i(diff_to_reg_s),
		.register_o(reg_to_mux_s)
	);

	assign state_out_o = reg_to_mux_s;

endmodule : permutator
