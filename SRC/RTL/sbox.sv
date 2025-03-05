`timescale 1ns / 1ps

/* module : table de substitution (S-box) */
module sbox import ascon_pack::*;
	(
		input logic[4:0] sbox_target_i,     // entrée : cible de la subsitution (sur 5 bits)
		output logic[4:0] sbox_substitute_o // sortie : résultat de la substitution (sur 5 bits)
	);

	/* on modélise le tableau de substitution par un processus combinatoire */
	always_comb begin : comb_0
		case(sbox_target_i)
			5'h00:
				sbox_substitute_o = 5'h04;
			5'h01:
				sbox_substitute_o = 5'h0b;
			5'h02:
				sbox_substitute_o = 5'h1f;
			5'h03:
				sbox_substitute_o = 5'h14;
			5'h04:
				sbox_substitute_o = 5'h1a;
			5'h05:
				sbox_substitute_o = 5'h15;
			5'h06:
				sbox_substitute_o = 5'h09;
			5'h07:
				sbox_substitute_o = 5'h02;
			5'h08:
				sbox_substitute_o = 5'h1b;
			5'h09:
				sbox_substitute_o = 5'h05;
			5'h0a:
				sbox_substitute_o = 5'h08;
			5'h0b:
				sbox_substitute_o = 5'h12;
			5'h0c:
				sbox_substitute_o = 5'h1d;
			5'h0d:
				sbox_substitute_o = 5'h03;
			5'h0e:
				sbox_substitute_o = 5'h06;
			5'h0f:
				sbox_substitute_o = 5'h1c;
			5'h10:
				sbox_substitute_o = 5'h1e;
			5'h11:
				sbox_substitute_o = 5'h13;
			5'h12:
				sbox_substitute_o = 5'h07;
			5'h13:
				sbox_substitute_o = 5'h0e;
			5'h14:
				sbox_substitute_o = 5'h00;
			5'h15:
				sbox_substitute_o = 5'h0d;
			5'h16:
				sbox_substitute_o = 5'h11;
			5'h17:
				sbox_substitute_o = 5'h18;
			5'h18:
				sbox_substitute_o = 5'h10;
			5'h19:
				sbox_substitute_o = 5'h0c;
			5'h1a:
				sbox_substitute_o = 5'h01;
			5'h1b:
				sbox_substitute_o = 5'h19;
			5'h1c:
				sbox_substitute_o = 5'h16;
			5'h1d:
				sbox_substitute_o = 5'h0a;
			5'h1e:
				sbox_substitute_o = 5'h0f;
			5'h1f:
				sbox_substitute_o = 5'h17;
		endcase
	end : comb_0

endmodule : sbox
