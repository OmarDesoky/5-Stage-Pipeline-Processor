vsim -gui work.fsm_2_bits
add wave -position insertpoint sim:/fsm_2_bits/*
force -freeze sim:/fsm_2_bits/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/fsm_2_bits/input 1 0
force -freeze sim:/fsm_2_bits/current_state 0 0
force -freeze sim:/fsm_2_bits/enb 0 0
run