# ISA-MIPS-Coursework
2020-2021 Term 1 Instruction Set Architecture coursework: Verilog MIPS and test benches 

Currently our CPU is fixated on an issue wherein:

If for example the CPU is in state 3, the control signals will be accurate to that of state 2. This has been incredibly mystifying to us, given that when we run the same test case on a quartus version of our cpu it gives the correct outputs. As such this has limited the testing of the cpu. In theory (i.e. in quartus) addi lw sw and jr should all be functional.


As such the test bench currently tests far more signals than it should in theory in order to try to troubleshoot this timing / state / something issue.


Please feel absolutely free to email tl319@ic.ac.uk if you have questions, as I would love to answer these to ensure the most transparent and simple formative feedback as possible.
