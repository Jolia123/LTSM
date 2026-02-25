module PARAM_TX #(parameter SB_MSG_Width = 4 )
(
    input   i_clk , 
    input   i_rst_n , 
    input   i_MBINIT_en ,
    input   i_sb_busy , i_falling_edge_busy ,
    input   i_sb_valid , i_finish , i_pass ,
    input   [SB_MSG_Width-1:0]  i_decoded_sb_msg ,


    output  reg     [SB_MSG_Width-1:0]  o_encoded_SB_msg ,
    output  reg     o_msg_valid ,
    output  reg     o_PARAM_UP_end  ,  error_req , check_en 
);

//internal signals

// Sideband messages
localparam MBINIT_PARAM_configuration_req = 4'b0001;
localparam MBINIT_PARAM_configuration_resp = 4'b0010;

// State machine states
typedef enum logic [2:0]    {IDLE ,
                    PARAM_REQ  ,
                    WAIT_RESP  ,
                    CHECK_RESP  ,
                    PARAM_END  
                    } state ;
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
always @(*)
    begin
        if (!i_MBINIT_en)
            begin
                NS = IDLE ;
            end
        else
            begin
               case(CS)
                    IDLE:
                        begin
                            if(i_MBINIT_en && !i_sb_busy)
                                begin
                                    NS = PARAM_REQ ;
                                end
                            else
                                begin
                                    NS = IDLE ;
                                end    
                        end

                    PARAM_REQ:
                        begin
                            if (i_falling_edge_busy)
                                begin
                                    NS = WAIT_RESP ;
                                end
                            else
                                begin
                                    NS = PARAM_REQ ;
                                end    
                        end

                    WAIT_RESP:
                        begin
                            if(i_decoded_sb_msg == MBINIT_PARAM_configuration_resp && i_sb_valid)
                                begin
                                    NS = CHECK_RESP ;
                                end
                            else
                                begin
                                    NS = WAIT_RESP ;
                                end    
                        end

                    CHECK_RESP:
                        begin
                            if(i_finish)
                                begin
                                    if (i_pass)
                                        begin
                                            NS = PARAM_END ;
                                        end
                                    else
                                        begin
                                            NS = IDLE ;
                                        end
                                end
                            else 
                            begin
                                NS = CHECK_RESP ;
                            end
                        end

                    PARAM_END:
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
        if(!i_rst_n)
            begin
                o_encoded_SB_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_PARAM_UP_end  <='d0 ; 
                check_en <= 0 ;
                
            end
        else
            begin
                o_encoded_SB_msg <= 'd0 ;
                o_msg_valid <= 'd0 ;
                o_PARAM_UP_end  <='d0 ; 
                check_en <= 0 ;
                

                case (NS)
                        IDLE:
                            begin
                              
                            end
                        PARAM_REQ:
                            begin
                                o_encoded_SB_msg <= MBINIT_PARAM_configuration_req ;
                                o_msg_valid <= 'd1 ;
                               
                            end

                        WAIT_RESP:
                            begin
                                       
                            end 

                        CHECK_RESP:
                              begin
                                //check_en <= 1 ;
                               
                              end

                        PARAM_END :
                            begin
                                o_PARAM_UP_end <= 1 ;
                            end              
                endcase     
            end    
    end
always @(posedge i_clk or negedge i_rst_n)
    begin
        if(!i_rst_n)   
            begin
                error_req <= 'd0 ;
                check_en <= 0 ;
            end 
        else
            begin
                 if(i_finish)
                                begin
                                    if (!i_pass)
                                        begin
                                          error_req <= 1 ;  
                                        end
                                    else
                                        begin
                                            error_req <= 0 ;
                                        end    

                                end
                if(i_decoded_sb_msg == MBINIT_PARAM_configuration_resp && i_sb_valid)
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