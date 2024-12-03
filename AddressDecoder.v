// AddressDecoder
// Malcolm harrow, November 2024
// MIT License

`default_nettype none

module AddressDecoder(
	input [23:18] i_A,
	input i_UDS_n,
	input i_LDS_n,
	input i_BOOT,
	input i_CPUSP_n,
	input i_AS_n,
	input i_RW,
	input i_LGEXP_n,
	output PPDTACK,  // has to be an output for the tri-state logic to work
	output o_DTACK_n,
	output o_WR,	
	output o_EVENRAM_n,
	output o_ODDRAM_n,
	output o_EVENROM_n,
	output o_ODDROM_n,
	output o_IOSEL_n,
	output o_EXPSEL_n
	);
	
	wire ram = (!i_CPUSP_n && !i_AS_n && (i_A[23:20] == 4'h0));
	wire isram = (ram && i_BOOT) || (ram && !i_A[19] && !i_BOOT) || (ram && !i_A[18] && !i_BOOT) || (ram && !i_RW && !i_BOOT);
	assign o_EVENRAM_n = !(isram && !i_UDS_n);
	assign o_ODDRAM_n = !(isram && !i_LDS_n);

	wire rom = (!i_CPUSP_n && !i_AS_n && (i_A[23:20] == 4'hE)) || (!i_CPUSP_n && !i_AS_n && (i_A[23:18] == 6'b000000) && i_RW && !i_BOOT);
	assign o_EVENROM_n = !(rom && !i_UDS_n);
	assign o_ODDROM_n = !(rom && !i_LDS_n);
	
	assign o_IOSEL_n = !(!i_CPUSP_n && (i_A[23:20] == 4'hF));
	assign o_EXPSEL_n = !(!i_CPUSP_n && (i_A[23:20] >= 4'h1) && (i_A[23:20] <= 4'hD));
	
	assign o_WR = !i_RW;
	
	assign PPDTACK = !i_CPUSP_n && (!o_EVENROM_n || !o_ODDROM_n || !o_EVENRAM_n || !o_ODDRAM_n || (!i_LGEXP_n && !o_EXPSEL_n));
	assign o_DTACK_n = PPDTACK ? 1'b0 : 1'bZ;

endmodule
