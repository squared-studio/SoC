`include "axi/assign.svh"
`include "axi/typedef.svh"
module axi_to_axi_lite_intf #(

  parameter int unsigned AXI_ADDR_WIDTH     = 32'd0,
  parameter int unsigned AXI_DATA_WIDTH     = 32'd0,
  parameter int unsigned AXI_ID_WIDTH       = 32'd0,
  parameter int unsigned AXI_USER_WIDTH     = 32'd0,

  parameter int unsigned AXI_MAX_WRITE_TXNS = 32'd1,

  parameter int unsigned AXI_MAX_READ_TXNS  = 32'd1,
  parameter bit          FALL_THROUGH       = 1'b1,
  parameter bit          FULL_BW            = 0
) (
  input logic     clk_i,
  input logic     rst_ni,
  input logic     testmode_i,
  AXI_BUS.Slave   slv,
  AXI_LITE.Master mst
);
  typedef logic [AXI_ADDR_WIDTH-1:0]   addr_t;
  typedef logic [AXI_DATA_WIDTH-1:0]   data_t;
  typedef logic [AXI_ID_WIDTH-1:0]       id_t;
  typedef logic [AXI_DATA_WIDTH/8-1:0] strb_t;
  typedef logic [AXI_USER_WIDTH-1:0]   user_t;

  `AXI_TYPEDEF_AW_CHAN_T(full_aw_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_W_CHAN_T(full_w_chan_t, data_t, strb_t, user_t)
  `AXI_TYPEDEF_B_CHAN_T(full_b_chan_t, id_t, user_t)
  `AXI_TYPEDEF_AR_CHAN_T(full_ar_chan_t, addr_t, id_t, user_t)
  `AXI_TYPEDEF_R_CHAN_T(full_r_chan_t, data_t, id_t, user_t)
  `AXI_TYPEDEF_REQ_T(full_req_t, full_aw_chan_t, full_w_chan_t, full_ar_chan_t)
  `AXI_TYPEDEF_RESP_T(full_resp_t, full_b_chan_t, full_r_chan_t)

  `AXI_LITE_TYPEDEF_AW_CHAN_T(lite_aw_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_W_CHAN_T(lite_w_chan_t, data_t, strb_t)
  `AXI_LITE_TYPEDEF_B_CHAN_T(lite_b_chan_t)
  `AXI_LITE_TYPEDEF_AR_CHAN_T(lite_ar_chan_t, addr_t)
  `AXI_LITE_TYPEDEF_R_CHAN_T (lite_r_chan_t, data_t)
  `AXI_LITE_TYPEDEF_REQ_T(lite_req_t, lite_aw_chan_t, lite_w_chan_t, lite_ar_chan_t)
  `AXI_LITE_TYPEDEF_RESP_T(lite_resp_t, lite_b_chan_t, lite_r_chan_t)

  full_req_t  full_req;
  full_resp_t full_resp;
  lite_req_t  lite_req;
  lite_resp_t lite_resp;

  `AXI_ASSIGN_TO_REQ(full_req, slv)
  `AXI_ASSIGN_FROM_RESP(slv, full_resp)

  `AXI_LITE_ASSIGN_FROM_REQ(mst, lite_req)
  `AXI_LITE_ASSIGN_TO_RESP(lite_resp, mst)

  axi_to_axi_lite #(
    .AxiAddrWidth    ( AXI_ADDR_WIDTH     ),
    .AxiDataWidth    ( AXI_DATA_WIDTH     ),
    .AxiIdWidth      ( AXI_ID_WIDTH       ),
    .AxiUserWidth    ( AXI_USER_WIDTH     ),
    .AxiMaxWriteTxns ( AXI_MAX_WRITE_TXNS ),
    .AxiMaxReadTxns  ( AXI_MAX_READ_TXNS  ),
    .FallThrough     ( FALL_THROUGH       ),
    .FullBW          ( FULL_BW            ),
    .full_req_t      ( full_req_t         ),
    .full_resp_t     ( full_resp_t        ),
    .lite_req_t      ( lite_req_t         ),
    .lite_resp_t     ( lite_resp_t        )
  ) i_axi_to_axi_lite (
    .clk_i      ( clk_i      ),
    .rst_ni     ( rst_ni     ),
    .test_i     ( testmode_i ),

    .slv_req_i  ( full_req   ),
    .slv_resp_o ( full_resp  ),

    .mst_req_o  ( lite_req   ),
    .mst_resp_i ( lite_resp  )
  );
endmodule
