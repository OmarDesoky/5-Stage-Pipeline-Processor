vsim -gui work.processor
add wave -position insertpoint  \
sim:/processor/CLK \
sim:/processor/RST \
sim:/processor/INT \
sim:/processor/DATA_fromIO \
sim:/processor/DATA_toIO \
sim:/processor/IO_enb \
sim:/processor/last_taken_TO_decode \
sim:/processor/next_stall_TO_decode \
sim:/processor/int_TO_decode \
sim:/processor/instruction_TO_decode \
sim:/processor/pc_TO_decode \
sim:/processor/IF_ANY_JUMP_FROM_decode \
sim:/processor/Flush_FROM_decode \
sim:/processor/IN_MIDDLE_OF_IMM_FROM_decode \
sim:/processor/ifJZ_FROM_decode \
sim:/processor/zero_flag_FROM_decode \
sim:/processor/last_taken_FROM_decode \
sim:/processor/wb_out_TO_execute \
sim:/processor/mem_out_TO_execute \
sim:/processor/alu_op_out_TO_execute \
sim:/processor/ex_out_TO_execute \
sim:/processor/data_1_out_TO_execute \
sim:/processor/data_2_out_TO_execute \
sim:/processor/src_1_out_TO_execute \
sim:/processor/src_2_out_TO_execute \
sim:/processor/ea_imm_out_TO_execute \
sim:/processor/pc_out_TO_execute \
sim:/processor/dst_out_TO_execute \
sim:/processor/ENB_Buffer_EX_MEM \
sim:/processor/wb_out_FROM_execute \
sim:/processor/mem_out_FROM_execute \
sim:/processor/alu_out1_FROM_execute \
sim:/processor/alu_out2_FROM_execute \
sim:/processor/EA_IMM_out_FROM_execute \
sim:/processor/pc_out_FROM_execute \
sim:/processor/src1_out_FROM_execute \
sim:/processor/DST_out_FROM_execute \
sim:/processor/take_jmp_addr_FROM_prediction \
sim:/processor/last_taken_FROM_prediction \
sim:/processor/next_stall_FROM_prediction \
sim:/processor/PC_FROM_prediction \
sim:/processor/pc_wb_FROM_WB \
sim:/processor/swap_wb_FROM_WB \
sim:/processor/reg_wb_FROM_WB \
sim:/processor/flag_wb_FROM_WB \
sim:/processor/wb_sigs_FROM_WB \
sim:/processor/DATA_FROM_WB \
sim:/processor/ALUout1_FROM_WB \
sim:/processor/ALUout2_FROM_WB \
sim:/processor/Mem_out_FROM_WB \
sim:/processor/dst_FROM_WB \
sim:/processor/SRC1_FROM_WB \
sim:/processor/ALUout1_FROM_Memory \
sim:/processor/ALUout2_FROM_Memory \
sim:/processor/Memout_FROM_Memory \
sim:/processor/wb_out_FROM_Memory \
sim:/processor/mem_out_FROM_Memory \
sim:/processor/wb_out_TO_Memory \
sim:/processor/mem_out_TO_Memory \
sim:/processor/alu_out1_TO_Memory \
sim:/processor/alu_out2_TO_Memory \
sim:/processor/EA_IMM_out_TO_Memory \
sim:/processor/pc_out_TO_Memory \
sim:/processor/src1_out_TO_Memory \
sim:/processor/DST_out_TO_Memory \
sim:/processor/instruction_fetched \
sim:/processor/PC_FROM_fetch \
sim:/processor/INT_FROM_fetch \
sim:/processor/zero_FROM_ALU \
sim:/processor/neg_FROM_ALU \
sim:/processor/carry_FROM_ALU \
sim:/processor/PC_ENB_FROM_DATAHAZARD \
sim:/processor/insert_bubble_FROM_DATAHAZARD \
sim:/processor/stall_for_INT_FROM_DATAHAZARD \
sim:/processor/stall_for_jump_prediction_FROM_DATAHAZARD \
sim:/processor/IF_ID_ENB \
sim:/processor/enb_1st_mux_FROM_FW_UNIT \
sim:/processor/enb_2nd_mux_FROM_FW_UNIT
add wave -position insertpoint sim:/processor/IF_ID/*
add wave -position insertpoint sim:/processor/decode/Buffer_ID_EX/*
add wave -position insertpoint sim:/processor/EX_MEM_Buffer/*
add wave -position insertpoint sim:/processor/MEM_WB_Buffer/*
add wave -position insertpoint sim:/processor/decode/RegisterFile/*
add wave -position insertpoint sim:/processor/decode/Control/*
add wave -position insertpoint sim:/processor/Memory/INT_Controller/*
add wave -position insertpoint sim:/processor/fetch/*
mem load -i {C:/Users/DELL/Desktop/Arch/project/Local_version/5-Stage-Pipeline-Processor/Vhdl Src/Project-v1/test.mem} /processor/Memory/DATA_Memory/ram
force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000101 0
run
force -freeze sim:/processor/RST 0 0
run
run
run
run
run

