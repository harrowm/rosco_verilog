// CPUGlue
// Malcolm harrow, November 2024
// MIT License

`default_nettype none

module CPUglue(
	input i_CLK,
	input i_A0,
	input i_DS_n,
	input [1:0] i_SIZ,
	input i_RESET_n,
	
	output o_UDS_n,
	output o_LDS_n, 
	output o_E
	);
	
	reg [3:0] counter;

	assign o_UDS_n = !(!i_DS_n && !i_A0);
	assign o_LDS_n = !((!i_DS_n && !i_A0) || (!i_DS_n && !i_SIZ[0:0]) || (!i_DS_n && i_SIZ[1:1]));

	// set o_E
	// according the datasheet, a single period of clock E 
	// consists of 10 MC68000 clock periods (six clocks low, 4 clocks high)
	//
	// I dont understnad that 6/4 ?? .. will just count 10 cycles ..

	reg trigger = 1'b0;

	always @(posedge i_CLK) begin
		if (!i_RESET_n) begin
			counter <= 4'b0;
			trigger <= 1'b0;
		end else if (counter == 10) begin
			counter <= 4'b0;
			trigger <= 1'b1;
		end else begin 
			counter <= counter + 1;
			trigger <= 1'b0;
		end 
	end

	assign o_E = trigger;

endmodule
