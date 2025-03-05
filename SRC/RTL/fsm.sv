`timescale 1ns / 1ps

module fsm (
		input logic clock_i, // entrée : horloge (sur 1 bit)
		input logic resetb_i, // entrée : reset (sur 1 bit)
		input logic start_i, // entrée : démarrage du chiffrement (sur 1 bit)
		input logic data_valid_i, // entrée : indication système de validité des données en entrée (sur 1 bit)
		input logic[3:0] round_i, // entrée : indice de ronde (sur 4  bits)
		output logic cipher_valid_o, // sortie : indication de fin de chiffrement (sur 1 bit)
		output logic end_o, // sortie : fin de l'Ascon (sur 1 bit)
		output logic ena_ocnt_o, // sortie : interrupteur du compteur de rondes (sur 1 bit)
		output logic init_a_o, // sortie : initialisation de l'indice de ronde à 0 (sur 1 bit)
		output logic init_b_o, // sortie : initialisation de l'indice de ronde à 6 (sur 1 bit)
		output logic xorup_select_o, // sortie : contrôle du OU exclusif amont (sur 1 bit)
		output logic[1:0] xordn_select_o, // sortie : contrôle du OU exclusif aval (sur 2 bits)
		output logic input_select_o, // sortie : sélection de l'entrée de la permutation (sur 1 bit)
		output logic ena_reg_o // sortie : permission de l'écriture dans le registre d'état (sur 1 bit)
	);

	/* déclaration des états de la machine */
	typedef enum {
		idle, set_ocnt,
		start_init, init, end_init, wait_xor_a1, xor_a1,
		p6_1, end_p6_1, wait_xor_p1, xor_p1,
		p6_2, end_p6_2, wait_xor_p2, xor_p2,
		p6_3, end_p6_3, wait_xor_p3, xor_p3,
		start_compl, compl, end_compl
	} fsm_state;
	
	fsm_state current_state_s, next_state_s; // variables pour gérer l'état de la FSM

	/* processus séquentiel pour stocker l'état courant */
	always_ff @(posedge clock_i, negedge resetb_i) begin
		if (resetb_i == 1'b0) begin
			current_state_s <= idle;
		end
		else begin
			current_state_s <= next_state_s;
		end
	end
	
	/* processus combinatoire pour passer à l'état suivant */
	always_comb begin: OUPUT_STATE
		case(current_state_s)
			/* en attente du start */
			idle: begin
				if (start_i == 1'b1)
					next_state_s = set_ocnt;
				else
					next_state_s = idle;
			end
			/* on règle le compteur de ronde */
			set_ocnt: begin
				next_state_s = start_init;
			end
			/* phase d'initialisation */
			start_init: begin
				next_state_s = init;
			end
			init: begin
				if (round_i == 4'ha)
					next_state_s = end_init;
				else
					next_state_s = init;
			end
			end_init: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_a1;
				else
					next_state_s = wait_xor_a1;
			end
			wait_xor_a1: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_a1;
				else
					next_state_s = wait_xor_a1;
			end
			xor_a1: begin
				next_state_s = p6_1;
			end
			/* première p_6 */
			p6_1: begin
				if (round_i == 4'ha)
					next_state_s = end_p6_1;
				else
					next_state_s = p6_1;
			end
			end_p6_1: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p1;
				else
					next_state_s = wait_xor_p1;
			end
			wait_xor_p1: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p1;
				else
					next_state_s = wait_xor_p1;
			end
			xor_p1: begin
				next_state_s = p6_2;
			end
			/* deuxième p_6 */
			p6_2: begin
				if (round_i == 4'ha)
					next_state_s = end_p6_2;
				else
					next_state_s = p6_2;
			end
			end_p6_2: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p2;
				else
					next_state_s = wait_xor_p2;
			end
			wait_xor_p2: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p2;
				else
					next_state_s = wait_xor_p2;
			end
			xor_p2: begin
				next_state_s = p6_3;
			end
			/* troisième p_6 */
			p6_3: begin
				if (round_i == 4'ha)
					next_state_s = end_p6_3;
				else
					next_state_s = p6_3;
			end
			end_p6_3: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p3;
				else
					next_state_s = wait_xor_p3;
			end
			wait_xor_p3: begin
				if (data_valid_i == 1'b1)
					next_state_s = xor_p3;
				else
					next_state_s = wait_xor_p3;
			end
			xor_p3: begin
				next_state_s = start_compl;
			end
			/* phase de finalisation */
			start_compl: begin
				next_state_s = compl;
			end
			compl: begin
				if (round_i == 4'ha)
					next_state_s = end_compl;
				else
					next_state_s = compl;
			end
			end_compl: begin
				next_state_s = idle;
			end
		endcase
	end

	/* processus combinatoire pour gérer sorties */
	always_comb begin: OUPUT_LOGIC
		/* valeurs par défaut des sorties */
		cipher_valid_o = 1'b0;
		end_o = 1'b0;
		ena_ocnt_o = 1'b0;
		init_a_o = 1'b0;
		init_b_o = 1'b0;
		xorup_select_o = 1'b0;
		xordn_select_o = 1'b0;
		input_select_o = 1'b1;
		ena_reg_o = 1'b1;

		case(current_state_s)
			/* en attente du start */
			idle: begin
				input_select_o = 1'b0;
			end
			/* on règle le compteur de ronde */
			set_ocnt: begin
				ena_ocnt_o = 1'b1;
				init_a_o = 1'b1;
				input_select_o = 1'b0;
			end
			/* phase d'initialisation */
			start_init: begin
				ena_ocnt_o = 1'b1;
				input_select_o = 1'b0;
			end
			init: begin
				ena_ocnt_o = 1'b1;
			end
			end_init: begin
				ena_ocnt_o = 1'b1;
				init_b_o = 1'b1;
				xordn_select_o = 1'b1;
			end
			wait_xor_a1: begin
				ena_reg_o = 1'b0;
			end
			xor_a1: begin
				ena_ocnt_o = 1'b1;
				xorup_select_o = 1'b1;
			end
			/* première p_6 */
			p6_1: begin
				ena_ocnt_o = 1'b1;
			end
			end_p6_1: begin
				ena_ocnt_o = 1'b1;
				init_b_o = 1'b1;
				xordn_select_o = 1'b1;
			end
			wait_xor_p1: begin
				ena_reg_o = 1'b0;
			end
			xor_p1: begin
				cipher_valid_o = 1'b1;
				ena_ocnt_o = 1'b1;
				xorup_select_o = 1'b1;
			end
			/* deuxième p_6 */
			p6_2: begin
				ena_ocnt_o = 1'b1;
			end
			end_p6_2: begin
				ena_ocnt_o = 1'b1;
				init_b_o = 1'b1;
			end
			wait_xor_p2: begin
				ena_reg_o = 1'b0;
			end
			xor_p2: begin
				cipher_valid_o = 1'b1;
				ena_ocnt_o = 1'b1;
				xorup_select_o = 1'b1;
			end
			/* troisième p_6 */
			p6_3: begin
				ena_ocnt_o = 1'b1;
			end
			end_p6_3: begin
				ena_ocnt_o = 1'b1;
				init_a_o = 1'b1;
			end
			wait_xor_p3: begin
				ena_reg_o = 1'b0;
			end
			xor_p3: begin
				cipher_valid_o = 1'b1;
				ena_ocnt_o = 1'b1;
				xorup_select_o = 1'b1;
			end
			/* phase de finalisation */
			start_compl: begin
				ena_ocnt_o = 1'b1;
				init_a_o = 1'b1;
				input_select_o = 1'b1;
				xordn_select_o = 1'b1;
			end
			compl: begin
				ena_ocnt_o = 1'b1;
			end
			end_compl: begin
				end_o = 1'b1;
				xordn_select_o = 1'b1;
			end
		endcase
	end
	
endmodule: fsm
