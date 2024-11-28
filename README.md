# Rosco Verilog Project

This project uses Icarus Verilog for simulation and synthesis of a Verilog definition of the rosco_m68k GALasm files.

Ultimately the idea is to run all the logic from a ATF1508 or similar.  But really the main purpose is to learn Verilog!

To install icarus:
```
brew install icarus-verilog
```

To compile and run the code:
```
iverilog -o rosco rosco_tb.v AddressDecoder.v Glue.v
vvp rosco
```

This oce is wip .. at time of writing it doesn't do much !

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
