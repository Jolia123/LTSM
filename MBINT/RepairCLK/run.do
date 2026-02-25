vlib work
vlog *.*v

vsim -voptargs=+acc work.TWO_WRAPPERS_tb_CLK
do wave1.do
run -all