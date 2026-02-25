onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TWO_PARAM_WRAPPERS_SIMPLE_tb/clk
add wave -noupdate /TWO_PARAM_WRAPPERS_SIMPLE_tb/rst_n
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/mbinit_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/sb_busy_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/fall_busy_A
add wave -noupdate -expand -group DIE_A -expand -group TX_A -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_A/dut_tx/CS
add wave -noupdate -expand -group DIE_A -expand -group TX_A -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_A/dut_tx/NS
add wave -noupdate -expand -group DIE_A -expand -group IN_DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/sb_enc_A
add wave -noupdate -expand -group DIE_A -expand -group IN_DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/msg_valid_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/error_req_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/check_TX_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/pass_tx_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/finish_tx_A
add wave -noupdate -expand -group DIE_A -expand -group RX_A -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_A/dut_rx/CS
add wave -noupdate -expand -group DIE_A -expand -group RX_A -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_A/dut_rx/NS
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/finish_rx_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/check_RX_A
add wave -noupdate -expand -group DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/PARAM_END_A
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/mbinit_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/sb_busy_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/fall_busy_B
add wave -noupdate -expand -group DIE_B -expand -group TX_B -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_B/dut_tx/CS
add wave -noupdate -expand -group DIE_B -expand -group TX_B -color Cyan /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_B/dut_tx/NS
add wave -noupdate -expand -group DIE_B -expand -group IN_DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/sb_enc_B
add wave -noupdate -expand -group DIE_B -expand -group IN_DIE_A /TWO_PARAM_WRAPPERS_SIMPLE_tb/msg_valid_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/pass_tx_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/check_TX_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/finish_tx_B
add wave -noupdate -expand -group DIE_B -expand -group RX_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_B/dut_rx/CS
add wave -noupdate -expand -group DIE_B -expand -group RX_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/WRAP_B/dut_rx/NS
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/finish_rx_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/error_req_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/check_RX_B
add wave -noupdate -expand -group DIE_B /TWO_PARAM_WRAPPERS_SIMPLE_tb/PARAM_END_B
add wave -noupdate -group parameters /TWO_PARAM_WRAPPERS_SIMPLE_tb/SB_MSG_Width
add wave -noupdate -group parameters /TWO_PARAM_WRAPPERS_SIMPLE_tb/CLK_PERIOD
add wave -noupdate -group parameters /TWO_PARAM_WRAPPERS_SIMPLE_tb/MBINIT_PARAM_configuration_req
add wave -noupdate -group parameters /TWO_PARAM_WRAPPERS_SIMPLE_tb/MBINIT_PARAM_configuration_resp
add wave -noupdate /TWO_PARAM_WRAPPERS_SIMPLE_tb/error_count
add wave -noupdate /TWO_PARAM_WRAPPERS_SIMPLE_tb/pass_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10977 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 253
configure wave -valuecolwidth 164
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {271877 ps} {296218 ps}
