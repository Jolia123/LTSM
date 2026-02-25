onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /TWO_WRAPPERS_tb_CLK/clk
add wave -noupdate /TWO_WRAPPERS_tb_CLK/rst_n
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/clear_log_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/mbinit_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/fall_busy_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/sb_busy_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/clk_done_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/clk_ptrn_en_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/error_req_A
add wave -noupdate -expand -group {DIE A} /TWO_WRAPPERS_tb_CLK/log_cmp_A
add wave -noupdate -expand -group {DIE A} -expand -group TX_A -color {Violet Red} /TWO_WRAPPERS_tb_CLK/WRAP_A/TX_inst/CS
add wave -noupdate -expand -group {DIE A} -expand -group TX_A -color {Violet Red} /TWO_WRAPPERS_tb_CLK/WRAP_A/TX_inst/NS
add wave -noupdate -expand -group {DIE A} -expand -group RX_A -color Yellow /TWO_WRAPPERS_tb_CLK/WRAP_A/RX_inst/CS
add wave -noupdate -expand -group {DIE A} -expand -group RX_A -color Yellow /TWO_WRAPPERS_tb_CLK/WRAP_A/RX_inst/NS
add wave -noupdate -expand -group {DIE A} -expand -group IN_B /TWO_WRAPPERS_tb_CLK/logged_rx_A
add wave -noupdate -expand -group {DIE A} -expand -group {OUT_A/ IN_B} -color Cyan /TWO_WRAPPERS_tb_CLK/msg_valid_A
add wave -noupdate -expand -group {DIE A} -expand -group {OUT_A/ IN_B} -color Cyan -subitemconfig {{/TWO_WRAPPERS_tb_CLK/sb_enc_A[3]} {-color Cyan} {/TWO_WRAPPERS_tb_CLK/sb_enc_A[2]} {-color Cyan} {/TWO_WRAPPERS_tb_CLK/sb_enc_A[1]} {-color Cyan} {/TWO_WRAPPERS_tb_CLK/sb_enc_A[0]} {-color Cyan}} /TWO_WRAPPERS_tb_CLK/sb_enc_A
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/mbinit_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/fall_busy_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/sb_busy_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/clear_log_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/clk_done_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/CLK_PERIOD
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/clk_ptrn_en_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/error_req_B
add wave -noupdate -expand -group {DIE B} /TWO_WRAPPERS_tb_CLK/log_cmp_B
add wave -noupdate -expand -group {DIE B} -expand -group TX_B -color {Violet Red} /TWO_WRAPPERS_tb_CLK/WRAP_B/TX_inst/CS
add wave -noupdate -expand -group {DIE B} -expand -group TX_B -color {Violet Red} /TWO_WRAPPERS_tb_CLK/WRAP_B/TX_inst/NS
add wave -noupdate -expand -group {DIE B} -expand -group RX_B -color Yellow /TWO_WRAPPERS_tb_CLK/WRAP_B/RX_inst/CS
add wave -noupdate -expand -group {DIE B} -expand -group RX_B -color Yellow /TWO_WRAPPERS_tb_CLK/WRAP_B/RX_inst/NS
add wave -noupdate -expand -group {DIE B} -expand -group IN_A /TWO_WRAPPERS_tb_CLK/logged_rx_B
add wave -noupdate -expand -group {DIE B} -expand -group {OUT_B / IN_A} -color Cyan /TWO_WRAPPERS_tb_CLK/msg_valid_B
add wave -noupdate -expand -group {DIE B} -expand -group {OUT_B / IN_A} -color Cyan /TWO_WRAPPERS_tb_CLK/sb_enc_B
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/SB_MSG_Width
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_done_req
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_done_resp
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_end_A
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_end_B
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_init_req
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_init_resp
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_result_req
add wave -noupdate -expand -group parameters /TWO_WRAPPERS_tb_CLK/MBINIT_REPAIRCLK_result_resp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1672 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {6765 ps}
