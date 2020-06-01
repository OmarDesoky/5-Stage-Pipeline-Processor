vsim -gui work.processor
add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/processor/prediction_stage/mini_decode/*
add wave -position insertpoint sim:/processor/prediction_stage/hazard_detect/*
add wave -position insertpoint sim:/processor/prediction_stage/FWD_unit/*
add wave -position insertpoint sim:/processor/prediction_stage/forwarded_chooser/*
add wave -position insertpoint sim:/processor/prediction_stage/FSM/*
add wave -position insertpoint sim:/processor/fetch/*
mem load -i {E:/ThirdYear/2nd Term/Computer Architecture_Ahmed/5-Stage-Pipeline-Processor/Project-v5/test.mem} /processor/fetch/INS_Memory/ram
force -freeze sim:/processor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/RST 1 0
force -freeze sim:/processor/INT 0 0
force -freeze sim:/processor/DATA_fromIO 00000000000000000000000000000000 0
run
force -freeze sim:/processor/RST 0 0
run