onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_clk
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_rst_n
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_PARAM_en
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_sb_busy
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_falling_edge_busy
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_decoded_sb_msg
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_parameters
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/i_sb_valid
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/o_encoded_SB_msg
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/o_error_req
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/o_msg_valid
add wave -noupdate -expand -group die_a /tb_PARAM_WRAPPER/WRAP_A/o_PARAM_END
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/u_param_tx/CS
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/u_param_tx/NS
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/u_param_tx/finish
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/u_param_tx/pass
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/u_param_tx/saved_rx_parameters
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/o_tx_parameters
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/o_PARAM_tx_end
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/tx_encoded_msg
add wave -noupdate -expand -group die_a -expand -group txa /tb_PARAM_WRAPPER/WRAP_A/tx_msg_valid
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/NS
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/CS
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/finish
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/o_rx_parameters
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/o_PARAM_rx_end
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/rx_encoded_msg
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/rx_msg_valid
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/data_reg
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/resolved_param
add wave -noupdate -expand -group die_a -expand -group rxa /tb_PARAM_WRAPPER/WRAP_A/u_param_rx/saved_tx_parameters
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_clk
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_rst_n
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_PARAM_en
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_sb_busy
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_falling_edge_busy
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_decoded_sb_msg
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_parameters
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/i_sb_valid
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/o_encoded_SB_msg
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/o_error_req
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/o_msg_valid
add wave -noupdate -expand -group die_b /tb_PARAM_WRAPPER/WRAP_B/o_PARAM_END
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/CS
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/NS
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/finish
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/data_reg
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/pass
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/u_param_tx/saved_rx_parameters
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/o_tx_parameters
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/o_PARAM_tx_end
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/tx_encoded_msg
add wave -noupdate -expand -group die_b -expand -group txb /tb_PARAM_WRAPPER/WRAP_B/tx_msg_valid
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/CS
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/NS
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/finish
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/data_reg
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/resolved_param
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/u_param_rx/saved_tx_parameters
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/o_rx_parameters
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/o_PARAM_rx_end
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/rx_encoded_msg
add wave -noupdate -expand -group die_b -expand -group rxb /tb_PARAM_WRAPPER/WRAP_B/rx_msg_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {104902 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 212
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
WaveRestoreZoom {0 ps} {162750 ps}
