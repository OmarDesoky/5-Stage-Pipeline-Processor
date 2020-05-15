vsim -gui work.decode_stage
add wave -position insertpoint  \
sim:/decode_stage/clk \
sim:/decode_stage/rst_async \
sim:/decode_stage/swap_wb \
sim:/decode_stage/write_enb_wb \
sim:/decode_stage/flag_enb_wb \
sim:/decode_stage/int \
sim:/decode_stage/stall_next \
sim:/decode_stage/last_taken \
sim:/decode_stage/instruction \
sim:/decode_stage/dest_mem_wb \
sim:/decode_stage/data_out_wb \
sim:/decode_stage/data_swp_wb \
sim:/decode_stage/reg_swap_mem_wb \
sim:/decode_stage/pc_in \
sim:/decode_stage/zero_flg \
sim:/decode_stage/carry_flg \
sim:/decode_stage/neg_flg \
sim:/decode_stage/insert_bubble \
sim:/decode_stage/io_data \
sim:/decode_stage/dst_out \
sim:/decode_stage/src1_out \
sim:/decode_stage/src2_out \
sim:/decode_stage/pc_out \
sim:/decode_stage/em_imm_out \
sim:/decode_stage/data1_out \
sim:/decode_stage/data2_out \
sim:/decode_stage/execute \
sim:/decode_stage/wb_out \
sim:/decode_stage/mem_out \
sim:/decode_stage/alu_op \
sim:/decode_stage/imm_reg_enb_out \
sim:/decode_stage/reg_enb_out \
sim:/decode_stage/stall_for_int \
sim:/decode_stage/stall_for_jmp_pred \
sim:/decode_stage/ifjmp_upd_fsm \
sim:/decode_stage/zero_flag_compara \
sim:/decode_stage/last_taken_compara \
sim:/decode_stage/inmiddleofimm \
sim:/decode_stage/ifanyjmp \
sim:/decode_stage/flags_out \
sim:/decode_stage/read_data_1 \
sim:/decode_stage/write_enable_sig \
sim:/decode_stage/pc_wb_sig \
sim:/decode_stage/mem_or_reg_sig \
sim:/decode_stage/swap_sig \
sim:/decode_stage/flag_register_wb_sig \
sim:/decode_stage/mem_write_sig \
sim:/decode_stage/mem_read_sig \
sim:/decode_stage/int_rti_dntuse_sig \
sim:/decode_stage/sp_enb_sig \
sim:/decode_stage/alu_op_sig \
sim:/decode_stage/alu_source_sig \
sim:/decode_stage/io_enable_sig \
sim:/decode_stage/imm_ea_sig \
sim:/decode_stage/reg_eng_1st_4 \
sim:/decode_stage/sign_extend1 \
sim:/decode_stage/sign_extend2 \
sim:/decode_stage/out_first4


force -freeze sim:/decode_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decode_stage/rst_async 1 0
force -freeze sim:/decode_stage/swap_wb 0 0
force -freeze sim:/decode_stage/write_enb_wb 0 0
force -freeze sim:/decode_stage/flag_enb_wb 0 0
force -freeze sim:/decode_stage/int 0 0
force -freeze sim:/decode_stage/stall_next 0 0
force -freeze sim:/decode_stage/last_taken 0 0
force -freeze sim:/decode_stage/instruction 0111100000000000 0
force -freeze sim:/decode_stage/dest_mem_wb 000 0
force -freeze sim:/decode_stage/data_out_wb 00000000000000000000000000000000 0
force -freeze sim:/decode_stage/data_swp_wb 00000000000000000000000000000000 0
force -freeze sim:/decode_stage/reg_swap_mem_wb 000 0
force -freeze sim:/decode_stage/pc_in 00000000000000000000000000000000 0
force -freeze sim:/decode_stage/zero_flg 0 0
force -freeze sim:/decode_stage/carry_flg 0 0
force -freeze sim:/decode_stage/neg_flg 0 0
force -freeze sim:/decode_stage/insert_bubble 0 0
force -freeze sim:/decode_stage/io_data 00000000000000000000000000000000 0

// close reset
force -freeze sim:/decode_stage/rst_async 0 0
// add
force -freeze sim:/decode_stage/instruction 0010000110101000 0
// in_op
force -freeze sim:/decode_stage/instruction 01100 00100000000 0
force -freeze sim:/decode_stage/io_data 00000000000000000000000000000001 0
// inc_op
force -freeze sim:/decode_stage/instruction 0100101001000000 0
force -freeze sim:/decode_stage/write_enb_wb 1 0
force -freeze sim:/decode_stage/dest_mem_wb 110 0
force -freeze sim:/decode_stage/data_out_wb 00000000000000000000000000001111 0
//std_op
    force -freeze sim:/decode_stage/write_enb_wb 0 0
force -freeze sim:/decode_stage/instruction 1010000000100011 0

force -freeze sim:/decode_stage/instruction 1111111111111111 0

//jz_op
force -freeze sim:/decode_stage/instruction 1100000000100000 0
//swap_op
force -freeze sim:/decode_stage/instruction 0001101000101000 0
// Iadd_op
force -freeze sim:/decode_stage/instruction 0001010111000000 0
run
force -freeze sim:/decode_stage/instruction 0000000000000100 0
// pop_op
force -freeze sim:/decode_stage/instruction 1000100000000000 0
