vsim -gui work.processor
add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/processor/IF_ID/*
add wave -position insertpoint sim:/processor/decode/Buffer_ID_EX/*
add wave -position insertpoint sim:/processor/EX_MEM_Buffer/*
add wave -position insertpoint sim:/processor/MEM_WB_Buffer/*
add wave -position insertpoint sim:/processor/decode/RegisterFile/*
add wave -position insertpoint sim:/processor/decode/Control/*
add wave -position insertpoint sim:/processor/Memory/INT_Controller/*
add wave -position insertpoint sim:/processor/fetch/*
mem load -i {E:/ThirdYear/2nd Term/Computer Architecture_Ahmed/Project/test.mem} /processor/fetch/INS_Memory/ram
force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000000 0
run
force -freeze sim:/processor/RST 0 0
run
run
run
run
run

