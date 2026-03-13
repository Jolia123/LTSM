`timescale 1ns/1ps
module tb_PARAM_WRAPPER;

parameter SB_MSG_Width = 4;
parameter CLK_PERIOD   = 10;

// ── Clock & reset ─────────────────────────────────────────────────────────────
logic clk;
logic rst_n;

// ── Die A signals ─────────────────────────────────────────────────────────────
logic        param_en_A;
logic        sb_busy_A;
logic        fall_busy_A;
wire  [SB_MSG_Width-1:0] sb_enc_A;
wire         msg_valid_A;
wire  [15:0] parameters_A;
wire  [3:0]  final_rate_tx_A;
wire         error_req_A;
wire  [4:0]  vswing_A;
wire         clk_mode_A, clk_phase_A;
wire  [3:0]  final_rate_rx_A;
wire         param_end_A;

// ── Die B signals ─────────────────────────────────────────────────────────────
logic        param_en_B;
logic        sb_busy_B;
logic        fall_busy_B;
wire  [SB_MSG_Width-1:0] sb_enc_B;
wire         msg_valid_B;
wire  [15:0] parameters_B;
wire  [3:0]  final_rate_tx_B;
wire         error_req_B;
wire  [4:0]  vswing_B;
wire         clk_mode_B, clk_phase_B;
wire  [3:0]  final_rate_rx_B;
wire         param_end_B;

// ── Score ─────────────────────────────────────────────────────────────────────
reg [3:0] error_count, pass_count;

// ── Instantiate Wrapper A  (32 GT/s) ─────────────────────────────────────────
PARAM_WRAPPER_fin #(SB_MSG_Width) WRAP_A (
    .i_clk                    (clk),
    .i_rst_n                  (rst_n),
    .i_PARAM_en               (param_en_A),
    .i_sb_busy                (sb_busy_A),
    .i_falling_edge_busy      (fall_busy_A),
    .i_sb_valid               (msg_valid_B),
    .i_decoded_sb_msg         (sb_enc_B),
    .i_parameters             (parameters_B),
    .i_rf_data_rate           (4'b0101),
    .i_rf_vswing              (5'b00111),
    .i_rf_clk_mode            (1'b1),
    .i_rf_clk_phase           (1'b0),
    .i_rf_module_id           (2'b00),
    .i_rf_ucie_sx8            (1'b0),
    .i_rf_sfes                (1'b0),
    .i_rf_tarr                (1'b1),
    .o_encoded_SB_msg         (sb_enc_A),
    .o_msg_valid              (msg_valid_A),
    .o_parameters             (parameters_A),
    .o_final_max_data_rate_tx (final_rate_tx_A),
    .o_error_req              (error_req_A),
    .o_module_vswing          (vswing_A),
    .o_module_clk_mode        (clk_mode_A),
    .o_module_clk_phase       (clk_phase_A),
    .o_final_max_data_rate_rx (final_rate_rx_A),
    .o_PARAM_END              (param_end_A)
);

// ── Instantiate Wrapper B  (16 GT/s — sets resolved rate) ────────────────────
PARAM_WRAPPER_fin #(SB_MSG_Width) WRAP_B (
    .i_clk                    (clk),
    .i_rst_n                  (rst_n),
    .i_PARAM_en               (param_en_B),
    .i_sb_busy                (sb_busy_B),
    .i_falling_edge_busy      (fall_busy_B),
    .i_sb_valid               (msg_valid_A),
    .i_decoded_sb_msg         (sb_enc_A),
    .i_parameters             (parameters_A),
    .i_rf_data_rate           (4'b0011),
    .i_rf_vswing              (5'b00111),
    .i_rf_clk_mode            (1'b1),
    .i_rf_clk_phase           (1'b0),
    .i_rf_module_id           (2'b00),
    .i_rf_ucie_sx8            (1'b0),
    .i_rf_sfes                (1'b0),
    .i_rf_tarr                (1'b1),
    .o_encoded_SB_msg         (sb_enc_B),
    .o_msg_valid              (msg_valid_B),
    .o_parameters             (parameters_B),
    .o_final_max_data_rate_tx (final_rate_tx_B),
    .o_error_req              (error_req_B),
    .o_module_vswing          (vswing_B),
    .o_module_clk_mode        (clk_mode_B),
    .o_module_clk_phase       (clk_phase_B),
    .o_final_max_data_rate_rx (final_rate_rx_B),
    .o_PARAM_END              (param_end_B)
);

// ── Clock generation ──────────────────────────────────────────────────────────
always #(CLK_PERIOD/2) clk = ~clk;

// ── SB opcodes ────────────────────────────────────────────────────────────────
localparam PARAM_REQ  = 4'b0001;
localparam PARAM_RESP = 4'b0010;

// =============================================================================
// TASK: reset
// =============================================================================
task reset;
    begin
        rst_n       = 0;
        param_en_A  = 0;
        param_en_B  = 0;
        sb_busy_A   = 0;
        fall_busy_A = 0;
        sb_busy_B   = 0;
        fall_busy_B = 0;
        #CLK_PERIOD;
        rst_n = 1;
    end
endtask

// =============================================================================
// TASK: complete_tx_A
//   Mimics SB bus for die A: busy high -> falling_edge_busy pulse -> release
// =============================================================================
task complete_tx_A;
    begin
        sb_busy_A = 1;
        #(CLK_PERIOD*2);
        fall_busy_A = 1;
        sb_busy_A   = 0;
        $display("[TIME: %0t] falling_edge_busy(A) high", $time);
        #CLK_PERIOD;
        fall_busy_A = 0;
    end
endtask

// =============================================================================
// TASK: complete_tx_B
// =============================================================================
task complete_tx_B;
    begin
        sb_busy_B = 1;
        #(CLK_PERIOD*2);
        fall_busy_B = 1;
        sb_busy_B   = 0;
        $display("[TIME: %0t] falling_edge_busy(B) high", $time);
        #CLK_PERIOD;
        fall_busy_B = 0;
    end
endtask

// =============================================================================
// TASK: wait_for_msg_A
//   Waits up to 5 cycles for WRAP_A to send expected opcode
// =============================================================================
task automatic wait_for_msg_A;
    input logic [SB_MSG_Width-1:0] expected_msg;
    input string                   msg_name;
    bit timeout_flag;
    bit condition_flag;
    begin
        @(posedge clk);
        fork
            begin
                timeout_flag = 0;
                repeat(5) @(posedge clk);
                timeout_flag = 1;
            end
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
        end else begin
            $display("[TIME %0t] ERROR(A): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
            error_count = error_count + 1;
        end
    end
endtask

// =============================================================================
// TASK: wait_for_msg_B
// =============================================================================
task automatic wait_for_msg_B;
    input logic [SB_MSG_Width-1:0] expected_msg;
    input string                   msg_name;
    bit timeout_flag;
    bit condition_flag;
    begin
        @(posedge clk);
        fork
            begin
                timeout_flag = 0;
                repeat(5) @(posedge clk);
                timeout_flag = 1;
            end
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
        end else begin
            $display("[TIME %0t] ERROR(B): Timeout waiting for %s (0x%0h)", $time, msg_name, expected_msg);
            error_count = error_count + 1;
        end
    end
endtask

// =============================================================================
// TASK: check_final_values
//   Called after both sides reach PARAM_END
// =============================================================================
task check_final_values;
    begin
        #(CLK_PERIOD * 6);
        $display("[TIME %0t] --- FINAL VALUE CHECK ---", $time);

        if (param_end_A) begin
            $display("[TIME %0t] PASS(A): PARAM_END asserted", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(A): PARAM_END not asserted", $time);
            error_count = error_count + 1;
        end

        if (param_end_B) begin
            $display("[TIME %0t] PASS(B): PARAM_END asserted", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(B): PARAM_END not asserted", $time);
            error_count = error_count + 1;
        end

        if (!error_req_A) begin
            $display("[TIME %0t] PASS(A): no TX error", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(A): unexpected error_req", $time);
            error_count = error_count + 1;
        end

        if (!error_req_B) begin
            $display("[TIME %0t] PASS(B): no TX error", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(B): unexpected error_req", $time);
            error_count = error_count + 1;
        end

        // Resolved rate = 0011 (16 GT/s) on both sides
        if (final_rate_tx_A == 4'b0011) begin
            $display("[TIME %0t] PASS(A): TX resolved rate = 0011 (16GT/s)", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(A): TX resolved rate = 0x%0h (exp 0011)", $time, final_rate_tx_A);
            error_count = error_count + 1;
        end

        if (final_rate_tx_B == 4'b0011) begin
            $display("[TIME %0t] PASS(B): TX resolved rate = 0011 (16GT/s)", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(B): TX resolved rate = 0x%0h (exp 0011)", $time, final_rate_tx_B);
            error_count = error_count + 1;
        end

        if (final_rate_rx_A == 4'b0011) begin
            $display("[TIME %0t] PASS(A): RX resolved rate = 0011 (16GT/s)", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(A): RX resolved rate = 0x%0h (exp 0011)", $time, final_rate_rx_A);
            error_count = error_count + 1;
        end

        if (final_rate_rx_B == 4'b0011) begin
            $display("[TIME %0t] PASS(B): RX resolved rate = 0011 (16GT/s)", $time);
            pass_count = pass_count + 1;
        end else begin
            $display("[TIME %0t] ERROR(B): RX resolved rate = 0x%0h (exp 0011)", $time, final_rate_rx_B);
            error_count = error_count + 1;
        end

        $display("[TIME %0t] --- RESULTS: PASS=%0d  ERROR=%0d ---", $time, pass_count, error_count);
    end
endtask

// =============================================================================
// MAIN
// =============================================================================
initial begin
    clk         = 0;
    error_count = 0;
    pass_count  = 0;

    reset();

    param_en_A = 1;
    param_en_B = 1;

    // Phase 1: both sides send REQ
    @(posedge clk);
    fork
        begin wait_for_msg_A(PARAM_REQ, "PARAM_REQ"); end
        begin wait_for_msg_B(PARAM_REQ, "PARAM_REQ"); end
        begin complete_tx_A(); end
        begin complete_tx_B(); end
    join

    // Phase 2: both sides send RESP
    @(posedge clk);
    fork
        begin wait_for_msg_A(PARAM_RESP, "PARAM_RESP"); end
        begin wait_for_msg_B(PARAM_RESP, "PARAM_RESP"); end
       /* begin complete_tx_A(); end
        begin complete_tx_B(); end*/
    join

    complete_tx_A();
    complete_tx_B();
    //#(CLK_PERIOD * 6);
    check_final_values();
    #(CLK_PERIOD * 2);
    param_en_A <= 0;
    param_en_B <= 0;
    $stop;
end

// Disable param_en once both done or any error
always @(posedge clk) begin
    if (error_req_A || error_req_B ) begin
        param_en_A <= 0;
        param_en_B <= 0;
    end
end

endmodule