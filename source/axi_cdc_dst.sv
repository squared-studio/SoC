`include "axi/assign.svh"
`include "axi/typedef.svh"

module axi_cdc_dst #(

    parameter int unsigned LogDepth = 1,

    parameter int unsigned SyncStages = 2,
    parameter type aw_chan_t = logic,
    parameter type w_chan_t = logic,
    parameter type b_chan_t = logic,
    parameter type ar_chan_t = logic,
    parameter type r_chan_t = logic,
    parameter type axi_req_t = logic,
    parameter type axi_resp_t = logic
) (

    input  aw_chan_t [2**LogDepth-1:0] async_data_slave_aw_data_i,
    input  logic     [     LogDepth:0] async_data_slave_aw_wptr_i,
    output logic     [     LogDepth:0] async_data_slave_aw_rptr_o,
    input  w_chan_t  [2**LogDepth-1:0] async_data_slave_w_data_i,
    input  logic     [     LogDepth:0] async_data_slave_w_wptr_i,
    output logic     [     LogDepth:0] async_data_slave_w_rptr_o,
    output b_chan_t  [2**LogDepth-1:0] async_data_slave_b_data_o,
    output logic     [     LogDepth:0] async_data_slave_b_wptr_o,
    input  logic     [     LogDepth:0] async_data_slave_b_rptr_i,
    input  ar_chan_t [2**LogDepth-1:0] async_data_slave_ar_data_i,
    input  logic     [     LogDepth:0] async_data_slave_ar_wptr_i,
    output logic     [     LogDepth:0] async_data_slave_ar_rptr_o,
    output r_chan_t  [2**LogDepth-1:0] async_data_slave_r_data_o,
    output logic     [     LogDepth:0] async_data_slave_r_wptr_o,
    input  logic     [     LogDepth:0] async_data_slave_r_rptr_i,

    input  logic      dst_clk_i,
    input  logic      dst_rst_ni,
    output axi_req_t  dst_req_o,
    input  axi_resp_t dst_resp_i
);

  cdc_fifo_gray_dst #(
      .T          (aw_chan_t),
      .LOG_DEPTH  (LogDepth),
      .SYNC_STAGES(SyncStages)
  ) i_cdc_fifo_gray_dst_aw (
      .async_data_i(async_data_slave_aw_data_i),
      .async_wptr_i(async_data_slave_aw_wptr_i),
      .async_rptr_o(async_data_slave_aw_rptr_o),
      .dst_clk_i,
      .dst_rst_ni,
      .dst_data_o  (dst_req_o.aw),
      .dst_valid_o (dst_req_o.aw_valid),
      .dst_ready_i (dst_resp_i.aw_ready)
  );

  cdc_fifo_gray_dst #(
      .T          (w_chan_t),
      .LOG_DEPTH  (LogDepth),
      .SYNC_STAGES(SyncStages)
  ) i_cdc_fifo_gray_dst_w (
      .async_data_i(async_data_slave_w_data_i),
      .async_wptr_i(async_data_slave_w_wptr_i),
      .async_rptr_o(async_data_slave_w_rptr_o),
      .dst_clk_i,
      .dst_rst_ni,
      .dst_data_o  (dst_req_o.w),
      .dst_valid_o (dst_req_o.w_valid),
      .dst_ready_i (dst_resp_i.w_ready)
  );

  cdc_fifo_gray_src #(
      .T          (b_chan_t),
      .LOG_DEPTH  (LogDepth),
      .SYNC_STAGES(SyncStages)
  ) i_cdc_fifo_gray_src_b (
      .src_clk_i   (dst_clk_i),
      .src_rst_ni  (dst_rst_ni),
      .src_data_i  (dst_resp_i.b),
      .src_valid_i (dst_resp_i.b_valid),
      .src_ready_o (dst_req_o.b_ready),
      .async_data_o(async_data_slave_b_data_o),
      .async_wptr_o(async_data_slave_b_wptr_o),
      .async_rptr_i(async_data_slave_b_rptr_i)
  );

  cdc_fifo_gray_dst #(
      .T          (ar_chan_t),
      .LOG_DEPTH  (LogDepth),
      .SYNC_STAGES(SyncStages)
  ) i_cdc_fifo_gray_dst_ar (
      .dst_clk_i,
      .dst_rst_ni,
      .dst_data_o  (dst_req_o.ar),
      .dst_valid_o (dst_req_o.ar_valid),
      .dst_ready_i (dst_resp_i.ar_ready),
      .async_data_i(async_data_slave_ar_data_i),
      .async_wptr_i(async_data_slave_ar_wptr_i),
      .async_rptr_o(async_data_slave_ar_rptr_o)
  );

  cdc_fifo_gray_src #(
      .T          (r_chan_t),
      .LOG_DEPTH  (LogDepth),
      .SYNC_STAGES(SyncStages)
  ) i_cdc_fifo_gray_src_r (
      .src_clk_i   (dst_clk_i),
      .src_rst_ni  (dst_rst_ni),
      .src_data_i  (dst_resp_i.r),
      .src_valid_i (dst_resp_i.r_valid),
      .src_ready_o (dst_req_o.r_ready),
      .async_data_o(async_data_slave_r_data_o),
      .async_wptr_o(async_data_slave_r_wptr_o),
      .async_rptr_i(async_data_slave_r_rptr_i)
  );

endmodule

