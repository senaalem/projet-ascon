`timescale 1ns/1ps

/* module : couche de diffusion */
module diffusion_layer import ascon_pack::*;
	(
		input type_state diffusion_target_i,   // entrée : cible de la diffusion (sur 5 * 64 = 320 bits) 
		output type_state diffusion_diffused_o // sortie : résultat de la diffusion (sur 5 * 64 = 320 bits)
	);
	
	/* la diffusion se fait avec des OU exclusifs entre différentes parties de l'entrée interchangées */
	assign diffusion_diffused_o[0] = diffusion_target_i[0] ^ {diffusion_target_i[0][18:0], diffusion_target_i[0][63:19]} ^ {diffusion_target_i[0][27:0], diffusion_target_i[0][63:28]};
	assign diffusion_diffused_o[1] = diffusion_target_i[1] ^ {diffusion_target_i[1][60:0], diffusion_target_i[1][63:61]} ^ {diffusion_target_i[1][38:0], diffusion_target_i[1][63:39]};
	assign diffusion_diffused_o[2] = diffusion_target_i[2] ^ {diffusion_target_i[2][0], diffusion_target_i[2][63:1]} ^ {diffusion_target_i[2][5:0], diffusion_target_i[2][63:6]};
	assign diffusion_diffused_o[3] = diffusion_target_i[3] ^ {diffusion_target_i[3][9:0], diffusion_target_i[3][63:10]} ^ {diffusion_target_i[3][16:0], diffusion_target_i[3][63:17]};
	assign diffusion_diffused_o[4] = diffusion_target_i[4] ^ {diffusion_target_i[4][6:0], diffusion_target_i[4][63:7]} ^ {diffusion_target_i[4][40:0], diffusion_target_i[4][63:41]};
endmodule : diffusion_layer
