// DUART Selection
// Malcolm harrow, November 2024
// MIT License

`default_nettype none

module DuartSel(
	input [19:6] i_A,
	input i_LDS_n,
	input i_IOSEL_n,
	output o_DUASEL_n
	);
	
	assign o_DUASEL_n = ~(i_A[19:6] == 14'b11111111111111 && ~i_LDS_n && ~i_IOSEL_n);
endmodule
