vsim -gui work.testbench
add wave -position insertpoint  \
sim:/testbench/WB_MEM_WB_test \
sim:/testbench/WB_EX_MEM_test \
sim:/testbench/SWAP_SIGNAL_MEM_WB_test \
sim:/testbench/SWAP_SIGNAL_EX_MEM_test \
sim:/testbench/SRC2_test \
sim:/testbench/SRC1_test \
sim:/testbench/ENABLE_2ND_MUX_test \
sim:/testbench/ENABLE_1ST_MUX_test \
sim:/testbench/DST_MEM_WB_test \
sim:/testbench/DST_EX_MEM_test \
sim:/testbench/DST2_MEM_WB_test \
sim:/testbench/DST2_EX_MEM_test
run 5 ns