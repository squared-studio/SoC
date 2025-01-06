`include "rvfi_types.svh"
`include "cvxif_types.svh"

module rr_arb_tree_wrapper;
  localparam config_pkg::cva6_cfg_t CVA6Cfg = build_config_pkg::build_config(
      cva6_config_pkg::cva6_cfg
  );

  localparam int unsigned NumIn      = 64;
  localparam int unsigned DataWidth  = 64;
  localparam type         DataType   = logic [DataWidth-1:0];
  localparam bit          ExtPrio    = 1'b0;
  localparam bit          AxiVldRdy  = 1'b0;
  localparam bit          LockIn     = 1'b0;
  localparam bit          FairArb    = 1'b1;
  localparam int unsigned IdxWidth   = (NumIn > 32'd1) ? unsigned'($clog2(NumIn)) : 32'd1;
  localparam type         idx_t      = logic [IdxWidth-1:0];

  logic                clk_i;
  logic                rst_ni;
  logic                flush_i;
  idx_t                rr_i;
  logic    [NumIn-1:0] req_i;
  logic    [NumIn-1:0] gnt_o;
  DataType [NumIn-1:0] data_i;
  logic                req_o;
  logic                gnt_i;
  DataType             data_o;
  idx_t                idx_o;

  rr_arb_tree #(
      .NumIn(CVA6Cfg.NrCommitPorts),
      .DataWidth(DataWidth)
  ) i_rr_arb_tree (
      .clk_i  ,
      .rst_ni ,
      .flush_i(flush_i),
      .rr_i   (rr_i),
      .req_i  (req_i),
      .gnt_o  (gnt_o),
      .data_i (data_i),
      .gnt_i  (gnt_i),
      .req_o  (req_o),
      .data_o (data_o),
      .idx_o  (idx_o)
  );

endmodule
