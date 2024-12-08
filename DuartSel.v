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
	
	assign o_DUASEL_n = !(i_A[19:6] == 0 && !i_LDS_n && !i_IOSEL_n);
endmodule

// Pin assignments for yosys flow
// Designed to be used with the little atf programmer for easy patching to test
//PIN: CHIP "Glue" ASSIGNED TO AN PLCC44
//PIN: i_A[6:6]   : 41
//PIN: i_A[7:7]   : 39
//PIN: i_A[8:8]   : 37
//PIN: i_A[9:9]   : 34
//xPIN: i_A[10:10]     : 32 // Cant fit, let fitter decide
//PIN: i_A[11:11]  : 29
//PIN: i_A[12:12]  : 27
//PIN: i_A[13:13]  : 25
//PIN: i_A[14:14]  : 21
//PIN: i_A[15:15]  : 19
//PIN: i_A[16:16]  : 17
//GND 14
//---
//VCC 40
//NC 38 // Cant fit, let fitter decide
//NC 36
//NC 33
//PIN: o_DUASEL_n  : 31
//PIN: i_IOSEL_n   : 28
//PIN: i_LDS_n     : 26
//PIN: i_A[18:18]  : 24
//PIN: i_A[17:17]  : 20
//NC   : 18
//PIN: i_A[19:19]  : 16
//NC 13


// Pin assignments from the 22v10 design
//    1   | A6       | Clock/Input
//    2   | A7       | Input
//    3   | A8       | Input
//    4   | A9       | Input
//    5   | A10      | Input
//    6   | A11      | Input
//    7   | A12      | Input
//    8   | A13      | Input
//    9   | A14      | Input
//   10   | A15      | Input
//   11   | A16      | Input
//   12   | GND      | GND

//   24   | VCC      | VCC
//   23   | NC       | NC
//   22   | NC       | NC
//   21   | NC       | NC
//   20   | DUASEL   | Output
//   19   | IOSEL    | Input
//   18   | LDS      | Input
//   17   | A18      | Input
//   16   | A17      | Input
//   15   | NC       | NC
//   14   | A19      | Input
//   13   | NC       | NC
