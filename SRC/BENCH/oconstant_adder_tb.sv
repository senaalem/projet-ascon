`timescale 1ns / 1ps

/* banc de test pour l'additionneur de constante */
module oconstant_adder_tb import ascon_pack::*;
	(/* partie déclarative vide */);
	
	/* déclaration des signaux de test */
	type_state constadd_addend_s, constadd_sum_s;
	logic[3:0] round_s;
	
	/* instanciation du module */
	oconstant_adder DUT (
		.constadd_addend_i(constadd_addend_s),
		.round_i(round_s),
		.constadd_sum_o(constadd_sum_s)
	);
	
	/* protocole de test */
	initial begin
		constadd_addend_s = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000; // le signal d'entrée à 0
		round_s = 4'h0; // l'indice de ronde est à 0 au début
		#10;
		round_s = 4'h1; // on passe l'indice de ronde à 1
	end
endmodule : oconstant_adder_tb
