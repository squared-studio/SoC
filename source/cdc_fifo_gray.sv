`include "common_cells/registers.svh"

module cdc_fifo_gray #(

    parameter int unsigned WIDTH = 1,

    parameter type T = logic [WIDTH-1:0],

    parameter int LOG_DEPTH = 3,

    parameter int SYNC_STAGES = 2
) (
    input  logic src_rst_ni,
    input  logic src_clk_i,
    input  T     src_data_i,
    input  logic src_valid_i,
    output logic src_ready_o,

    input  logic dst_rst_ni,
    input  logic dst_clk_i,
    output T     dst_data_o,
    output logic dst_valid_o,
    input  logic dst_ready_i
);

  T [2**LOG_DEPTH-1:0] async_data;
  logic [LOG_DEPTH:0] async_wptr;
  logic [LOG_DEPTH:0] async_rptr;

  cdc_fifo_gray_src #(
      .T        (T),
      .LOG_DEPTH(LOG_DEPTH)
  ) i_src (
      .src_rst_ni,
      .src_clk_i,
      .src_data_i,
      .src_valid_i,
      .src_ready_o,

      .async_data_o(async_data),
      .async_wptr_o(async_wptr),
      .async_rptr_i(async_rptr)
  );

  cdc_fifo_gray_dst #(
      .T        (T),
      .LOG_DEPTH(LOG_DEPTH)
  ) i_dst (
      .dst_rst_ni,
      .dst_clk_i,
      .dst_data_o,
      .dst_valid_o,
      .dst_ready_i,

      .async_data_i(async_data),
      .async_wptr_i(async_wptr),
      .async_rptr_o(async_rptr)
  );

endmodule
