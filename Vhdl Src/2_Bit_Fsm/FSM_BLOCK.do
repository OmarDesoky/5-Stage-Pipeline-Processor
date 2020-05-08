vsim -gui work.fsm_block
add wave -position insertpoint sim:/fsm_block/*
force -freeze sim:/fsm_block/clk 0 0, 1 {50 ps} -r 100

force -freeze sim:/fsm_block/addr_fetched 00000000000000000000000000000000 0
run

force -freeze sim:/fsm_block/addr_fetched 00000000000000000000000000000100 0
run

force -freeze sim:/fsm_block/addr_fetched 00000000000000000000000000001100 0
run

force -freeze sim:/fsm_block/addr_fetched 00000000000000000000000000001101 0
force -freeze sim:/fsm_block/decision_alwaystaken 1 0
run


force -freeze sim:/fsm_block/decision_alwaystaken 0 0
force -freeze sim:/fsm_block/ifjz_updt_fsm 1 0
force -freeze sim:/fsm_block/addr_executed 00000000000000000000000000000000 0
run


force -freeze sim:/fsm_block/prediction_correct 1 0
run
run
run
