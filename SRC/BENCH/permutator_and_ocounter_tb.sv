`timescale 1ns / 1ps

/* banc de test de la permutation (avec OU exclusif) associée au compteur de ronde */
module permutator_and_ocounter_tb import ascon_pack::*;
	(/* partie déclarative vide */);

	/* signaux communs */
	logic clock_s, resetb_s;

	/* signaux pour la permutation avec OU exclusif */
	type_state state_in_s, state_out_s;
	logic[63:0] data64_s, cipher_s;
	logic[255:0] data256_s;
	logic[3:0] round_s;
	logic input_select_s, xorup_select_s, ena_reg_s;
	logic[1:0] xordn_select_s;
	logic[127:0] tag_s;

	/* signaux pour le compteur de ronde */
	logic ena_s, init_a_s, init_b_s;

	/* instanciation du module de permutation */
	permutator_xor DUT_1 (
		.state_in_i(state_in_s),
		.data64_i(data64_s),
		.data256_i(data256_s),
		.round_i(round_s),
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.input_select_i(input_select_s),
		.xorup_select_i(xorup_select_s),
		.xordn_select_i(xordn_select_s),
		.ena_reg_i(ena_reg_s),
		.state_out_o(state_out_s),
		.cipher_o(cipher_s),
		.tag_o(tag_s)
	);

	/* instanciation du compteur de ronde */
	counter_double_init DUT_2 (
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.ena_i(ena_s),
		.init_a_i(init_a_s),
		.init_b_i(init_b_s),
		.count_o(round_s)
	);
	
	/* configuration de l'horloge */
	initial begin
		clock_s = 1'b0;
		forever #5 clock_s = ~clock_s;
	end

	/* protocole de test */
	initial begin
		state_in_s = 320'h80400c0600000000_8a55114d1cb6a9a2_be263d4d7aecaaff_4ed0ec0b98c529b7_c8cddf37bcd0284a; // état initial
		// r = 00
		resetb_s = 1'b0; // on éteind la permutation
		input_select_s = 1'b0; // l'entrée vient de l'intérieur
		xordn_select_s = 1'b0; // pas de OU exclusif en aval
		xorup_select_s = 1'b0; // ni en amont
		ena_reg_s = 1'b1; // on autorise l'écriture dans le registre
		data64_s = 64'b0;
		data256_s = 256'b0;
		ena_s = 1'b0; // compteur de ronde éteint
		init_a_s = 1'b1; // d'abord p_12
		init_b_s = 1'b0;
		#10;
		ena_s = 1'b1; // on allume le compteur de ronde
		init_a_s = 1'b0;
		resetb_s = 1'b1; // on allume la permutation
		#10;
		// r = 01
		input_select_s = 1'b1;
		#10;
		// r = 02
		#10;
		// r = 03
		#10;
		// r = 04
		#10;
		// r = 05
		#10;
		// r = 06
		#10;
		// r = 07
		#10;
		// r = 08
		#10;
		// r = 09
		#10;
		// r = 10
		#10;
		// r = 11
		xordn_select_s = 1'b1; // on fait le OU exclusif en aval
		data256_s = 256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_8A_55_11_4D_1C_B6_A9_A2_BE_26_3D_4D_7A_EC_AA_FF; // opérande du OU exclusif
		init_b_s = 1'b1; // on passe à p_6
		#10;
		xordn_select_s = 1'b0; // on arrête le OU exclusif en aval
		ena_reg_s = 1'b0; // on empêche l'écriture dans le registre pour se placer en attente
	end
endmodule : permutator_and_ocounter_tb
