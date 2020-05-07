vsim -gui work.data_hazard_detection_unit_tb
add wave -position insertpoint  \
sim:/data_hazard_detection_unit_tb/STALL_FOR_JUMP_PREDECTION_TEST \
sim:/data_hazard_detection_unit_tb/STALL_FOR_INT_TEST \
sim:/data_hazard_detection_unit_tb/SRC2_TEST \
sim:/data_hazard_detection_unit_tb/SRC1_TEST \
sim:/data_hazard_detection_unit_tb/PC_ENB_TEST \
sim:/data_hazard_detection_unit_tb/MEM_READ_ID_EX_TEST \
sim:/data_hazard_detection_unit_tb/INSERT_BUBBLE_TEST \
sim:/data_hazard_detection_unit_tb/IF_ID_ENB_TEST \
sim:/data_hazard_detection_unit_tb/DST_TEST
run 1 ns