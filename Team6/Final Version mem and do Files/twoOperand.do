vsim -gui work.processor
mem load -i {E:\ThirdYear\2nd Term\Computer Architecture_Ahmed\5-Stage-Pipeline-Processor\Project-v2(+ Forwarding)\Documents\2-operand\WITH_forw_no_haza\twoOperand.mem} /processor/fetch/INS_Memory/ram

add wave -position insertpoint sim:/processor/CLK
add wave -position insertpoint sim:/processor/RST
add wave -position insertpoint sim:/processor/INT

add wave -position insertpoint sim:/processor/DATA_fromIO
add wave -position insertpoint sim:/processor/DATA_toIO

add wave -position insertpoint sim:/processor/fetch/pc_selected
add wave -position insertpoint sim:/processor/decode/RegisterFile/out_data

add wave -position insertpoint sim:/processor/Memory/SP_chosen
add wave -position insertpoint sim:/processor/carry_flag_final
add wave -position insertpoint sim:/processor/neg_flag_final
add wave -position insertpoint sim:/processor/zero_flag_final

force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000000 0
run

//fetch
force -freeze sim:/processor/RST 0 0
run

// 1st decode
force -freeze sim:/processor/DATA_fromIO 16#00000005 0
run

// 2nd decode
force -freeze sim:/processor/DATA_fromIO 16#00000019 0
run

// 3rd decode
force -freeze sim:/processor/DATA_fromIO 16#0000fffd 0
run

// 4th decode
force -freeze sim:/processor/DATA_fromIO 16#0000f320 0
run

run
run
run
run
run
run
run
run
run
run
run
run
run
run
run