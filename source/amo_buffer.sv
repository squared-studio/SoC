module amo_buffer (
    // Clock
    input logic clk_i,
    // Asynchronous reset active low
    input logic rst_ni,
    // pipeline flush
    input logic flush_i,

    // AMO is valid
    input  logic                    valid_i,
    // AMO unit is ready
    output logic                    ready_o,
    // AMO Operation
    input  ariane_pkg::amo_t        amo_op_i,
    // physical address of store which needs to be placed in the queue
    input  logic             [63:0] paddr_i,
    // data which is placed in the queue
    input  logic             [63:0] data_i,
    // type of request we are making (e.g.: bytes to write)
    input  logic             [ 1:0] data_size_i,

    // D cache request to cache subsytem
    output ariane_pkg::amo_req_t  amo_req_o,
    // D cache response from cache subsystem
    input  ariane_pkg::amo_resp_t amo_resp_i,

    // We have a vaild AMO in the commit stage
    input logic amo_valid_commit_i,
    // there is currently no store pending anymore
    input logic no_st_pending_i
);
  logic flush_amo_buffer;
  logic amo_valid;

  typedef struct packed {
    ariane_pkg::amo_t op;
    logic [63:0]      paddr;
    logic [63:0]      data;
    logic [1:0]       size;
  } amo_op_t;

  amo_op_t amo_data_in, amo_data_out;

  // validate this request as soon as all stores have drained and the AMO is in the commit stage
  assign amo_req_o.req = no_st_pending_i & amo_valid_commit_i & amo_valid;
  assign amo_req_o.amo_op = amo_data_out.op;
  assign amo_req_o.size = amo_data_out.size;
  assign amo_req_o.operand_a = amo_data_out.paddr;
  assign amo_req_o.operand_b = amo_data_out.data;

  assign amo_data_in.op = amo_op_i;
  assign amo_data_in.data = data_i;
  assign amo_data_in.paddr = paddr_i;
  assign amo_data_in.size = data_size_i;

  // only flush if we are currently not committing the AMO
  // e.g.: it is not speculative anymore
  assign flush_amo_buffer = flush_i & !amo_valid_commit_i;

  fifo_v2 #(
      .DEPTH       (1),
      .ALM_EMPTY_TH(0),
      .ALM_FULL_TH (0),
      .dtype       (amo_op_t)
  ) i_amo_fifo (
      .clk_i      (clk_i),
      .rst_ni     (rst_ni),
      .flush_i    (flush_amo_buffer),
      .testmode_i (1'b0),
      .full_o     (amo_valid),
      .empty_o    (ready_o),
      .alm_full_o (),                  // left open
      .alm_empty_o(),                  // left open
      .data_i     (amo_data_in),
      .push_i     (valid_i),
      .data_o     (amo_data_out),
      .pop_i      (amo_resp_i.ack)
  );

endmodule
