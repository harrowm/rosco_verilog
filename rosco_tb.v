// Testbench for rosco.v module
// Malcolm Harrow
// November 2024
// MIT License

module rosco_tb;

    // Signals for Glue
    reg [23:18] i_A;
    reg [3:1] i_A_LOW;
    reg [2:0] i_FC;
    reg i_HWRST;
    reg i_AS_n;
    wire o_HALT_n;
    wire o_RESET_n;
    wire o_RUNLED;
    wire o_BOOT;
    wire o_CPUSP_n;
    wire o_DUIACK_n;
    
    // Additional signals for AddressDecoder
    reg io_UDS_n;
    reg io_LDS_n;
    reg i_RW;
    reg i_LGEXP_n;
    wire o_DTACK_n;
    wire o_WR;
    wire o_EVENRAM_n;
    wire o_ODDRAM_n;
    wire o_EVENROM_n;
    wire o_ODDROM_n;
    wire o_IOSEL_n;
    wire o_EXPSEL_n;

    // From circuit diagram, these have pull up resistors
    pullup (o_HALT_n);
    pullup (o_RESET_n);

    // Instantiate the Unit Under Test (UUT) for Glue
    Glue glue_uut (
        .i_A(i_A[19:19]), 
        .i_A_LOW(i_A_LOW), 
        .i_FC(i_FC), 
        .i_HWRST(i_HWRST), 
        .i_AS_n(i_AS_n), 
        .o_HALT_n(o_HALT_n), 
        .o_RESET_n(o_RESET_n), 
        .o_RUNLED(o_RUNLED), 
        .o_BOOT(o_BOOT), 
        .o_CPUSP_n(o_CPUSP_n), 
        .o_DUIACK_n(o_DUIACK_n)
    );

    // Instantiate the Unit Under Test (UUT) for AddressDecoder
    AddressDecoder address_decoder_uut (
        .i_A(i_A[23:18]),
        .i_UDS_n(io_UDS_n),
        .i_LDS_n(io_LDS_n),
        .i_BOOT(o_BOOT),
        .i_CPUSP_n(o_CPUSP_n),
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

//  always 
//      #5 clk = ~clk;
//  initial 
//      clk = 0;

    initial begin
        // Start with a reset
        i_A = 0;
        i_A_LOW = 0;
        i_FC = 0;
        i_HWRST = 1;
        i_AS_n = 1;

        // Wait for global reset
        #100;
        
        // End reset
        i_HWRST = 0;
        i_AS_n = 0;
        #10;
        
        i_AS_n = 1; //2
        #10;
        
        i_AS_n = 0;
        #10;
        
        i_AS_n = 1; //3
        #10;
        
        i_AS_n = 0;
        #10;
        
        i_AS_n = 1; //4
        #10;
        
        i_AS_n = 0;
        #10;

        i_AS_n = 1; //5
        #10;

        i_AS_n = 0;
        #10;

        // Now try a read from odd RAM
        i_A = 6'b000010; // A[24..18]
	    io_UDS_n = 1;
	    io_LDS_n = 0;
	    i_RW = 1;
	    i_LGEXP_n = 1;
        i_AS_n = 1;
        //#10;
        if(!(o_WR == 0)) $finish;
        if(!(o_ODDRAM_n == 1)) $finish;
        if(!(o_ODDROM_n == 0)) $finish;
        if(!(o_EVENRAM_n == 0)) $finish;
        if(!(o_EVENROM_n == 0)) $finish;
        i_AS_n = 0;
        #10;
        
        // Now try a write to even RAM
        i_A = 6'b000010; // A[24..18]
	    io_UDS_n = 0;
	    io_LDS_n = 1;
	    i_RW = 0;
	    i_LGEXP_n = 1;
        i_AS_n = 1;
        #10;
        if(!(o_WR == 1)) $finish;
        // if(!(o_ODDRAM_n == 0)) $finish;
        // if(!(o_ODDROM_n == 0)) $finish;
        // if(!(o_EVENRAM_n == 1)) $finish;
        // if(!(o_EVENROM_n == 0)) $finish;

        i_AS_n = 0;
        #10;
        
        // Add more test cases as needed
    end
      
    initial begin
        $monitor("Time: %0t | o_HALT_n: %b | o_RESET_n: %b | o_RUNLED: %b | o_BOOT: %b | o_CPUSP_n: %b | o_DUIACK_n: %b | | o_DTACK_n: %b | o_WR: %b | o_EVENRAM_n: %b | o_ODDRAM_n: %b | o_EVENROM_n: %b | o_ODDROM_n: %b | o_IOSEL_n: %b | o_EXPSEL_n: %b", 
             $time, o_HALT_n, o_RESET_n, o_RUNLED, o_BOOT, o_CPUSP_n, o_DUIACK_n, o_DTACK_n, o_WR, o_EVENRAM_n, o_ODDRAM_n, o_EVENROM_n, o_ODDROM_n, o_IOSEL_n, o_EXPSEL_n);
    end
endmodule