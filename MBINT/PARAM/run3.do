vlib work
vlog *.*v

vsim -voptargs=+acc work.TWO_PARAM_WRAPPERS_SIMPLE_tb
do wave3.do
run -all