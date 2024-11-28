// rosco
// Malcolm harrow, November 2024
// MIT License

// Memory map:
// * Onboard RAM    : $00000000 - $000FFFFF (1MB)
// * Expansion space: $00100000 - $00DFFFFF (13MB)
// * ROM            : $00E00000 - $00EFFFFF (1MB)
// * IO             : $00F00000 - $FFFFFFFF (1MB)

`default_nettype none

module rosco(
	// Signals that dont come from the CPU
	input i_CLK,
	input i_LGEXP_n, 
	input i_HWRST,

	// CPU signals
	input [2:0] i_FC,
	input [23:6] i_A,
	input [3:1] i_A_LOW,
	
	input i_AS_n,
	input i_RW,

	// in/out signals
	inout io_HALT_n,
	inout io_RESET_n,
	inout io_UDS_n,  // can be given by the CPU or set by CPUglue for 020/030
	inout io_LDS_n,  // can be given by the CPU or set by CPUglue for 020/030

	// CPU signals from 020/030 CPU
	input i_A0,
	input [1:0] i_SIZ, 
	input i_DS_n, 

	output o_BERR_n,
	output o_DTACK_n,
	output o_WR,	
	output o_EVENRAM_n,
	output o_ODDRAM_n,
	output o_EVENROM_n,
	output o_ODDROM_n,
	output o_IOSEL_n,
	output o_EXPSEL_n,
	output o_DUASEL_n,
	output o_RUNLED,
	output o_DUIACK_n,
	output o_E
);

// interupt selector
// 555 debouncer
// duart
// sd card

wire boot;
wire cpusp;

AddressDecoder ad (
	.i_A(i_A[23:18]),
	.i_UDS_n(io_UDS_n),
	.i_LDS_n(io_LDS_n),
	.i_BOOT(boot),
	.i_CPUSP(cpusp),
	.i_AS_n(i_AS_n),
	.i_RW(i_RW),
	.i_LGEXP_n(i_LGEXP_n), 
	.o_DTACK_n(o_DTACK_n),
	.o_WR(o_WR),	
	.o_EVENRAM_n(o_EVENRAM_n),
	.o_ODDRAM_n(o_ODDRAM_n),
	.o_EVENROM_n(o_EVENROM_n),
	.o_ODDROM_n(o_ODDROM_n),
	.o_IOSEL_n(o_IOSEL_n),
	.o_EXPSEL_n(o_EXPSEL_n)
	);

DuartSel ds(
	.i_A(i_A[19:6]),
	.i_LDS_n(io_LDS_n),
	.i_IOSEL_n(o_IOSEL_n),
	.o_DUASEL_n(o_DUASEL_n)
	);

Glue g(
	.i_A(i_A[19:19]),
	.i_A_LOW(i_A_LOW[3:1]),
	.i_FC(i_FC[2:0]),
	.i_HWRST(i_HWRST),
	.i_AS_n(i_AS_n),
	.o_HALT_n(io_HALT_n),
	.o_RESET_n(io_RESET_n),
	.o_RUNLED(o_RUNLED),
	.o_BOOT(boot),
	.o_CPUSP(cpusp),
	.o_DUIACK_n(o_DUIACK_n)
	);

Watchdog w (
	.i_CLK(i_CLK),
	.i_A19(i_A[19]),
	.i_CPUSP(cpusp),
	.i_AS_n(i_AS_n),
	.o_BERR_n(o_BERR_n)
	);

CPUglue CPUG(
	.i_CLK(i_CLK),
	.i_A0(i_A0),
	.i_DS_n(i_DS_n),
	.i_SIZ(i_SIZ[1:0]),
	.i_RESET_n(io_RESET_n),
	.o_UDS_n(io_UDS_n),
	.o_LDS_n(io_LDS_n), 
	.o_E(o_E)
);

endmodule;
