`timescale 1ns/1ps
module TWO_WRAPPERS_tb_CLK ;
 parameter SB_MSG_Width = 4;
 parameter CLK_PERIOD = 10 ;
    logic clk;
    logic rst_n;

    // ===============================
    // Die A signals
    // ===============================
    logic mbinit_A;
    logic clk_done_A;
    logic sb_busy_A;
    logic fall_busy_A;
    logic [2:0] log_cmp_A;
    wire  [SB_MSG_Width-1:0] sb_enc_A;
    wire  msg_valid_A;
    wire error_req_A, MBINIT_REPAIRCLK_end_A , clear_log_A , clk_ptrn_en_A ;
    wire [2:0] logged_rx_A  ;
    // ===============================
    // Die B signals
    // ===============================
    logic mbinit_B;
    logic clk_done_B;
    logic sb_busy_B;
    logic fall_busy_B;
    logic [2:0] log_cmp_B;
    wire  [SB_MSG_Width-1:0] sb_enc_B;
    wire  msg_valid_B;
    wire error_req_B, MBINIT_REPAIRCLK_end_B , clear_log_B  , clk_ptrn_en_B ;
    wire [2:0] logged_rx_B  ;

    /////////testing signals ////////////////////////
    reg [3:0] error_count , pass_count ;
    // ===============================
    // Instantiate Wrapper A
    // ===============================
    REPAIRCLK_WRAPPER #(SB_MSG_Width) WRAP_A (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_mbinit_rpairclk_en(mbinit_A),
        .i_clk_ptrn_done(clk_done_A),
        .i_decoded_sb_msg(sb_enc_B),
        .i_sb_busy(sb_busy_A),
        .i_falling_edge_busy(fall_busy_A),
        .i_sb_valid(msg_valid_B),
        .i_logged_results_SB(logged_rx_B),
        .i_logged_results_COMP(log_cmp_A),
        .o_encoded_sb_msg(sb_enc_A),
        .o_msg_valid(msg_valid_A) ,
        .o_error_req(error_req_A),
        .o_clk_ptrn_en(clk_ptrn_en_A),
        .o_MBINIT_REPAIRCLK_end (MBINIT_REPAIRCLK_end_A),
        .o_logged_rx (logged_rx_A) ,
        .o_clear_log (clear_log_A) 
    );

    // ===============================
    // Instantiate Wrapper B
    // ===============================
    REPAIRCLK_WRAPPER #(SB_MSG_Width) WRAP_B (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_mbinit_rpairclk_en(mbinit_B),
        .i_clk_ptrn_done(clk_done_B),
        .i_decoded_sb_msg(sb_enc_A),
        .i_sb_busy(sb_busy_B),
        .i_falling_edge_busy(fall_busy_B),
        .i_sb_valid(msg_valid_A),
        .i_logged_results_SB(logged_rx_A),
        .i_logged_results_COMP(log_cmp_B),
        .o_encoded_sb_msg(sb_enc_B),
        .o_msg_valid(msg_valid_B),
        .o_error_req(error_req_B),
        .o_clk_ptrn_en(clk_ptrn_en_B),
        .o_MBINIT_REPAIRCLK_end (MBINIT_REPAIRCLK_end_B),
        .o_logged_rx (logged_rx_B) ,
        .o_clear_log (clear_log_B) 
    );
    //==============================================
    // CLK GENERATION
    //============================================

    always #(CLK_PERIOD/2) clk = ~clk ;

    //////////////////// SB MESSAGES ENCODING /////////////////////////////
    localparam MBINIT_REPAIRCLK_init_req     = 4'b0001;
    localparam MBINIT_REPAIRCLK_init_resp   = 4'b0010;
    localparam MBINIT_REPAIRCLK_result_req  = 4'b0011;
    localparam MBINIT_REPAIRCLK_result_resp = 4'b0100;
    localparam MBINIT_REPAIRCLK_done_req    = 4'b0101;
    localparam MBINIT_REPAIRCLK_done_resp   = 4'b0110;

    //==============================================
    // reset task 
    //============================================
    task reset ;
        rst_n = 0 ;
        clk_done_A = 0;
        sb_busy_A= 0;
        fall_busy_A = 0;
        log_cmp_A= 0;
        clk_done_B= 0;
        sb_busy_B= 0;
        fall_busy_B = 0;
        log_cmp_B= 0;
        mbinit_B = 0 ;
        mbinit_A = 0 ;
        #CLK_PERIOD ;
        rst_n = 1 ;
    endtask
    //==============================================
    // busy_A 
    //============================================
        task complete_tx_A();
        begin
            sb_busy_A = 1;
            @(negedge clk)
            fall_busy_A = 1;
            sb_busy_A = 0;
            $display("[TIME: %0t]falling edge busy(A) is high",$time);
            #CLK_PERIOD;
            fall_busy_A = 0;   
        end
    endtask

    //==============================================
    // busy_ 
    //============================================
        task complete_tx_B();
        begin
            sb_busy_B = 1;
            #(CLK_PERIOD);
            fall_busy_B = 1;
            sb_busy_B = 0;
            $display("[TIME: %0t]falling edge busy(B) is high",$time);
            #CLK_PERIOD;
            fall_busy_B = 0;   
        end
    endtask
    //=================================================
    // CHECK_FOR_MSGS_SENT_A
    //==================================
    task automatic wait_for_msg_A;
    input  logic [SB_MSG_Width-1:0] expected_msg;
    input  string                  msg_name;      // optional for display
    
    bit timeout_flag;
    bit condition_flag;
    begin
    @(posedge clk);    
    fork
        // Timeout counter (3 clock cycles)
        begin
            timeout_flag = 0;
            repeat (3) @(posedge clk);
            timeout_flag = 1;
        end
        // Wait for the expected message
        begin
            condition_flag = 0;
            wait (sb_enc_A == expected_msg && msg_valid_A);
            condition_flag = 1;
        end
    join_any
    disable fork; // Stop the other branch
    if (condition_flag) begin
        $display("[TIME %0t] PASS(A): %s detected (0x%0h)", $time, msg_name, expected_msg);
        pass_count = pass_count +1;
    end
    else if (timeout_flag) begin
        $display("[TIME %0t] ERROR(A): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
        error_count = error_count + 1;
    end
end
endtask

    //=================================================
    // CHECK_FOR_MSGS_SENT_B
    //==================================
    task automatic wait_for_msg_B;
    input  logic [SB_MSG_Width-1:0] expected_msg;
    input  string                  msg_name;      // optional for display
    
    bit timeout_flag;
    bit condition_flag;
    begin
    @(posedge clk);    
    fork
        // Timeout counter (3 clock cycles)
        begin
            timeout_flag = 0;
            repeat (4) @(posedge clk);
            timeout_flag = 1;
        end
        // Wait for the expected message
        begin
            condition_flag = 0;
            wait (sb_enc_B == expected_msg && msg_valid_B);
            condition_flag = 1;
        end
    join_any
    disable fork; // Stop the other branch
    if (condition_flag) begin
        $display("[TIME %0t] PASS(B): %s detected (0x%0h)", $time, msg_name, expected_msg);
        pass_count = pass_count +1;
    end
    else if (timeout_flag) begin
        $display("[TIME %0t] ERROR(B): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
        error_count = error_count + 1;
    end
end
endtask

    initial 
        begin
        clk = 0 ;    
        reset();
        mbinit_B = 1 ;
        mbinit_A = 1 ;
        @(posedge clk )
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_init_req , "INIT_REQ") ;
            end

            begin
                wait_for_msg_B (MBINIT_REPAIRCLK_init_req , "INIT_REQ") ;
            end
            
            begin
               complete_tx_A(); 
            end

            begin
               complete_tx_B(); 
            end
        join

        @(posedge clk )
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_init_resp , "INIT_RESP") ;
            end

            begin
                wait_for_msg_B (MBINIT_REPAIRCLK_init_resp , "INIT_RESP") ;
            end
            
            begin
               complete_tx_A(); 
            end

            begin
               complete_tx_B(); 
            end
        join

        #(CLK_PERIOD * 2) ;
        clk_done_A = 1 ;
        clk_done_B = 1 ;
        @(posedge clk )
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_result_req , "RES_REQ") ;
            end

            begin
                wait_for_msg_B (MBINIT_REPAIRCLK_result_req, "RES_REQ") ;
            end
            
            begin
               complete_tx_A(); 
            end

            begin
               complete_tx_B(); 
            end
            begin
                log_cmp_A = 'b111 ;
                log_cmp_B = 'b111 ;
            end 
        join 
        
        @(posedge clk );
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_result_resp , "RES_RESP") ;
            end

            begin
                wait_for_msg_B (MBINIT_REPAIRCLK_result_resp, "RES_RESP") ;
            end
            
            begin
               complete_tx_A(); 
            end

            begin
               complete_tx_B(); 
            end
        join
          
        @(posedge clk );
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_done_req , "done_req") ;
            end

            begin
                
                wait_for_msg_B (MBINIT_REPAIRCLK_done_req, "done_req") ;
            end
            
            begin
               complete_tx_A(); 
            end

            begin
               complete_tx_B(); 
            end
        join

        @(posedge clk) ;
        fork
            begin
                wait_for_msg_A (MBINIT_REPAIRCLK_done_resp , "done_resp") ;
            end

            begin
                
                wait_for_msg_B (MBINIT_REPAIRCLK_done_resp, "done_resp") ;
            end
            
            begin
                #10 ;
               complete_tx_A(); 
            end

            begin
                #10 ;
               complete_tx_B(); 
            end
        join 

     #(CLK_PERIOD *2);   
        $stop ;
        end



always @(posedge clk)
    begin
        if (error_req_A || error_req_B || (MBINIT_REPAIRCLK_end_A && MBINIT_REPAIRCLK_end_B))
            begin
                mbinit_A = 0 ;
                mbinit_B = 0 ;
               
            end
    end


endmodule