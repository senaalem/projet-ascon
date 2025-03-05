`timescale 1ns / 1ps

/* module : additionneur de constante */
module oconstant_adder import ascon_pack::*;
	(
		input type_state constadd_addend_i, // entrée : opérande de l'additionneur (sur 5 * 64 = 320 bits)
		input logic[3:0] round_i,           // entrée : indice de ronde (sur 4 bits)
		output type_state constadd_sum_o    // sortie : somme fournie par l'additionneur (sur 5 * 64 = 320 bits)
	);
	
	assign constadd_sum_o[0] = constadd_addend_i[0];
	assign constadd_sum_o[1] = constadd_addend_i[1];
	assign constadd_sum_o[2][63:8] = constadd_addend_i[2][63:8];
	assign constadd_sum_o[2][7:0] = constadd_addend_i[2][7:0] ^ round_constant[round_i]; // on effectue le OU exclusif sur les 7 premiers bits de x_2 
	assign constadd_sum_o[3] = constadd_addend_i[3]; // toutes les autres lignes du tableau sont intouchées
	assign constadd_sum_o[4] = constadd_addend_i[4];
	
endmodule : oconstant_adder
