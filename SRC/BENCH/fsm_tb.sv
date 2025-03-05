`timescale 1ns / 1ps

module fsm_tb import ascon_pack::*;
    (/* partie déclarative vide */);

    /* signaux communs pour les trois devices under test */
    logic clock_s, resetb_s, ena_ocnt_s, init_a_s, init_b_s, xorup_select_s, input_select_s, ena_reg_s;
    logic[3:0] round_s;
    logic[1:0] xordn_select_s;

    /* signaux pour la FSM */
    logic start_s, data_valid_s, cipher_valid_s, end_s;

	/* signaux pour la permutation avec OU exclusif */
	type_state state_in_s, state_out_s;
	logic[63:0] data64_s, cipher_s;
	logic[255:0] data256_s;
    logic[127:0] tag_s;

    /* instanciation de la FSM */
    fsm DUT_1 (
        .clock_i(clock_s),
		.resetb_i(resetb_s),
		.start_i(start_s),
		.data_valid_i(data_valid_s),
		.round_i(round_s),
		.cipher_valid_o(cipher_valid_s),
		.end_o(end_s),
		.ena_ocnt_o(ena_ocnt_s),
		.init_a_o(init_a_s),
		.init_b_o(init_b_s),
		.xorup_select_o(xorup_select_s),
		.xordn_select_o(xordn_select_s),
		.input_select_o(input_select_s),
		.ena_reg_o(ena_reg_s)
    );

    /* instanciation du module de permutation */
	permutator_xor DUT_2 (
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
	counter_double_init DUT_3 (
		.clock_i(clock_s),
		.resetb_i(resetb_s),
		.ena_i(ena_ocnt_s),
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
        resetb_s = 1'b0;
        data64_s = 64'b0;
        data256_s = 256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_8A_55_11_4D_1C_B6_A9_A2_BE_26_3D_4D_7A_EC_AA_FF; // opérande du OU exclusif
        start_s = 1'b0;
        data_valid_s = 1'b0;
        #10;
        resetb_s = 1'b1;
        #10;
        start_s = 1'b1;
        #10;
        start_s = 1'b0;
        #150;
        data64_s = 64'h41_20_74_6f_20_42_80_00;
        #10;
        data_valid_s = 1'b1;
        #10;
        data_valid_s = 1'b0;
        data256_s = 256'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_01;
        #80;
        data64_s = 64'h52_44_56_20_61_75_20_54;
        #10;
        data_valid_s = 1'b1;
        #10;
        data_valid_s = 1'b0;
        data256_s = 256'h8A_55_11_4D_1C_B6_A9_A2_BE_26_3D_4D_7A_EC_AA_FF_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00;
        #80;
        data64_s = 64'h69_27_62_61_72_20_63_65;
        #10;
        data_valid_s = 1'b1;
        #10;
        data_valid_s = 1'b0;
        #80;
        data64_s = 64'h20_73_6f_69_72_20_3f_80;
        #10;
        data_valid_s = 1'b1;
        #10;
        data_valid_s = 1'b0;


    end
endmodule: fsm_tb
