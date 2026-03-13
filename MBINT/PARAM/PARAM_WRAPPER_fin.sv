module PARAM_WRAPPER_fin #(parameter SB_MSG_Width = 4)
(
    // ── Global ────────────────────────────────────────────────────────────────
    input   wire                        i_clk,
    input   wire                        i_rst_n,

    // ── Control ───────────────────────────────────────────────────────────────
    input   wire                        i_PARAM_en,         // enable this state

    // ── Sideband interface (shared) ───────────────────────────────────────────
    input   wire                        i_sb_busy,
    input   wire                        i_falling_edge_busy,
    input   wire                        i_sb_valid,
    input   wire [SB_MSG_Width-1:0]     i_decoded_sb_msg,
    input   wire [15:0]                 i_parameters,  // from partner (fed into TX for check)


    // ── Register-file inputs shared by both TX and RX ────────────────────────
    input   wire [3:0]                  i_rf_data_rate,
    input   wire [4:0]                  i_rf_vswing,
    input   wire                        i_rf_clk_mode,
    input   wire                        i_rf_clk_phase,
    input   wire [1:0]                  i_rf_module_id,
    input   wire                        i_rf_ucie_sx8,
    input   wire                        i_rf_sfes,
    input   wire                        i_rf_tarr,

    // ── Sideband output (muxed from TX and RX) ────────────────────────────────
    output  reg  [SB_MSG_Width-1:0]     o_encoded_SB_msg,
    output  reg                         o_msg_valid,
    output  reg [15:0]                 o_parameters, 
    // ── TX outputs ────────────────────────────────────────────────────────────
       // packed REQ bits
    output  wire [3:0]                  o_final_max_data_rate_tx,
    output  wire                        o_error_req,            // TRAINERROR flag

    // ── RX outputs ────────────────────────────────────────────────────────────
    output  wire [4:0]                  o_module_vswing,        // partner TX vswing (set Vref)
    output  wire                        o_module_clk_mode,      // partner TX clock mode
    output  wire                        o_module_clk_phase,     // partner TX clock phase
    output  wire [3:0]                  o_final_max_data_rate_rx,

    // ── Combined end flag ─────────────────────────────────────────────────────
    output  wire                        o_PARAM_END             // both TX and RX done
);

// ── Internal wires from TX ────────────────────────────────────────────────────
wire [SB_MSG_Width-1:0]  tx_encoded_msg;
wire                     tx_msg_valid , o_PARAM_tx_end  ;
wire [15:0]                 o_tx_parameters ;
// ── Internal wires from RX ────────────────────────────────────────────────────
wire [SB_MSG_Width-1:0]  rx_encoded_msg;
wire                     rx_msg_valid , o_PARAM_rx_end ;
wire [15:0]                 o_rx_parameters ;

// ── TX instantiation ──────────────────────────────────────────────────────────
PARAM_TX_fin #(.SB_MSG_Width(SB_MSG_Width)) u_param_tx
(
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_MBINIT_en             (i_PARAM_en),
    .i_sb_busy              (i_sb_busy),
    .i_falling_edge_busy    (i_falling_edge_busy),
    .i_sb_valid             (i_sb_valid),
    .i_decoded_sb_msg       (i_decoded_sb_msg),
    .i_resolved_parameters  (i_parameters),
    // register-file
    .i_rf_data_rate         (i_rf_data_rate),
    .i_rf_vswing            (i_rf_vswing),
    .i_rf_clk_mode          (i_rf_clk_mode),
    .i_rf_clk_phase         (i_rf_clk_phase),
    .i_rf_module_id         (i_rf_module_id),
    .i_rf_ucie_sx8          (i_rf_ucie_sx8),
    .i_rf_sfes              (i_rf_sfes),
    .i_rf_tarr              (i_rf_tarr),
    // outputs
    .o_encoded_SB_msg       (tx_encoded_msg),
    .o_msg_valid            (tx_msg_valid),
    .o_parameters           (o_tx_parameters),
    .o_final_max_data_rate  (o_final_max_data_rate_tx),
    .o_PARAM_tx_end         (o_PARAM_tx_end),
    .error_req              (o_error_req)
);

// ── RX instantiation ──────────────────────────────────────────────────────────
PARAM_RX_fin #(.SB_MSG_Width(SB_MSG_Width)) u_param_rx
(
    .i_clk                  (i_clk),
    .i_rst_n                (i_rst_n),
    .i_MBINIT_en            (i_PARAM_en),
    .i_sb_busy              (i_sb_busy),
    .i_falling_edge_busy    (i_falling_edge_busy),
    .i_sb_valid             (i_sb_valid),
    .i_decoded_sb_msg       (i_decoded_sb_msg),
    .i_module_parameters    (i_parameters),
    // register-file
    .i_rf_data_rate         (i_rf_data_rate),
    .i_rf_sfes              (i_rf_sfes),
    .i_rf_tarr              (i_rf_tarr),
    // outputs
    .o_encoded_SB_msg       (rx_encoded_msg),
    .o_msg_valid            (rx_msg_valid),
    .o_parameters           (o_rx_parameters),
    .o_module_vswing        (o_module_vswing),
    .o_module_clck_mode     (o_module_clk_mode),
    .o_module_clck_phase    (o_module_clk_phase),
    .o_final_max_data_rate  (o_final_max_data_rate_rx),
    .o_PARAM_rx_end         (o_PARAM_rx_end)
);

// ── Sideband mux: RX resp takes priority over TX req ─────────────────────────
// RX sends RESP after TX sends REQ, so in normal flow they do not overlap.
// Priority given to RX to make sure RESP is never lost if timing is tight.
always @(*) begin
    if (rx_msg_valid) begin
        o_encoded_SB_msg = rx_encoded_msg;
        o_msg_valid      = 1'b1;
        o_parameters = o_rx_parameters ;
    end else if (tx_msg_valid) begin
        o_encoded_SB_msg = tx_encoded_msg;
        o_msg_valid      = 1'b1;
        o_parameters = o_tx_parameters ;
    end else begin
        o_encoded_SB_msg = {SB_MSG_Width{1'b0}};
        o_msg_valid      = 1'b0;
        o_parameters = 'd0  ;
    end
end

// ── Combined end: PARAM state complete only when both TX and RX are done ──────
assign o_PARAM_END = o_PARAM_tx_end && o_PARAM_rx_end;

endmodule
