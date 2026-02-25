//------------------------------------------------------------------------------
// Testbench Name : TWO_PARAM_WRAPPERS_SIMPLE_tb
// Description    : Simplified two-die parameter negotiation testbench
//                  Uses PARAM_WRAPPER directly with separate finish signals
//                  Tests basic parameter exchange between Die A and Die B
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module TWO_PARAM_WRAPPERS_SIMPLE_tb;

    parameter SB_MSG_Width = 4;
    parameter CLK_PERIOD = 10;
    
    logic clk;
    logic rst_n;
    
    // ===============================
    // Die A signals
    // ===============================
    logic mbinit_A;
    logic sb_busy_A;
    logic fall_busy_A;
    logic pass_tx_A;
    logic finish_tx_A;
    logic finish_rx_A;
    
    wire [SB_MSG_Width-1:0] sb_enc_A;
    wire msg_valid_A;
    wire error_req_A;
    wire check_TX_A;
    wire check_RX_A;
    wire PARAM_END_A;
    
    // ===============================
    // Die B signals
    // ===============================
    logic mbinit_B;
    logic sb_busy_B;
    logic fall_busy_B;
    logic pass_tx_B;
    logic finish_tx_B;
    logic finish_rx_B;
    
    wire [SB_MSG_Width-1:0] sb_enc_B;
    wire msg_valid_B;
    wire error_req_B;
    wire check_TX_B;
    wire check_RX_B;
    wire PARAM_END_B;
    
    // Testing signals
    reg [3:0] error_count, pass_count;
    
    // ===============================
    // Instantiate Wrapper A
    // ===============================
    PARAM_WRAPPER #(
        .SB_MSG_Width(SB_MSG_Width)
    ) WRAP_A (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_MBINIT_en(mbinit_A),
        .i_decoded_sb_msg(sb_enc_B),
        .i_sb_valid(msg_valid_B),
        .i_sb_busy(sb_busy_A),
        .i_falling_edge_busy(fall_busy_A),
        .i_pass_tx(pass_tx_A),
        .i_finish_tx(finish_tx_A),
        .i_finish_rx(finish_rx_A),
        .o_encoded_SB_msg(sb_enc_A),
        .o_msg_valid(msg_valid_A),
        .o_error_req(error_req_A),
        .check_TX(check_TX_A),
        .check_RX(check_RX_A),
        .o_PARAM_END(PARAM_END_A)
    );
    
    // ===============================
    // Instantiate Wrapper B
    // ===============================
    PARAM_WRAPPER #(
        .SB_MSG_Width(SB_MSG_Width)
    ) WRAP_B (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_MBINIT_en(mbinit_B),
        .i_decoded_sb_msg(sb_enc_A),
        .i_sb_valid(msg_valid_A),
        .i_sb_busy(sb_busy_B),
        .i_falling_edge_busy(fall_busy_B),
        .i_pass_tx(pass_tx_B),
        .i_finish_tx(finish_tx_B),
        .i_finish_rx(finish_rx_B),
        .o_encoded_SB_msg(sb_enc_B),
        .o_msg_valid(msg_valid_B),
        .o_error_req(error_req_B),
        .check_TX(check_TX_B),
        .check_RX(check_RX_B),
        .o_PARAM_END(PARAM_END_B)
    );
    
    //==============================================
    // CLK GENERATION
    //==============================================
    always #(CLK_PERIOD/2) clk = ~clk;
    
    //==============================================
    // SB MESSAGE ENCODINGS
    //==============================================
    localparam MBINIT_PARAM_configuration_req  = 4'b0001;
    localparam MBINIT_PARAM_configuration_resp = 4'b0010;
    
    //==============================================
    // RESET TASK
    //==============================================
    task reset;
        rst_n = 0;
        sb_busy_A = 0;
        fall_busy_A = 0;
        sb_busy_B = 0;
        fall_busy_B = 0;
        mbinit_A = 0;
        mbinit_B = 0;
        pass_tx_A = 0;
        finish_tx_A = 0;
        finish_rx_A = 0;
        pass_tx_B = 0;
        finish_tx_B = 0;
        finish_rx_B = 0;
        #CLK_PERIOD;
        rst_n = 1;
    endtask
    
    //==============================================
    // COMPLETE TX TASK A
    //==============================================
    task complete_tx_A();
        begin
            @(posedge clk);
            sb_busy_A = 1;
            repeat(2) @(posedge clk);
            fall_busy_A = 1;
            sb_busy_A = 0;
            $display("[TIME: %0t] falling edge busy(A) is high", $time);
            @(posedge clk);
            fall_busy_A = 0;
        end
    endtask
    
    //==============================================
    // COMPLETE TX TASK B
    //==============================================
    task complete_tx_B();
        begin
            @(posedge clk);
            sb_busy_B = 1;
            repeat(2) @(posedge clk);
            fall_busy_B = 1;
            sb_busy_B = 0;
            $display("[TIME: %0t] falling edge busy(B) is high", $time);
            @(posedge clk);
            fall_busy_B = 0;
        end
    endtask
    
    //=================================================
    // CHECK FOR MSGS SENT A
    //=================================================
    task automatic wait_for_msg_A;
        input logic [SB_MSG_Width-1:0] expected_msg;
        input string msg_name;
        
        bit timeout_flag;
        bit condition_flag;
        begin
            @(posedge clk);
            fork
                // Timeout counter
                begin
                    timeout_flag = 0;
                    repeat(5) @(posedge clk);
                    timeout_flag = 1;
                end
                // Wait for expected message
                begin
                    condition_flag = 0;
                    wait(sb_enc_A == expected_msg && msg_valid_A);
                    condition_flag = 1;
                end
            join_any
            disable fork;
            
            if (condition_flag) begin
                $display("[TIME %0t] PASS(A): %s detected (0x%0h)", $time, msg_name, expected_msg);
                pass_count = pass_count + 1;
            end
            else if (timeout_flag) begin
                $display("[TIME %0t] ERROR(A): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
                error_count = error_count + 1;
            end
        end
    endtask
    
    //=================================================
    // CHECK FOR MSGS SENT B
    //=================================================
    task automatic wait_for_msg_B;
        input logic [SB_MSG_Width-1:0] expected_msg;
        input string msg_name;
        
        bit timeout_flag;
        bit condition_flag;
        begin
            @(posedge clk);
            fork
                // Timeout counter
                begin
                    timeout_flag = 0;
                    repeat(5) @(posedge clk);
                    timeout_flag = 1;
                end
                // Wait for expected message
                begin
                    condition_flag = 0;
                    wait(sb_enc_B == expected_msg && msg_valid_B);
                    condition_flag = 1;
                end
            join_any
            disable fork;
            
            if (condition_flag) begin
                $display("[TIME %0t] PASS(B): %s detected (0x%0h)", $time, msg_name, expected_msg);
                pass_count = pass_count + 1;
            end
            else if (timeout_flag) begin
                $display("[TIME %0t] ERROR(B): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
                error_count = error_count + 1;
            end
        end
    endtask
    
    //==============================================
    // MAIN TEST
    //==============================================
    initial begin
        $dumpfile("TWO_PARAM_WRAPPERS_SIMPLE_tb.vcd");
        $dumpvars(0, TWO_PARAM_WRAPPERS_SIMPLE_tb);
        
        clk = 0;
        error_count = 0;
        pass_count = 0;
        
        reset();
        
        $display("\n========================================");
        $display("  SIMPLE TWO-DIE PARAMETER TEST");
        $display("========================================\n");
        
        // Enable both dies
        mbinit_A = 1;
        mbinit_B = 1;
        
        // ==========================================
        // STEP 1: Both send PARAM_REQ
        // ==========================================
        @(posedge clk);
        $display("\n=== STEP 1: PARAM Configuration Request ===");
        fork
            begin
                wait_for_msg_A(MBINIT_PARAM_configuration_req, "PARAM_REQ");
            end
            begin
                wait_for_msg_B(MBINIT_PARAM_configuration_req, "PARAM_REQ");
            end
            begin
                complete_tx_A();
            end
            begin
                complete_tx_B();
            end
        join
        
        // ==========================================
        // STEP 2: RX side checks parameters and sets finish_rx
        // When check_RX is active, it means PARAM_REQ was received
        // ==========================================
        repeat(2) @(posedge clk);
        $display("\n=== STEP 2: RX Parameter Checking ===");
        fork
        // Die A checks received request from B
       begin @(posedge clk);
        finish_rx_A = 1;
        $display("[TIME %0t] Die A: finish_rx asserted (RX check complete)", $time);
        @(posedge clk);
        finish_rx_A = 0;   end
        
        // Die B checks received request from A
        begin @(posedge clk);
        finish_rx_B = 1;
        $display("[TIME %0t] Die B: finish_rx asserted (RX check complete)", $time);
        @(posedge clk);
        finish_rx_B = 0; end
        join
        // ==========================================
        // STEP 3: Both send PARAM_RESP
        // ==========================================
        repeat(2) @(posedge clk);
        $display("\n=== STEP 3: PARAM Configuration Response ===");
        fork
            begin
                wait_for_msg_A(MBINIT_PARAM_configuration_resp, "PARAM_RESP");
            end
            begin
                wait_for_msg_B(MBINIT_PARAM_configuration_resp, "PARAM_RESP");
            end
            begin
                complete_tx_A();
            end
            begin
                complete_tx_B();
            end
        join
        
        // ==========================================
        // STEP 4: TX side validates response and sets pass_tx + finish_tx
        // When check_TX is active, it means PARAM_RESP was received
        // ==========================================
        repeat(2) @(posedge clk);
        $display("\n=== STEP 4: TX Response Validation ===");
       fork 
        // Die A validates response from B (pass it)
       begin  @(posedge clk);
        pass_tx_A = 1;
        finish_tx_A = 1;
        $display("[TIME %0t] Die A: pass_tx=1, finish_tx=1 (validation passed)", $time);
        @(posedge clk);
        pass_tx_A = 0;
        finish_tx_A = 0; end
        
        // Die B validates response from A (pass it)
       begin  @(posedge clk);
        pass_tx_B = 1;
        finish_tx_B = 1;
        $display("[TIME %0t] Die B: pass_tx=1, finish_tx=1 (validation passed)", $time);
        @(posedge clk);
        pass_tx_B = 0;
        finish_tx_B = 0; end 
       join
        
        
        // ==========================================
        // CHECK RESULTS
        // ==========================================
        $display("\n========================================");
        $display("  TEST RESULTS");
        $display("========================================");

        
        // Verify completion
        //wait (PARAM_END_A && PARAM_END_B) ;
         @(posedge clk);
        if(PARAM_END_A && PARAM_END_B) begin
            $display("\n*** SUCCESS: Both dies completed parameter exchange ***");
            pass_count = pass_count + 1;
        end else begin
            $display("\n*** FAILURE: Parameter exchange incomplete ***");
            $display("    PARAM_END_A=%0b, PARAM_END_B=%0b", PARAM_END_A, PARAM_END_B);
            error_count = error_count + 1;
        end
        
        if (!error_req_A && !error_req_B) begin
            $display("*** SUCCESS: No errors detected ***");
            pass_count = pass_count + 1;
        end else begin
            $display("*** FAILURE: Errors detected! A=%0b, B=%0b ***", error_req_A, error_req_B);
            error_count = error_count + 1;
        end
        
        $display("\n========================================");
        $display("  TEST SUMMARY");
        $display("========================================");
        $display("Total Passes: %0d", pass_count);
        $display("Total Errors: %0d", error_count);
        
        if (error_count == 0) begin
            $display("\n*** ALL TESTS PASSED ***\n");
        end else begin
            $display("\n*** TESTS FAILED ***\n");
        end
        $display("========================================\n");
        
        repeat(5) @(posedge clk);
        $stop;
    end
    
    // Auto-disable on completion or error
    always @(posedge clk) begin
        if (error_req_A || error_req_B || (PARAM_END_A && PARAM_END_B)) begin
            mbinit_A = 0;
            mbinit_B = 0; end
        if(error_req_A || error_req_B)  $display("error flag is high") ;       
        
    end
    
    // Timeout
    initial begin
        #50000;
        $display("\nTIMEOUT!");
        $stop;
    end

endmodule