`include "axi/assign.svh"

module axi_cdc #(
    parameter type aw_chan_t  = logic,
    parameter type w_chan_t   = logic,
    parameter type b_chan_t   = logic,
    parameter type ar_chan_t  = logic,
    parameter type r_chan_t   = logic,
    parameter type axi_req_t  = logic,
    parameter type axi_resp_t = logic,

    parameter int unsigned LogDepth   = 1,
    parameter int unsigned SyncStages = 2
) (

    input  logic      src_clk_i,
    input  logic      src_rst_ni,
    input  axi_req_t  src_req_i,
    output axi_resp_t src_resp_o,

    input  logic      dst_clk_i,
    input  logic      dst_rst_ni,
    output axi_req_t  dst_req_o,
    input  axi_resp_t dst_resp_i
);

  aw_chan_t [2**LogDepth-1:0] async_data_aw_data;
  w_chan_t  [2**LogDepth-1:0] async_data_w_data;
  b_chan_t  [2**LogDepth-1:0] async_data_b_data;
  ar_chan_t [2**LogDepth-1:0] async_data_ar_data;
  r_chan_t  [2**LogDepth-1:0] async_data_r_data;
  logic [LogDepth:0]
      async_data_aw_wptr,
      async_data_aw_rptr,
      async_data_w_wptr,
      async_data_w_rptr,
      async_data_b_wptr,
      async_data_b_rptr,
      async_data_ar_wptr,
      async_data_ar_rptr,
      async_data_r_wptr,
      async_data_r_rptr;

  axi_cdc_src #(
      .aw_chan_t (aw_chan_t),
      .w_chan_t  (w_chan_t),
      .b_chan_t  (b_chan_t),
      .ar_chan_t (ar_chan_t),
      .r_chan_t  (r_chan_t),
      .axi_req_t (axi_req_t),
      .axi_resp_t(axi_resp_t),
      .LogDepth  (LogDepth),
      .SyncStages(SyncStages)
  ) i_axi_cdc_src (
      .src_clk_i,
      .src_rst_ni,
      .src_req_i,
      .src_resp_o,
      .async_data_master_aw_data_o(async_data_aw_data),
      .async_data_master_aw_wptr_o(async_data_aw_wptr),
      .async_data_master_aw_rptr_i(async_data_aw_rptr),
      .async_data_master_w_data_o (async_data_w_data),
      .async_data_master_w_wptr_o (async_data_w_wptr),
      .async_data_master_w_rptr_i (async_data_w_rptr),
      .async_data_master_b_data_i (async_data_b_data),
      .async_data_master_b_wptr_i (async_data_b_wptr),
      .async_data_master_b_rptr_o (async_data_b_rptr),
      .async_data_master_ar_data_o(async_data_ar_data),
      .async_data_master_ar_wptr_o(async_data_ar_wptr),
      .async_data_master_ar_rptr_i(async_data_ar_rptr),
      .async_data_master_r_data_i (async_data_r_data),
      .async_data_master_r_wptr_i (async_data_r_wptr),
      .async_data_master_r_rptr_o (async_data_r_rptr)
  );

  axi_cdc_dst #(
      .aw_chan_t (aw_chan_t),
      .w_chan_t  (w_chan_t),
      .b_chan_t  (b_chan_t),
      .ar_chan_t (ar_chan_t),
      .r_chan_t  (r_chan_t),
      .axi_req_t (axi_req_t),
      .axi_resp_t(axi_resp_t),
      .LogDepth  (LogDepth),
      .SyncStages(SyncStages)
  ) i_axi_cdc_dst (
      .dst_clk_i,
      .dst_rst_ni,
      .dst_req_o,
      .dst_resp_i,
      .async_data_slave_aw_wptr_i(async_data_aw_wptr),
      .async_data_slave_aw_rptr_o(async_data_aw_rptr),
      .async_data_slave_aw_data_i(async_data_aw_data),
      .async_data_slave_w_wptr_i (async_data_w_wptr),
      .async_data_slave_w_rptr_o (async_data_w_rptr),
      .async_data_slave_w_data_i (async_data_w_data),
      .async_data_slave_b_wptr_o (async_data_b_wptr),
      .async_data_slave_b_rptr_i (async_data_b_rptr),
      .async_data_slave_b_data_o (async_data_b_data),
      .async_data_slave_ar_wptr_i(async_data_ar_wptr),
      .async_data_slave_ar_rptr_o(async_data_ar_rptr),
      .async_data_slave_ar_data_i(async_data_ar_data),
      .async_data_slave_r_wptr_o (async_data_r_wptr),
      .async_data_slave_r_rptr_i (async_data_r_rptr),
      .async_data_slave_r_data_o (async_data_r_data)
  );

endmodule

