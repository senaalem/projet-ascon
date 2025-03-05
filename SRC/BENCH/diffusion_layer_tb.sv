`timescale 1ns/1ps

/* banc de test pour la couche de diffusion */
module diffusion_layer_tb import ascon_pack::*;
	(/* partie déclarative vide */);
	
	/* délaration des signaux de test */
	type_state diffusion_target_s, diffusion_diffused_s;
	
	/* instanciation du module */
	diffusion_layer DUT (
		.diffusion_target_i(diffusion_target_s),
		.diffusion_diffused_o(diffusion_diffused_s)
	);

	/* protocole de test */
	initial begin
		diffusion_target_s = 320'h78e2cc41faabaa1a_bc7a2e775aababf7_4b81c0cbbdb5fc1a_b22e133e424f0250_044d33702433805d; // état après la substitution initiale
	end
endmodule : diffusion_layer_tb
