vlib work

vlog interface.v +acc
vlog tb2.v +acc

vsim work.tb
add wave sim:/tb/*
run -all