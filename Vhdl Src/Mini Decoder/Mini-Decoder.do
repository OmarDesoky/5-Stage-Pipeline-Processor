vsim -gui work.mini_decode
add wave -position insertpoint sim:/mini_decode/*
force -freeze sim:/mini_decode/clk 0 1, 1 {50 ps} -r 100
force -freeze sim:/mini_decode/reset 1 0
run

force -freeze sim:/mini_decode/inst 0001100011100000 0
run
force -freeze sim:/mini_decode/reset 0 0
run
force -freeze sim:/mini_decode/inst 0001100011100000 0
run
force -freeze sim:/mini_decode/inst 0001000011100000 0
run