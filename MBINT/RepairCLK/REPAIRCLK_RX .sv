module REPAIRCLK_RX #(parameter SB_MSG_Width = 4)
(
    input   i_clk ,
    input   i_rst_n ,
    input   i_mbinit_rpairclk_en ,
    input   i_sb_busy ,
    input   i_falling_edge_busy ,
    input   [SB_MSG_Width-1:0]   i_decoded_sb_msg  ,
    input   i_sb_valid ,
    input   [2:0]   i_logged_results ,

    output reg   [2:0]   o_logged_results ,
    output  reg  [SB_MSG_Width-1:0]  o_encoded_sb_msg ,
    output  reg  o_msg_valid ,
    output  reg  o_clear_log ,
    output  reg  o_RX_end    
);

/////////////////////// states /////////////////////////////////

typedef enum logic [3:0] {
    IDLE,
    //WAIT_INIT_REQ,
    CHECK_BUSY_INIT,
    SEND_INIT_RESP,
    WAIT_REQS,
    CHECK_BUSY_RES ,
    SEND_RES_RESP,
    CHECK_BUSY_DONE ,
    SEND_DONE_RESP ,
    RX_END
} states;

states CS, NS ;

//////////////////// SB MESSAGES ENCODING /////////////////////////////
localparam MBINIT_REPAIRCLK_init_req     = 4'b0001;
localparam MBINIT_REPAIRCLK_init_resp   = 4'b0010;
localparam MBINIT_REPAIRCLK_result_req  = 4'b0011;
localparam MBINIT_REPAIRCLK_result_resp = 4'b0100;
localparam MBINIT_REPAIRCLK_done_req    = 4'b0101;
localparam MBINIT_REPAIRCLK_done_resp   = 4'b0110;

////////////////////// STATE TRANSITION BLOCK //////////////////////////////
always @ (posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)
            begin
                CS <= IDLE ;
            end
        else
            begin
                CS <= NS ;
            end    
    end

////////////////////////// NEXT STATE BLOCK ////////////////////////////
always @ (*)
    begin
        if (!i_mbinit_rpairclk_en)
            begin
                NS = IDLE ;
            end
        else
            begin
                case(CS)
                    IDLE :
                        begin
                            if (i_mbinit_rpairclk_en)
                                begin
                                    NS = WAIT_REQS ;
                                end
                            else
                                begin
                                    NS = IDLE ;
                                end    
                        end
                    /*WAIT_INIT_REQ:
                        begin
                            if (i_decoded_sb_msg == MBINIT_REPAIRCLK_init_req && i_sb_valid )      NS = CHECK_BUSY_INIT ;
                            else                                                                        NS = WAIT_INIT_REQ ;        
                        end*/
                    CHECK_BUSY_INIT:
                        begin
                            if(!i_sb_busy )                         NS = SEND_INIT_RESP ;
                            else                                    NS = CHECK_BUSY_INIT ; 
                        end
                    SEND_INIT_RESP:
                        begin
                            if(i_falling_edge_busy)     NS = WAIT_REQS ;
                            else                        NS = SEND_INIT_RESP ;
                        end    
                    WAIT_REQS:
                        begin
                            if (i_decoded_sb_msg == MBINIT_REPAIRCLK_init_req && i_sb_valid )      NS = CHECK_BUSY_INIT ;
                            else if (i_decoded_sb_msg == MBINIT_REPAIRCLK_result_req && i_sb_valid)    NS = CHECK_BUSY_RES ;
                            else if (i_decoded_sb_msg == MBINIT_REPAIRCLK_done_req && i_sb_valid)    NS = CHECK_BUSY_DONE ;
                            else    NS = WAIT_REQS ;
                        end
                    
                    CHECK_BUSY_RES :
                        begin
                            if(!i_sb_busy )                         NS = SEND_RES_RESP ;
                            else                                    NS = CHECK_BUSY_RES ;
                        end
                    SEND_RES_RESP :
                        begin
                           if(i_falling_edge_busy)      NS = WAIT_REQS ;
                            else                        NS = SEND_RES_RESP ; 
                        end    
                    CHECK_BUSY_DONE :
                        begin
                          if(!i_sb_busy)                          NS = SEND_DONE_RESP ;
                          else                                    NS = CHECK_BUSY_DONE ;  
                        end
                    SEND_DONE_RESP:
                        begin
                           if(i_falling_edge_busy)      NS = RX_END  ;
                            else                        NS = SEND_DONE_RESP ;  
                        end
                    
                    RX_END :
                        begin
                            if (i_mbinit_rpairclk_en)       NS = RX_END ;
                            else                            NS = IDLE ;
                        end
                    default:
                        begin
                            NS = IDLE ;
                        end                            
                endcase
            end 
    end

////////////////////////// OUTPUT BLOCK /////////////////////////////

always @ (posedge i_clk or negedge i_rst_n)
    begin
        if (!i_rst_n)
            begin
                o_logged_results <= 'd0 ;
                o_encoded_sb_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_clear_log <= 'd0 ;
                o_RX_end  <= 'd0 ; 
            end
        else
            begin
                o_logged_results <= 'd0 ;
                o_encoded_sb_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_clear_log <= 'd0 ;
                o_RX_end  <= 'd0 ; 
                case(NS)
                    IDLE :
                        begin
                                
                        end
                   /* WAIT_INIT_REQ:
                        begin
                                    
                        end*/
                    CHECK_BUSY_INIT:
                        begin
                            
                        end
                    SEND_INIT_RESP:
                        begin
                            o_encoded_sb_msg <= MBINIT_REPAIRCLK_init_resp ;
                            o_msg_valid <= 'd1 ;
                            o_clear_log <= 'd1 ; 
                        end    
                    WAIT_REQS:
                        begin
                            
                        end
                    
                    CHECK_BUSY_RES :
                        begin
                            
                        end
                    SEND_RES_RESP :
                        begin
                           o_encoded_sb_msg <= MBINIT_REPAIRCLK_result_resp ;
                            o_msg_valid <= 'd1 ;
                            o_logged_results <= i_logged_results ;
                        end    
                    CHECK_BUSY_DONE :
                        begin
                           
                        end
                    SEND_DONE_RESP:
                        begin
                            o_encoded_sb_msg <= MBINIT_REPAIRCLK_done_resp ;
                            o_msg_valid <= 'd1 ;
                            
                        end
                    
                    RX_END :
                        begin
                          o_RX_end  <= 'd1 ;  
                        end
                    default:
                        begin
                            
                        end                            
                endcase                
            end     
    end

endmodule