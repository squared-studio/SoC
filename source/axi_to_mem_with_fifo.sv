`include "axi/typedef.svh"

module axi_to_mem_with_fifo
  import axi_pkg::atop_t;
#(
    parameter  type         req_t    = soc_pkg::s_req_t,
    parameter  type         resp_t   = soc_pkg::s_resp_t,
    parameter  logic [63:0] MEM_BASE = 0,
    parameter  int          MEM_SIZE = 0,
    parameter  int          MEM_DW   = 8,
    localparam int          MEM_AW   = MEM_SIZE - $clog2(MEM_DW / 8)
) (
    input logic clk_i,
    input logic arst_ni,

    input  req_t  req_i,
    output resp_t resp_o,

    output logic                mem_req_o,
    output logic                mem_we_o,
    output logic [  MEM_AW-1:0] mem_addr_o,
    output logic [  MEM_DW-1:0] mem_wdata_o,
    output logic [MEM_DW/8-1:0] mem_strb_o,
    input  logic                mem_rvalid_i,
    input  logic [  MEM_DW-1:0] mem_rdata_i
);

  localparam int IW = $bits(req_i.aw.id);
  localparam int AW = $bits(req_i.aw.addr);
  localparam int DW = $bits(req_i.w.data);
  localparam int UW = $bits(req_i.aw.user);


  `AXI_TYPEDEF_ALL(axi, logic[AW-1:0], logic[IW-1:0], logic[DW-1:0], logic[DW/8-1:0], logic[UW-1:0])


  req_t           intr_req_i;
  resp_t          intr_resp_o;

  logic           mem_req;

  logic  [AW-1:0] addr_out;
  logic  [AW-1:0] addr_tmp;

  atop_t          mem_atop;  // TODO

  axi_fifo #(
      .Depth      (2),
      .FallThrough('0),
      .aw_chan_t  (axi_aw_chan_t),
      .w_chan_t   (axi_w_chan_t),
      .b_chan_t   (axi_b_chan_t),
      .ar_chan_t  (axi_ar_chan_t),
      .r_chan_t   (axi_r_chan_t),
      .axi_req_t  (req_t),
      .axi_resp_t (resp_t)
  ) u_fifo (
      .clk_i     (clk_i),
      .rst_ni    (arst_ni),
      .test_i    ('0),
      .slv_req_i (req_i),
      .slv_resp_o(resp_o),
      .mst_req_o (intr_req_i),
      .mst_resp_i(intr_resp_o)
  );

  axi_to_mem #(
      .axi_req_t   (req_t),
      .axi_resp_t  (resp_t),
      .AddrWidth   (AW),
      .DataWidth   (DW),
      .IdWidth     (IW),
      .NumBanks    (1),
      .BufDepth    (1),
      .HideStrb    (0),
      .OutFifoDepth(1)
  ) i_converter (
      .clk_i       (clk_i),
      .rst_ni      (arst_ni),
      .busy_o      (),
      .axi_req_i   (intr_req_i),
      .axi_resp_o  (intr_resp_o),
      .mem_req_o   (mem_req_o),
      .mem_gnt_i   ('1),
      .mem_addr_o  (addr_out),
      .mem_wdata_o (mem_wdata_o),
      .mem_strb_o  (mem_strb_o),
      .mem_atop_o  (mem_atop),
      .mem_we_o    (mem_we_o),
      .mem_rvalid_i(mem_rvalid_i),
      .mem_rdata_i (mem_rdata_i)
  );

  always_comb begin
    addr_tmp   = addr_out - MEM_BASE;
    mem_addr_o = addr_tmp[MEM_SIZE-1:$clog2(DW/8)];
  end

`ifdef SIMULATION
  initial begin
    if (MEM_DW !== DW) $fatal(1, "Memory Data Width does not Match with AXI Data Width..!");
    if (MEM_SIZE < $clog2(DW / 8)) $fatal(1, "Memory Size is less than AXI Data Width..!");
  end
`endif

endmodule
