vsim -gui work.pc_save_determine_tb
add wave -position insertpoint  \
sim:/pc_save_determine_tb/UPDATED_PC_test \
sim:/pc_save_determine_tb/PC_OUT_test \
sim:/pc_save_determine_tb/IN_MIDDLE_OF_IMM_test \
sim:/pc_save_determine_tb/IF_ANY_JUMP_test \
sim:/pc_save_determine_tb/CURRENT_PC_test \
sim:/pc_save_determine_tb/clk_test
run 1 ns