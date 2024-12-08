// Glue
// Malcolm harrow, November 2024
// MIT License

`default_nettype none

module Glue(
	input [19:19] i_A,  
	input [3:1] i_A_LOW,
	input [2:0] i_FC,
	input i_HWRST, 
	input i_AS_n,
	
	output o_HALT_n,
	output o_RESET_n, 
	output o_RUNLED,
	output reg o_BOOT,
	output o_CPUSP_n,
	output o_DUIACK_n
	);
	// Tri state is not well supported by yosys .. do not use these in any equations ...
	assign o_HALT_n = i_HWRST ? 1'b0 : 1'bZ;
	assign o_RESET_n = i_HWRST ? 1'b0 : 1'bZ;
	assign o_RUNLED =  i_HWRST; 
	
	assign o_CPUSP_n = !(!i_HWRST && (i_FC[2:0] == 3'b111));
	assign o_DUIACK_n = !((!i_HWRST && (i_FC[2:0] == 3'b111)) && !i_AS_n && (i_A[19] == 1) && (i_A_LOW[3:1] == 3'b100)); 

	// The GALasm uses A19/A18 to spot when the first 4 reads have completed
	// Here we will count AS (memory access) cycles to set BOOT for the first 4 memory reads

	reg [2:0] counter = 0;

	initial begin
		o_BOOT <= 1'b0;
		counter <= 0;
	end
	
	always @(posedge i_AS_n) begin
		if (i_HWRST) begin // should really check halt and reset, but tri state not well handled
			counter <= 0;
			o_BOOT <= 1'b0;
		end
		else begin
			if (!o_BOOT) begin
				counter <= counter + 3'b1;
				if (counter == 4) 
					o_BOOT <= 1'b1;
			end
		end
	end
endmodule

// Pin assignments for yosys flow
// Designed to be used with the little atf programmer for easy patching to test
//PIN: CHIP "Glue" ASSIGNED TO AN PLCC44
//PIN: i_AS_n     : 41
//NC 39
//PIN: i_HWRST    : 37
//PIN: i_FC_2     : 34
//xPIN: i_FC_1     : 32 // Cant fit, let fitter decide
//PIN: i_FC_0     : 29
//PIN: i_A_LOW_0  : 27
//PIN: i_A_LOW_1  : 25
//PIN: i_A_LOW_2  : 21
//PIN: i_A        : 19
//NC  17
//GND 14
//---
//VCC 40
//xPIN: o_DUIACK_n : 38 // Cant fit, let fitter decide
//PIN: o_CPUSP_n  : 36
//PIN: o_BOOT     : 33
//NC 31
//NC 28
//NC 26
//PIN: o_RUNLED   : 24
//PIN: o_RESET_n  : 20
//PIN: o_HALT_n   : 18
//NC 16
//NC 13


// Pin assignments from the 22v10 design
//    1   | AS       | Clock/Input
//    2   | IOSEL    | Input
//    3   | HWRST    | Input
//    4   | FC2      | Input
//    5   | FC1      | Input
//    6   | FC0      | Input
//    7   | A1       | Input
//    8   | A2       | Input
//    9   | A3       | Input
//   10   | A19      | Input
//   11   | A18      | Input
//   12   | GND      | GND

//   24   | VCC      | VCC
//   23   | DUIACK   | Output
//   22   | CPUSP    | Output
//   21   | BOOT     | Output
//   20   | NC       | NC
//   19   | NC       | NC
//   18   | NC       | NC
//   17   | RUNLED   | Output
//   16   | RESET    | Output
//   15   | HALT     | Output
//   14   | A16      | NC
//   13   | A17      | Input

