// Watchdog
// Malcolm harrow, November 2024
// MIT License

`default_nettype none

module Watchdog(
	input i_CLK,
	input i_A19,
	input i_CPUSP,
	input i_AS_n,
	
	output pberr,  // has to be an output for the tri-state logic to work
	output o_BERR_n
	);
	
	// watchdog timer
	// I think the original code is counting to 128 .. about 10ms on a 12MHz 68010
	
	reg pberr = 1'b0;
	reg [6:0] counter;
	wire wden = !i_AS_n || (!i_CPUSP && i_A19);

	always @(posedge i_CLK) begin
		if (!wden) begin
			counter <= 7'b0;
		end else if (counter == 7'b1111111) begin
			pberr <= 1'b1;
		end else begin 
			counter <= counter + 1;
		end 
	end

	assign o_BERR_n = pberr ? 1'b0 : 1'bZ;
endmodule
