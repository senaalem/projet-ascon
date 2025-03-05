`timescale 1ns / 1ps

/* banc de test pour la permutation avec les OU exclusifs */
module permutator_xor_tb import ascon_pack::*;
	(/* partie déclarative vide */);
	
	/* déclaration des signaux de test */
	type_state state_in_s, state_out_s;
	logic[63:0] data64_s, cipher_s;
	logic[255:0] data256_s;
	logic[3:0] round_s;
	logic clock_s, resetb_s, input_select_s, xorup_select_s, ena_reg_s; 
	logic[1:0] xordn_select_s;
	logic[127:0] tag_s;

	/* instanciation du module */
	permutator_xor DUT (
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
	
	/* configuration de l'horloge */
	initial begin
		clock_s = 1'b0;
		forever #5 clock_s = ~clock_s;
	end
	
	/* protocole de test */
	initial begin
		state_in_s = 320'h80400c0600000000_8a55114d1cb6a9a2_be263d4d7aecaaff_4ed0ec0b98c529b7_c8cddf37bcd0284a; // état initial
		round_s = 4'b0000; // r = 00
		resetb_s = 1'b0;
		input_select_s = 1'b0; // l'entrée vient de "l'extérieur"
		xordn_select_s = 1'b0; // pas de OU exclusif en aval
		xorup_select_s = 1'b0; // pas de OU exclusif en amont
		ena_reg_s = 1'b1; // on autorise l'écriture dans le registre
		data64_s = 64'b0;
		data256_s = 256'b0;
		#10;
		resetb_s = 1'b1; // on allume la machine
		#10;
		round_s = 4'b0001; // r = 01
		input_select_s = 1'b1; // l'entrée vient de "l'intérieur" : on enchaîne les permutations
		#10
		round_s = 4'b0010; // r = 02
		#10
		round_s = 4'b0011; // r = 03
		#10
		round_s = 4'b0100; // r = 04
		#10
		round_s = 4'b0101; // r = 05
		#10
		round_s = 4'b0110; // r = 06
		#10
		round_s = 4'b0111; // r = 07
		#10
		round_s = 4'b1000; // r = 08
		#10
		round_s = 4'b1001; // r = 09
		#10
		round_s = 4'b1010; // r = 10
		#10
		round_s = 4'b1011; // r = 11
		xordn_select_s = 1'b1; // on fait un OU exclusif en aval
		data256_s = 256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_8A_55_11_4D_1C_B6_A9_A2_BE_26_3D_4D_7A_EC_AA_FF; // l'opérande du OU exclusif
	end
endmodule : permutator_xor_tb

