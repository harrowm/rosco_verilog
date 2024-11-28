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
	assign o_RUNLED = o_HALT_n;

	assign o_CPUSP_n = ~i_HWRST && (i_FC[2:0] == 3'b111);
	assign o_DUIACK_n = ~(~i_HWRST && (i_FC[2:0] == 3'b111) && ~i_AS_n && (i_A[19] == 1) && (i_A_LOW[3:1] == 3'b100));

    // the GALasm for setting the boot signal in the original code is using a trick that 
    // I don't understand! I will just use a counter to set the boot signal after 4 cycles of AS
    // which is the more typical approach (I think)

    reg [2:0] counter = 3'b0;

    always @(posedge i_AS_n) begin
	    if (~o_RESET_n && ~o_HALT_n) begin 
		    counter <= 0;
		    o_BOOT <= 1'b0;
	    end	else begin
		    if (~o_BOOT) begin
			    counter <= counter + 3'b001;
			    if (counter == 3'b100) 
                    o_BOOT <= 1'b1;
		    end
	    end
    end
endmodule
