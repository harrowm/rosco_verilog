// Test bench for AddressDecoder with assertions

module test_AddressDecoder_tb;

    // Inputs
    reg [23:18] i_A;
    reg i_UDS_n;
    reg i_LDS_n;
    reg i_BOOT;
    reg i_CPUSP_n;
    reg i_AS_n;
    reg i_RW;
    reg i_LGEXP_n;

    // Outputs
    wire PPDTACK;
    wire o_DTACK_n;
    wire o_WR;
    wire o_EVENRAM_n;
    wire o_ODDRAM_n;
    wire o_EVENROM_n;
    wire o_ODDROM_n;
    wire o_IOSEL_n;
    wire o_EXPSEL_n;

    // Instantiate the Unit Under Test (UUT)
    AddressDecoder uut (
        .i_A(i_A),
        .i_UDS_n(i_UDS_n),
        .i_LDS_n(i_LDS_n),
        .i_BOOT(i_BOOT),
        .i_CPUSP_n(i_CPUSP_n),
        .i_AS_n(i_AS_n),
        .i_RW(i_RW),
        .i_LGEXP_n(i_LGEXP_n),
        .PPDTACK(PPDTACK),
        .o_DTACK_n(o_DTACK_n),
        .o_WR(o_WR),
        .o_EVENRAM_n(o_EVENRAM_n),
        .o_ODDRAM_n(o_ODDRAM_n),
        .o_EVENROM_n(o_EVENROM_n),
        .o_ODDROM_n(o_ODDROM_n),
        .o_IOSEL_n(o_IOSEL_n),
        .o_EXPSEL_n(o_EXPSEL_n)
    );

    initial begin
        // Initialize Inputs
        i_A = 6'b000000;
        i_UDS_n = 1;
        i_LDS_n = 1;
        i_BOOT = 0;
        i_CPUSP_n = 1;
        i_AS_n = 1;
        i_RW = 1;
        i_LGEXP_n = 1;

        // Wait for global reset
        #100;

        // Test case 1: ROM access
        i_A = 6'b111000;
        i_AS_n = 0;
        i_UDS_n = 0;
        i_LDS_n = 0;
        #10;
        assert(o_EVENROM_n == 0) else $fatal("Test case 1 failed: o_EVENROM_n");
        assert(o_ODDROM_n == 0) else $fatal("Test case 1 failed: o_ODDROM_n");
        i_AS_n = 1;
        i_UDS_n = 1;
        i_LDS_n = 1;

        // Test case 2: RAM access
        i_BOOT = 1;
        i_A = 6'b000000;
        i_AS_n = 0;
        i_UDS_n = 0;
        i_LDS_n = 0;
        #10;
        assert(o_EVENRAM_n == 0) else $fatal("Test case 2 failed: o_EVENRAM_n");
        assert(o_ODDRAM_n == 0) else $fatal("Test case 2 failed: o_ODDRAM_n");
        i_AS_n = 1;
        i_UDS_n = 1;
        i_LDS_n = 1;

        // Test case 3: IO access
        i_A = 6'b111100;
        i_AS_n = 0;
        #10;
        assert(o_IOSEL_n == 0) else $fatal("Test case 3 failed: o_IOSEL_n");
        i_AS_n = 1;

        // Test case 4: Expansion access
        i_A = 6'b000001;
        i_AS_n = 0;
        #10;
        assert(o_EXPSEL_n == 1) else $fatal("Test case 4 failed: o_EXPSEL_n");
        i_AS_n = 1;

        // Add more test cases as needed

        // Finish simulation
        #100;
        $finish;
    end

endmodule