vsim -gui work.processor
mem load -i {C:/Users/user/Desktop/5-Stage-Pipeline-Processor/Project-v1/ram.mem} /processor/fetch/INS_Memory/ram

add wave -position insertpoint sim:/processor/CLK
add wave -position insertpoint sim:/processor/RST
add wave -position insertpoint sim:/processor/INT

add wave -position insertpoint sim:/processor/DATA_fromIO
add wave -position insertpoint sim:/processor/DATA_toIO

add wave -position insertpoint sim:/processor/fetch/pc_selected
add wave -position insertpoint sim:/processor/decode/RegisterFile/out_data

add wave -position insertpoint sim:/processor/Memory/SP_current
add wave -position insertpoint sim:/processor/decode/RegisterFile/carry
add wave -position insertpoint sim:/processor/decode/RegisterFile/zero
add wave -position insertpoint sim:/processor/decode/RegisterFile/neg

force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000000 0
run

//fetch
force -freeze sim:/processor/RST 0 0
run

// 1st decode
force -freeze sim:/processor/DATA_fromIO 16#0CDAFE19 0
run                                         

// 2nd decode
force -freeze sim:/processor/DATA_fromIO 16#0000FFFF 0
run

// 3rd decode
force -freeze sim:/processor/DATA_fromIO 16#0000F320 0
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