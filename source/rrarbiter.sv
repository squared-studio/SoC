module rrarbiter #(
  parameter int unsigned NUM_REQ = 13,
  parameter int unsigned LOCK_IN = 0
) (
  input logic                         clk_i,
  input logic                         rst_ni,

  input logic                         flush_i, // clears the fsm and control signal registers
  input logic                         en_i,    // arbiter enable
  input logic [NUM_REQ-1:0]           req_i,   // request signals

  output logic [NUM_REQ-1:0]          ack_o,   // acknowledge signals
  output logic                        vld_o,   // request ack'ed
  output logic [$clog2(NUM_REQ)-1:0]  idx_o    // idx output
);

  localparam SEL_WIDTH = $clog2(NUM_REQ);

  logic [SEL_WIDTH-1:0] arb_sel_d, arb_sel_q;
  logic [SEL_WIDTH-1:0] arb_sel_lock_d, arb_sel_lock_q;


  // only used in case of more than 2 requesters
  logic [NUM_REQ-1:0] mask_lut[NUM_REQ-1:0];
  logic [NUM_REQ-1:0] mask;
  logic [NUM_REQ-1:0] masked_lower;
  logic [NUM_REQ-1:0] masked_upper;
  logic [SEL_WIDTH-1:0] lower_idx;
  logic [SEL_WIDTH-1:0] upper_idx;
  logic [SEL_WIDTH-1:0] next_idx;
  logic no_lower_ones;
  logic lock_d, lock_q;

  // shared
  assign idx_o          = arb_sel_d;
  assign vld_o          = (|req_i) & en_i;

  if (LOCK_IN > 0) begin : g_lock_in
    // latch decision in case we got at least one req and no acknowledge
    assign lock_d         = (|req_i) & ~en_i;
    assign arb_sel_lock_d = arb_sel_d;
  end else begin
    // disable
    assign lock_d         = '0;
    assign arb_sel_lock_d = '0;
  end

  // only 2 input requesters
  if (NUM_REQ == 2 && !LOCK_IN) begin : g_rrlogic

    assign arb_sel_d = (( arb_sel_q) | (~arb_sel_q & ~req_i[0])) & req_i[1];
    assign ack_o[0]  = ((~arb_sel_q) | ( arb_sel_q & ~req_i[1])) & req_i[0] & en_i;
    assign ack_o[1]  = arb_sel_d                                            & en_i;

  end else begin

    // this mask is used to mask the incoming req vector
    // depending on the index of the last served index
    assign mask = mask_lut[arb_sel_q];

    // get index from masked vectors
    lzc #(
        .WIDTH ( NUM_REQ )
    ) i_lower_ff1 (
        .in_i    ( masked_lower  ),
        .cnt_o   ( lower_idx     ),
        .empty_o ( no_lower_ones )
    );

    lzc #(
        .WIDTH ( NUM_REQ )
    ) i_upper_ff1 (
        .in_i    ( masked_upper  ),
        .cnt_o   ( upper_idx     ),
        .empty_o (               )
    );

    // wrap around
    assign next_idx   = (no_lower_ones)      ? upper_idx      :
                                               lower_idx;
    assign arb_sel_d  = (lock_q)             ? arb_sel_lock_q :
                        (next_idx < NUM_REQ) ? next_idx       :
                                               unsigned'(NUM_REQ-1);
  end

  for (genvar k=0; (k < NUM_REQ) && (NUM_REQ > 2 || LOCK_IN); k++) begin : g_mask
    assign mask_lut[k]     = unsigned'(2**(k+1)-1);
    assign masked_lower[k] = (~mask[k]) & req_i[k];
    assign masked_upper[k] = mask[k]    & req_i[k];
    assign ack_o[k]        = ((arb_sel_d == k) && vld_o );
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin : p_regs
    if(~rst_ni) begin
      arb_sel_q      <= '0;
      lock_q         <= 1'b0;
      arb_sel_lock_q <= '0;
    end else begin
      if (flush_i) begin
        arb_sel_q      <= '0;
        lock_q         <= 1'b0;
        arb_sel_lock_q <= '0;
      end else begin
        lock_q         <= lock_d;
        arb_sel_lock_q <= arb_sel_lock_d;

        if (vld_o) begin
          arb_sel_q    <= arb_sel_d;
        end
      end
    end
  end

endmodule : rrarbiter



