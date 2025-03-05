`timescale 1ns / 1ps

/* module : couche de substitution */
module substitution_layer import ascon_pack::*;
	(
		input type_state substitution_target_i,     // entrée : cible de la substitution (sur 5 * 64 = 320 bits)
		output type_state substitution_substitute_o // sortie : résultat de la substitution (sur 5 * 64 = 320 bits)
	);
	
	/* 
	 * On se sert de 64 S-boxes, une pour chaque quintuplet de l'état-cible (5 * 64 = 320)
	 * pour réaliser la permutation.
	 * On concatène x_0[i], x_1[i], x_2[i], x_3[i] et x_4[i] pour i allant de 0 à 64 pour 
	 * former 5 bits, que l'on envoie ensuite dans une S-box. On reconcatène le tout en 
	 * sortie ensuite pour former notre résultat.
	 */
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin : glabel_0
			sbox sbox_inst (
				.sbox_target_i({substitution_target_i[0][i], substitution_target_i[1][i], substitution_target_i[2][i], substitution_target_i[3][i], substitution_target_i[4][i]}), // concaténation des entrées vers la S-box i
				.sbox_substitute_o({substitution_substitute_o[0][i], substitution_substitute_o[1][i], substitution_substitute_o[2][i], substitution_substitute_o[3][i], substitution_substitute_o[4][i]}) // concaténation des sorties
			);
		end : glabel_0
	endgenerate

endmodule : substitution_layer
