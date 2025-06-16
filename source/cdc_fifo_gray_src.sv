module cdc_fifo_gray_src #(
    parameter type T = logic,
    parameter int LOG_DEPTH = 3,
    parameter int SYNC_STAGES = 2
) (
    input  logic src_rst_ni,
    input  logic src_clk_i,
    input  T     src_data_i,
    input  logic src_valid_i,
    output logic src_ready_o,

    output T [2**LOG_DEPTH-1:0] async_data_o,
    output logic [LOG_DEPTH:0] async_wptr_o,
    input logic [LOG_DEPTH:0] async_rptr_i
);

  localparam int PtrWidth = LOG_DEPTH + 1;
  localparam logic [PtrWidth-1:0] PtrFull = (1 << LOG_DEPTH);

  T [2**LOG_DEPTH-1:0] data_q;
  logic [PtrWidth-1:0] wptr_q, wptr_d, wptr_bin, wptr_next, rptr, rptr_bin;

  assign async_data_o = data_q;
  for (genvar i = 0; i < 2 ** LOG_DEPTH; i++) begin : gen_word
    `FFLNR(data_q[i], src_data_i, src_valid_i & src_ready_o & (wptr_bin[LOG_DEPTH-1:0] == i),
           src_clk_i)
  end

  for (genvar i = 0; i < PtrWidth; i++) begin : gen_sync
    sync #(
        .STAGES(SYNC_STAGES)
    ) i_sync (
        .clk_i   (src_clk_i),
        .rst_ni  (src_rst_ni),
        .serial_i(async_rptr_i[i]),
        .serial_o(rptr[i])
    );
  end
  gray_to_binary #(PtrWidth) i_rptr_g2b (
      .A(rptr),
      .Z(rptr_bin)
  );

  assign wptr_next = wptr_bin + 1;
  gray_to_binary #(PtrWidth) i_wptr_g2b (
      .A(wptr_q),
      .Z(wptr_bin)
  );
  binary_to_gray #(PtrWidth) i_wptr_b2g (
      .A(wptr_next),
      .Z(wptr_d)
  );
  `FFLARN(wptr_q, wptr_d, src_valid_i & src_ready_o, '0, src_clk_i, src_rst_ni)
  assign async_wptr_o = wptr_q;

  assign src_ready_o  = ((wptr_bin ^ rptr_bin) != PtrFull);

endmodule
