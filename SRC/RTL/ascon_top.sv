`timescale 1ns / 1ps

module ascon_top (
    input logic clock_i,
    input logic resetb_i,
    input logic[63:0] data_i,
    input logic data_valid_i,
    input logic[127:0] key_i,
    input logic start_i,
    input logic[127:0] nonce_i,
    output logic[63:0] cipher_o,
    output logic cipher_valid_o,
    output logic[127:0] tag_o,
    output logic end_o
    );

    logic ena_ocnt_s, init_a_s, init_b_s, xorup_select_s, input_select_s, ena_reg_s;
    logic[1:0] xordn_select_s;
    logic[3:0] round_s;

    fsm fsm_inst (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .start_i(start_i),
        .data_valid_i(data_valid_i),
        .round_i(round_s),
        .cipher_valid_o(cipher_valid_o),
        .end_o(end_o),
        .ena_ocnt_o(ena_ocnt_s),
        .init_a_o(init_a_s),
        .init_b_o(init_b_s),
        .xorup_select_o(xorup_select_s),
        .xordn_select_o(xordn_select_s),
        .input_select_o(input_select_s),
        .ena_reg_o(ena_reg_s)
    );

    counter_double_init conter_double_init_inst (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .ena_i(ena_ocnt_s),
        .init_a_i(init_a_s),
        .init_b_i(init_b_s),
        .count_o(round_s)
    );

    permutator_xor permutator_xor_inst (
        .state_in_i({data_i, key_i, nonce_i}),
		.data64_i(data_i),
		.data256_i(data256_s),
		.round_i(round_s),
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.input_select_i(input_select_s),
		.xorup_select_i(xorup_select_s),
		.xordn_select_i(xordn_select_s),
		.ena_reg_i(ena_reg_s),
		.state_out_o(),
		.cipher_o(cipher_o),
		.tag_o(tag_o)
    );

endmodule: ascon_top