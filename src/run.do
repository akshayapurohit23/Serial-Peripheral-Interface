vlib work

vlog clock_generator.v +acc
vlog master_module.v +acc
vlog slave_module.v +acc
vlog interface.v +acc
vlog testbench.v +acc

vsim work.tb
add wave sim:/tb/*
run -all
