module stream_arbiter #(
    parameter type      DATA_T = logic,  // Vivado requires a default value for type parameters.
    parameter integer   N_INP
) (
    input  logic              clk_i,
    input  logic              rst_ni,

    input  DATA_T [N_INP-1:0] inp_data_i,
    input  logic  [N_INP-1:0] inp_valid_i,
    output logic  [N_INP-1:0] inp_ready_o,

    output DATA_T             oup_data_o,
    output logic              oup_valid_o,
    input  logic              oup_ready_i
);

  logic [$clog2(N_INP)-1:0] idx;

  rrarbiter #(
    .NUM_REQ  (N_INP),
    // Lock arbitration decision once the output is valid and until the handshake happens.
    .LOCK_IN  (1)
  ) i_arbiter (
    .clk_i    (clk_i),
    .rst_ni   (rst_ni),
    .flush_i  (1'b0),
    .en_i     (oup_ready_i),
    .req_i    (inp_valid_i),
    .ack_o    (inp_ready_o),
    // The `vld_o` port of `rrarbiter` combinatorially depends on `en_i`.  In the stream protocol,
    // a valid may not depend on a ready, so we drive `oup_valid_o` from the `inp_valid_i`s in (1)
    // and leave `vld_o` unconnected.
    .vld_o    (),
    .idx_o    (idx)
  );

  assign oup_valid_o = (|inp_valid_i); // (1), see reference above.
  assign oup_data_o = inp_data_i[idx];

endmodule
