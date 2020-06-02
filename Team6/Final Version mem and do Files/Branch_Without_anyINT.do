// try to work on the test case without INT
vsim -gui work.processor
add wave -position insertpoint sim:/processor/CLK
add wave -position insertpoint sim:/processor/RST
add wave -position insertpoint sim:/processor/INT

add wave -position insertpoint sim:/processor/DATA_fromIO
add wave -position insertpoint sim:/processor/DATA_toIO

add wave -position insertpoint sim:/processor/fetch/pc_selected
add wave -position insertpoint sim:/processor/fetch/pc_out_memory_in
add wave -position insertpoint sim:/processor/decode/RegisterFile/out_data

add wave -position insertpoint sim:/processor/Memory/SP_chosen
add wave -position insertpoint sim:/processor/carry_flag_final
add wave -position insertpoint sim:/processor/neg_flag_final
add wave -position insertpoint sim:/processor/zero_flag_final

mem load -i {E:/ThirdYear/2nd Term/Computer Architecture_Ahmed/5-Stage-Pipeline-Processor/Project-v4_survive/Branch.mem} /processor/fetch/INS_Memory/ram
force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000000 0
run
force -freeze sim:/processor/RST 0 0
run
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000110000 0
run
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000001010000 0
run
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000100000000 0
run
force -freeze sim:/processor/DATA_fromIO 00000000000000000000001100000000 0
run
force -freeze sim:/processor/DATA_fromIO 11111111111111111111111111111111 0
run
force -freeze sim:/processor/DATA_fromIO 11111111111111111111111111111111 0
run
run

run
run
run
run
run
run
force -freeze sim:/processor/DATA_fromIO 00000000000000000000001000000000 0
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