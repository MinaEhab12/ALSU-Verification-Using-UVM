vlib work
vlog -f alsu.list.txt +cover -covercells 
vsim -voptargs=+acc work.top -cover 
add wave /top/alsu_Vif/*
coverage save top.ucdb -onexit
run -all