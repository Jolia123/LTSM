module PARAM_RX #(parameter SB_MSG_Width = 4 )
(
    input   i_clk , 
    input   i_rst_n , 
    input   i_MBINIT_en ,
    input   i_sb_busy , i_falling_edge_busy , i_finish ,
    input   i_sb_valid ,
    input   [SB_MSG_Width-1:0]  i_decoded_sb_msg ,

    output  reg     [SB_MSG_Width-1:0]  o_encoded_SB_msg ,
    output  reg     o_msg_valid ,
    output  reg     o_PARAM_DOWN_end  , check_en  
);



// Sideband messages
localparam MBINIT_PARAM_configuration_req = 4'b0001;
localparam MBINIT_PARAM_configuration_resp = 4'b0010;

// State machine states
typedef enum logic [2:0] {
    IDLE  ,
    WAIT_REQ  ,
    CHECK_PARAM  ,
    CHECK_SB  ,
    SEND_RESP ,
    PARAM_END  } state ;
state CS , NS ;
//transition logic
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
//next state logic
always @ (*)
    begin
        if (!i_MBINIT_en)
            begin
                NS = IDLE ;
            end
        else
            begin
                case (CS)
                    IDLE :
                        begin
                            if (i_MBINIT_en)
                                begin
                                    NS = WAIT_REQ ;
                                end
                            else
                                begin
                                    NS = IDLE ;
                                end    
                        end

                    WAIT_REQ :
                    begin
                        if (i_decoded_sb_msg == MBINIT_PARAM_configuration_req && i_sb_valid)
                            begin
                                NS = CHECK_PARAM ;
                            end
                        else
                            begin
                                NS = WAIT_REQ ;
                            end    
                    end

                    CHECK_PARAM :
                        begin
                           if(i_finish) 
                                begin
                                    NS = CHECK_SB ;
                                end
                            else
                                begin
                                    NS = CHECK_PARAM ;
                                end
                        end

                    CHECK_SB :
                        begin
                            if(!i_sb_busy)
                                begin
                                    NS = SEND_RESP ;
                                end
                            else
                                begin
                                    NS = CHECK_SB ;
                                end    
                        end 

                    SEND_RESP :
                        begin
                            if(i_falling_edge_busy)
                                begin
                                    NS = PARAM_END ;
                                end
                            else
                                begin
                                    NS = SEND_RESP ;
                                end    
                        end 

                    PARAM_END :
                        begin
                            if (i_MBINIT_en)       NS = PARAM_END ;
                            else                            NS = IDLE ;
                        end          
                endcase
            end
    end

//output logic
always @ (posedge i_clk or negedge i_rst_n)
    begin
        if (!i_rst_n)
            begin
                o_encoded_SB_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_PARAM_DOWN_end  <='d0 ; 
                //check_en <= 0 ;
            end
        else
            begin
                o_encoded_SB_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_PARAM_DOWN_end  <='d0 ;
                //check_en <= 0 ; 
                case (NS)
                    IDLE :
                        begin
                           
                        end
                    WAIT_REQ :
                        begin
                           
                        end

                    CHECK_PARAM : 
                        begin
                           // check_en <= 1 ;        
                        end 

                    CHECK_SB :
                        begin
                            
                        end

                    SEND_RESP :
                        begin
                            o_encoded_SB_msg <= MBINIT_PARAM_configuration_resp ;
                            o_msg_valid <= 'd1 ;
                            
                        end

                    PARAM_END:
                        begin
                            o_PARAM_DOWN_end <= 1'b1 ;
                        end
                endcase         
            end    
    end

always @(posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)   
            begin
                check_en <= 0 ;
            end 
        else
            begin
                if(i_decoded_sb_msg == MBINIT_PARAM_configuration_req && i_sb_valid)
                    begin
                        check_en <= 1 ;
                    end
                else
                    begin
                        check_en <= 0 ;
                    end                    
            end    
    end      

endmodule