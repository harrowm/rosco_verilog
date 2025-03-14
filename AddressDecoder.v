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

	// ROM at 0xE00000 - (0x000000 on BOOT)
	// wire rom = !i_BOOT || i_A[23:20] == 4'hE;
	// assign o_ODDROM_n = !(i_CPUSP_n && !i_AS_n && !i_LDS_n && rom);
	// assign o_EVENROM_n = !(i_CPUSP_n && !i_AS_n && !i_UDS_n && rom);

	// RAM at 0x000000 (1 MB)
	// wire ram = i_BOOT && (i_A[23:20] == 4'h0);
	// assign o_ODDRAM_n = !(i_CPUSP_n && !i_AS_n && !i_LDS_n && ram);
	// assign o_EVENRAM_n = !(i_CPUSP_n && !i_AS_n && !i_UDS_n && ram);
	
	// In the latest PLD, BOOT is held high until a write is made to 0x400000
	// To use the above logic, need to have glue logic that changes BOOT after 4 AS cycles
	// Replicate the new logic first to make sure the verilog is ok

assign o_EVENRAM_n  = !( i_CPUSP_n && !i_AS_n && !i_UDS_n && (i_A[23:20] == 4'h0) &&                      i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_UDS_n && (i_A[23:20] == 4'h0) &&  i_A[19:19] &&              !i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_UDS_n && (i_A[23:20] == 4'h0) &&         i_A[18:18] &&       !i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_UDS_n && (i_A[23:20] == 4'h0) &&               !i_RW && !i_BOOT);

assign o_ODDRAM_n   =  !(i_CPUSP_n && !i_AS_n && !i_LDS_n * (i_A[23:20] == 4'h0) &&                      i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_LDS_n && (i_A[23:20] == 4'h0) &&  i_A[19:19] &&              !i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_LDS_n && (i_A[23:20] == 4'h0) &&         i_A[18:18] &&       !i_BOOT
          ||  i_CPUSP_n && !i_AS_n && !i_LDS_n && (i_A[23:20] == 4'h0) &&               !i_RW && !i_BOOT);


assign o_EVENROM_n  =  !(
	(i_CPUSP_n && !i_AS_n && !i_UDS_n &&  i_A[23:20] == 4'hE) ||  
	(i_CPUSP_n && !i_AS_n && !i_UDS_n && (i_A[23:18] == 6'h0) &&  i_RW && !i_BOOT));

assign o_ODDROM_n   =  !((i_CPUSP_n && !i_AS_n && !i_LDS_n &&  (i_A[23:20] == 4'hE))
          ||  (i_CPUSP_n && !i_AS_n && !i_LDS_n && (i_A[23:18] == 6'h0) &&  i_RW && !i_BOOT));



	// IO at 0xF00000 
	wire io = i_A[23:20] == 4'hF;
	assign o_IOSEL_n = !(i_CPUSP_n && io);

	// Expansion at 0x100000 - 0xD00000
	wire exp = (i_A[23:20] >= 4'h1) && (i_A[23:20] <= 4'hD);
	assign o_EXPSEL_n = !(i_CPUSP_n && !i_AS_n && exp);
	//assign o_EXPSEL_n = 1'b1;	

	assign o_WR = !i_RW;

	assign PPDTACK = !o_EVENROM_n || !o_ODDROM_n || !o_EVENRAM_n || !o_ODDRAM_n || (!i_LGEXP_n && !o_EXPSEL_n);
	assign o_DTACK_n = PPDTACK ? 1'b0 : 1'bZ;

	//assign o_DTACK_n = 1'b0;

endmodule

// Pin assignments for yosys flow
// Designed to be used with the little atf programmer for easy patching to test
//PIN: CHIP "AddressDecoder" ASSIGNED TO AN PLCC44

// 18=0 19=1 20=2 21=3 22=4 23=5
//PIN: i_A_0  : 41 
//PIN: i_A_1  : 39 
//PIN: i_A_2  : 37 
//PIN: i_A_3  : 34 
//PIN: i_A_4  : 12
// Cant fit on 32 clashes with TCK

//PIN: i_A_5  : 29
//PIN: i_UDS_n     : 27
//PIN: i_LDS_n     : 25
//PIN: i_BOOT      : 21
//PIN: i_LGEXP_n   : 19
//PIN: i_RW        : 17
//GND 14

//---
//VCC 40
//PIN: o_WR           4 // wont fit on 1504 44 pin at pin 8 .. default to pin 4
// Cant fit on 38 clashes with TDO

//PIN: o_DTACK_n   : 36
//PIN: PPDTACK     : 33
//PIN: i_CPUSP_n   : 31
//PIN: o_EXPSEL_n  : 28
//PIN: o_IOSEL_n   : 26
//PIN: o_ODDROM_n  : 24
//PIN: o_EVENROM_n : 20
//PIN: o_ODDRAM_n  : 18 
//PIN: o_EVENRAM_n : 16
//PIN: i_AS_n      : 11
// Cant fit on 13 clashes with TMS

// Pin assignments from the 22v10 design
//    1   | A18       | Clock/Input
//    2   | A19       | Input
//    3   | A20       | Input
//    4   | A21       | Input
//    5   | A22       | Input
//    6   | A23       | Input
//    7   | UDS       | Input
//    8   | LDS       | Input
//    9   | BOOT      | Input
//   10   | LGEXP     | Input
//   11   | RW        | Input
//   12   | GND       | GND

//   24   | VCC       | VCC
//   23   | WR        | Output
//   22   | DTACK     | Output
//   21   | PPDTACK   | Output
//   20   | CPUSP     | Input
//   19   | EXPSEL    | Output
//   18   | IOSEL     | Output
//   17   | ODDROM    | Output
//   16   | EVENROM   | Output
//   15   | ODDRAM    | Output
//   14   | EVENRAM   | Output
//   13   | AS        | Input

