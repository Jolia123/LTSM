module PARAM_WRAPPER #(parameter SB_MSG_Width = 4)
(
    input   i_clk , i_rst_n ,
    input   i_MBINIT_en ,
    input   [SB_MSG_Width-1:0]  i_decoded_sb_msg ,
    input   i_sb_valid ,
    input   i_sb_busy ,
    input   i_falling_edge_busy , i_pass_tx , i_finish_tx , i_finish_rx ,

    output  reg [SB_MSG_Width-1:0]  o_encoded_SB_msg ,
    output  reg o_msg_valid ,
    output  reg o_error_req , check_TX , check_RX ,
    output  reg o_PARAM_END 
);

/////internal signals 
reg [SB_MSG_Width-1:0]  o_encoded_SB_msg_up , o_encoded_SB_msg_down ;
reg o_sb_valid_up , o_sb_valid_down ;
reg o_PARAM_UP_end , o_PARAM_DOWN_end ;

////uplink_param_module
PARAM_TX #(.SB_MSG_Width (SB_MSG_Width)) dut_tx
(
    .i_clk (i_clk) , 
    .i_rst_n (i_rst_n), 
    .i_MBINIT_en (i_MBINIT_en),
    .i_sb_busy (i_sb_busy) , 
    .i_falling_edge_busy (i_falling_edge_busy) ,
    .i_sb_valid (i_sb_valid),
    .i_decoded_sb_msg (i_decoded_sb_msg),
    .i_finish(i_finish_tx),
    .i_pass(i_pass_tx) ,
    .o_encoded_SB_msg (o_encoded_SB_msg_up),
    .o_msg_valid (o_sb_valid_up),
    .check_en(check_TX),
    .o_PARAM_UP_end  (o_PARAM_UP_end),  
    .error_req (o_error_req)
);


////uplink_param_module
PARAM_RX #(.SB_MSG_Width (SB_MSG_Width) ) dut_rx
(
    .i_clk (i_clk) , 
    .i_rst_n (i_rst_n), 
    .i_MBINIT_en (i_MBINIT_en),
    .i_sb_busy (i_sb_busy) , 
    .i_falling_edge_busy (i_falling_edge_busy) ,
    .i_sb_valid (i_sb_valid),
    .i_decoded_sb_msg (i_decoded_sb_msg),
    .i_finish(i_finish_rx) ,
    .o_encoded_SB_msg (o_encoded_SB_msg_down),
    .o_msg_valid (o_sb_valid_down),
    .check_en(check_RX),
    .o_PARAM_DOWN_end  (o_PARAM_DOWN_end)  
);

always @(*)
    begin
        if(o_sb_valid_down )
            begin
                o_encoded_SB_msg = o_encoded_SB_msg_down ;
            end
        else if (o_sb_valid_up )
            begin
                o_encoded_SB_msg = o_encoded_SB_msg_up ;
            end
        else
            begin
                o_encoded_SB_msg = 'd0 ;
            end        
        o_msg_valid = o_sb_valid_up || o_sb_valid_down ;
        o_PARAM_END = o_PARAM_UP_end && o_PARAM_DOWN_end ; 
    end

endmodule