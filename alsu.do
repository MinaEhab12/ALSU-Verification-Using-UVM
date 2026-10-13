vlib work

vlog -sv -f alsu.list.txt +cover -covercells

vsim -voptargs=+acc work.top -cover

add wave -r /top/*

coverage save top.ucdb -onexit

run -all