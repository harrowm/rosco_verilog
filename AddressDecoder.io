CHIP "AddressDecoder"
BEGIN

    DEVICE = "PLCC44";
    "o_ODDROM_n"                              : OUTPUT_PIN = 12 ;
    "o_EVENROM_n"                             : OUTPUT_PIN = 11 ;
    "o_ODDRAM_n"                              : OUTPUT_PIN = 9 ;
    "o_EVENRAM_n"                             : OUTPUT_PIN = 8 ;
    "TDI"                                     : INPUT_PIN = 7 ;
    "id00013Q"                                : NODE_NUM = 609 ;
    "id00006Q"                                : NODE_NUM = 610 ;
    "o_IOSEL_n"                               : OUTPUT_PIN = 6 ;
    "o_DTACK_n_combENA"                       : NODE_NUM = 613 ;
    "o_EXPSEL_n"                              : OUTPUT_PIN = 5 ;
    "PPDTACK"                                 : OUTPUT_PIN = 4 ;
    "i_RW"                                    : INPUT_PIN = 21 ;
    "i_LDS_n"                                 : INPUT_PIN = 20 ;
    "i_UDS_n"                                 : INPUT_PIN = 19 ;
    "i_LGEXP_n"                               : INPUT_PIN = 18 ;
    "i_CPUSP_n"                               : INPUT_PIN = 17 ;
    "o_WR"                                    : OUTPUT_PIN = 16 ;
    "o_DTACK_n"                               : OUTPUT_PIN = 14 ;
    "TMS"                                     : INPUT_PIN = 13 ;
    "i_A_5"                                   : INPUT_PIN = 24 ;
    "i_A_4"                                   : INPUT_PIN = 25 ;
    "i_A_3"                                   : INPUT_PIN = 26 ;
    "i_A_2"                                   : INPUT_PIN = 27 ;
    "i_AS_n"                                  : INPUT_PIN = 28 ;
    "i_A_0"                                   : INPUT_PIN = 29 ;
    "i_A_1"                                   : INPUT_PIN = 31 ;
    "TCK"                                     : INPUT_PIN = 32 ;
    "i_BOOT"                                  : INPUT_PIN = 33 ;
    "TDO"                                     : INPUT_PIN = 38 ;
END;
