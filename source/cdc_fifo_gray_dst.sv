module cdc_fifo_gray_dst #(
    parameter type T = logic,
    parameter int LOG_DEPTH = 3,
    parameter int SYNC_STAGES = 2
) (
    input  logic dst_rst_ni,
    input  logic dst_clk_i,
    output T     dst_data_o,
    output logic dst_valid_o,
    input  logic dst_ready_i,

    input T [2**LOG_DEPTH-1:0] async_data_i,
    input logic [LOG_DEPTH:0] async_wptr_i,
    output logic [LOG_DEPTH:0] async_rptr_o
);

  localparam int PtrWidth = LOG_DEPTH + 1;
  localparam logic [PtrWidth-1:0] PtrEmpty = '0;

  T dst_data;
  logic [PtrWidth-1:0] rptr_q, rptr_d, rptr_bin, rptr_bin_d, rptr_next, wptr, wptr_bin;
  logic dst_valid, dst_ready;

  assign dst_data  = async_data_i[rptr_bin[LOG_DEPTH-1:0]];

  assign rptr_next = rptr_bin + 1;
  gray_to_binary #(PtrWidth) i_rptr_g2b (
      .A(rptr_q),
      .Z(rptr_bin)
  );
  binary_to_gray #(PtrWidth) i_rptr_b2g (
      .A(rptr_next),
      .Z(rptr_d)
  );
  `FFLARN(rptr_q, rptr_d, dst_valid & dst_ready, '0, dst_clk_i, dst_rst_ni)
  assign async_rptr_o = rptr_q;

  for (genvar i = 0; i < PtrWidth; i++) begin : gen_sync
    sync #(
        .STAGES(SYNC_STAGES)
    ) i_sync (
        .clk_i   (dst_clk_i),
        .rst_ni  (dst_rst_ni),
        .serial_i(async_wptr_i[i]),
        .serial_o(wptr[i])
    );
  end
  gray_to_binary #(PtrWidth) i_wptr_g2b (
      .A(wptr),
      .Z(wptr_bin)
  );

  assign dst_valid = ((wptr_bin ^ rptr_bin) != PtrEmpty);

  spill_register #(
      .T(T)
  ) i_spill_register (
      .clk_i  (dst_clk_i),
      .rst_ni (dst_rst_ni),
      .valid_i(dst_valid),
      .ready_o(dst_ready),
      .data_i (dst_data),
      .valid_o(dst_valid_o),
      .ready_i(dst_ready_i),
      .data_o (dst_data_o)
  );

endmodule
