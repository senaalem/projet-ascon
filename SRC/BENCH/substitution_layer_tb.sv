`timescale 1ns/1ps

/* banc de test pour la couche de substitution */
module substitution_layer_tb import ascon_pack::*;
	(/* partie déclarative vide */);
	
	/* déclaration des signaux de test */
	type_state substitution_target_s, subsitution_substitute_s;
	
	/* instanciation du module */
	substitution_layer DUT (
		.substitution_target_i(substitution_target_s),
		.substitution_substitute_o(subsitution_substitute_s)
	);

	/* protocole de test */
	initial begin
		substitution_target_s = 320'h80400c0600000000_8a55114d1cb6a9a2_be263d4d7aecaaff_4ed0ec0b98c529b7_c8cddf37bcd0284a; // état initial
	end
endmodule : substitution_layer_tb

