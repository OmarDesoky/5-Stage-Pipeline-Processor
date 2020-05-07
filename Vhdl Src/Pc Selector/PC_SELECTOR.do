vsim -gui work.pc_selector
add wave -position insertpoint sim:/pc_selector/*
force -freeze sim:/pc_selector/mem_loc_2_3 01010101111001101101011100001111 0
force -freeze sim:/pc_selector/pc_frm_wb 11001001111011110101001010011001 0
force -freeze sim:/pc_selector/calc_jmp_addr 11000111110100110100011110111110 0
force -freeze sim:/pc_selector/pc_updated 01101000000111100000111110100000 0



force -freeze sim:/pc_selector/rst_async 1 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=00000000000000000000000000000000} {
    echo "Test 1 Failed!";
}




force -freeze sim:/pc_selector/int 1 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=00000000000000000000000000000000} {
    echo "Test 2 Failed!";
}


force -freeze sim:/pc_selector/pc_wb 1 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=00000000000000000000000000000000} {
    echo "Test 3 Failed!";
}



force -freeze sim:/pc_selector/take_jmp_addr 1 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=00000000000000000000000000000000} {
    echo "Test 4 Failed!";
}



force -freeze sim:/pc_selector/rst_async 0 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=01010101111001101101011100001111} {
    echo "Test 5 Failed!";
}



force -freeze sim:/pc_selector/int 0 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=11001001111011110101001010011001} {
    echo "Test 6 Failed!";
}



force -freeze sim:/pc_selector/pc_wb 0 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=11000111110100110100011110111110} {
    echo "Test 7 Failed!";
}



force -freeze sim:/pc_selector/take_jmp_addr 0 0
run
set valuetest [examine -binary pc_out];
if {$valuetest!=01101000000111100000111110100001} {
    echo "Test 8 Failed!";
}