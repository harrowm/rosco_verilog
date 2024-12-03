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
	
	assign o_HALT_n = i_HWRST ? 1'b0 : 1'bZ;
	assign o_RESET_n = i_HWRST ? 1'b0 : 1'bZ;
	assign o_RUNLED =  i_HWRST ? 1'b0 : 1'b1; // !i_HWRST didnt seem to work becuase of the possible Z value ?

	assign o_CPUSP_n = !(!i_HWRST && (i_FC[2:0] == 3'b111));
	assign o_DUIACK_n = !(!o_CPUSP_n && !i_AS_n && (i_A[19] == 1) && (i_A_LOW[3:1] == 3'b100));

	// The GALasm uses A19/A18 to spot whne the first 4 reads have completed
	// Here we will count AS (memory access) cycles to set BOOT for the first 4 memory reads

    reg [2:0] counter = 3'b0;

    always @(posedge i_AS_n) begin
	    if (!o_RESET_n && !o_HALT_n) begin 
		    counter <= 0;
		    o_BOOT <= 1'b0;
	    end	else begin
		    if (!o_BOOT) begin
			    counter <= counter + 3'b001;
			    if (counter == 3'b100) 
                    o_BOOT <= 1'b1;
		    end
	    end
    end
endmodule

// Pin assignments for yosys flow
//PIN: CHIP "Glue" ASSIGNED TO AN PLCC44
//PIN: i_A        : 12
//PIN: o_RESET_n  : 11
//PIN: o_BOOT     : 9
//PIN: o_HALT_n   : 8
//PIN: o_RUNLED   : 6
//PIN: o_CPUSP_n  : 5
//PIN: o_DUIACK_n : 4
//PIN: i_A_LOW_2  : 21
//PIN: i_A_LOW_1  : 20
//PIN: i_A_LOW_0  : 19
//PIN: i_FC_2     : 18
//PIN: i_FC_1     : 17
//PIN: i_FC_0     : 16
//PIN: i_AS_n     : 43
//PIN: i_HWRST    : 44
