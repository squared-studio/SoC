module axi_to_axi_lite #(
    parameter int unsigned AxiAddrWidth = 32'd0,
    parameter int unsigned AxiDataWidth = 32'd0,
    parameter int unsigned AxiIdWidth = 32'd0,
    parameter int unsigned AxiUserWidth = 32'd0,
    parameter int unsigned AxiMaxWriteTxns = 32'd0,
    parameter int unsigned AxiMaxReadTxns = 32'd0,
    parameter bit FullBW = 0,  // ID Queue in Full BW mode in axi_burst_splitter
    parameter bit FallThrough = 1'b1,  // FIFOs in Fall through mode in ID reflect
    parameter type full_req_t = logic,
    parameter type full_resp_t = logic,
    parameter type lite_req_t = logic,
    parameter type lite_resp_t = logic
) (
    input  logic       clk_i,       // Clock
    input  logic       rst_ni,      // Asynchronous reset active low
    input  logic       test_i,      // Testmode enable
    // slave port full AXI4+ATOP
    input  full_req_t  slv_req_i,
    output full_resp_t slv_resp_o,
    // master port AXI4-Lite
    output lite_req_t  mst_req_o,
    input  lite_resp_t mst_resp_i
);
  // full bus declarations
  full_req_t filtered_req, splitted_req;
  full_resp_t filtered_resp, splitted_resp;

  // atomics adapter so that atomics can be resolved
  axi_atop_filter #(
      .AxiIdWidth     (AxiIdWidth),
      .AxiMaxWriteTxns(AxiMaxWriteTxns),
      .axi_req_t      (full_req_t),
      .axi_resp_t     (full_resp_t)
  ) i_axi_atop_filter (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .slv_req_i (slv_req_i),
      .slv_resp_o(slv_resp_o),
      .mst_req_o (filtered_req),
      .mst_resp_i(filtered_resp)
  );

  // burst splitter so that the id reflect module has no burst accessing it
  axi_burst_splitter #(
      .MaxReadTxns (AxiMaxReadTxns),
      .MaxWriteTxns(AxiMaxWriteTxns),
      .FullBW      (FullBW),
      .AddrWidth   (AxiAddrWidth),
      .DataWidth   (AxiDataWidth),
      .IdWidth     (AxiIdWidth),
      .UserWidth   (AxiUserWidth),
      .axi_req_t   (full_req_t),
      .axi_resp_t  (full_resp_t)
  ) i_axi_burst_splitter (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .slv_req_i (filtered_req),
      .slv_resp_o(filtered_resp),
      .mst_req_o (splitted_req),
      .mst_resp_i(splitted_resp)
  );

  // ID reflect module handles the conversion from the full AXI to AXI lite on the wireing
  axi_to_axi_lite_id_reflect #(
      .AxiIdWidth     (AxiIdWidth),
      .AxiMaxWriteTxns(AxiMaxWriteTxns),
      .AxiMaxReadTxns (AxiMaxReadTxns),
      .FallThrough    (FallThrough),
      .full_req_t     (full_req_t),
      .full_resp_t    (full_resp_t),
      .lite_req_t     (lite_req_t),
      .lite_resp_t    (lite_resp_t)
  ) i_axi_to_axi_lite_id_reflect (
      .clk_i     (clk_i),
      .rst_ni    (rst_ni),
      .test_i    (test_i),
      .slv_req_i (splitted_req),
      .slv_resp_o(splitted_resp),
      .mst_req_o (mst_req_o),
      .mst_resp_i(mst_resp_i)
  );

endmodule
