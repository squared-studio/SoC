/*
*           CORE0    CORE1    CORE2    CORE3   ExtMaster
*             |        |        |        |         |
*         *----------------------------------------------*
*         |                                              |
*         |                     XBAR                     |
*         |                                              |
*         *----------------------------------------------*
*                           |        |
*                        soc_ctrl  ExtRam
*/

module soc (
    input logic glob_arst_ni,
    input logic xtal_i,

    output logic temp_ext_m_clk_o,
    output logic temp_ext_m_arst_no,

    input  soc_pkg::m_req_t  ext_m_req_i,
    output soc_pkg::m_resp_t ext_m_resp_o,

    output logic             ram_arst_no,
    output logic             ram_clk_o,
    output soc_pkg::s_req_t  ram_req_o,
    input  soc_pkg::s_resp_t ram_resp_i
);

  soc_pkg::m_req_t [soc_pkg::NUM_MASTERS-1:0] m_req;
  soc_pkg::m_resp_t [soc_pkg::NUM_MASTERS-1:0] m_resp;
  soc_pkg::s_req_t [soc_pkg::NUM_SLAVES-1:0] s_req;
  soc_pkg::s_resp_t [soc_pkg::NUM_SLAVES-1:0] s_resp;

  soc_pkg::m_req_t [soc_pkg::NUM_CORE-1:0] core_req;
  soc_pkg::m_resp_t [soc_pkg::NUM_CORE-1:0] core_resp;

  logic sys_clk;
  logic sys_arst_ni;

  logic [soc_pkg::NUM_CORE-1:0][soc_pkg::XLEN-1:0] boot_addr_vec;
  logic [soc_pkg::NUM_CORE-1:0][soc_pkg::XLEN-1:0] hart_id_vec;

  logic [soc_pkg::NUM_CORE-1:0] core_clk_vec;
  logic [soc_pkg::NUM_CORE-1:0] core_arst_vec_n;

  assign temp_ext_m_clk_o   = sys_clk;
  assign temp_ext_m_arst_no = sys_arst_ni;

  axi_cdc #(
      .aw_chan_t (soc_pkg::m_aw_chan_t),
      .w_chan_t  (soc_pkg::m_w_chan_t),
      .b_chan_t  (soc_pkg::m_b_chan_t),
      .ar_chan_t (soc_pkg::m_ar_chan_t),
      .r_chan_t  (soc_pkg::m_r_chan_t),
      .axi_req_t (soc_pkg::m_req_t),
      .axi_resp_t(soc_pkg::m_resp_t)
  ) u_cdc_ext_m_xbar (
      .src_clk_i (temp_ext_m_clk_o),
      .src_rst_ni(sys_arst_ni),
      .src_req_i (ext_m_req_i),
      .src_resp_o(ext_m_resp_o),
      .dst_clk_i (sys_clk),
      .dst_rst_ni(sys_arst_ni),
      .dst_req_o (m_req[4]),
      .dst_resp_i(m_resp[4])
  );

  axi_cdc #(
      .aw_chan_t (soc_pkg::s_aw_chan_t),
      .w_chan_t  (soc_pkg::s_w_chan_t),
      .b_chan_t  (soc_pkg::s_b_chan_t),
      .ar_chan_t (soc_pkg::s_ar_chan_t),
      .r_chan_t  (soc_pkg::s_r_chan_t),
      .axi_req_t (soc_pkg::s_req_t),
      .axi_resp_t(soc_pkg::s_resp_t)
  ) u_cdc_xbar_ram (
      .src_clk_i (sys_clk),
      .src_rst_ni(sys_arst_ni),
      .src_req_i (s_req[0]),
      .src_resp_o(s_resp[0]),
      .dst_clk_i (ram_clk_o),
      .dst_rst_ni(sys_arst_ni),
      .dst_req_o (ram_req_o),
      .dst_resp_i(ram_resp_i)
  );

  axi_xbar #(
      .Cfg          (soc_pkg::XbarConfig),
      .ATOPs        ('0),
      .Connectivity ('1),
      .slv_aw_chan_t(soc_pkg::m_aw_chan_t),
      .mst_aw_chan_t(soc_pkg::s_aw_chan_t),
      .w_chan_t     (soc_pkg::m_w_chan_t),
      .slv_b_chan_t (soc_pkg::m_b_chan_t),
      .mst_b_chan_t (soc_pkg::s_b_chan_t),
      .slv_ar_chan_t(soc_pkg::m_ar_chan_t),
      .mst_ar_chan_t(soc_pkg::s_ar_chan_t),
      .slv_r_chan_t (soc_pkg::m_r_chan_t),
      .mst_r_chan_t (soc_pkg::s_r_chan_t),
      .slv_req_t    (soc_pkg::m_req_t),
      .slv_resp_t   (soc_pkg::m_resp_t),
      .mst_req_t    (soc_pkg::s_req_t),
      .mst_resp_t   (soc_pkg::s_resp_t),
      .rule_t       (axi_pkg::xbar_rule_64_t)
  ) u_xbar (
      .clk_i(sys_clk),
      .rst_ni(sys_arst_ni),
      .test_i('0),
      .slv_ports_req_i(m_req),
      .slv_ports_resp_o(m_resp),
      .mst_ports_req_o(s_req),
      .mst_ports_resp_i(s_resp),
      .addr_map_i(soc_pkg::XbarRule),
      .en_default_mst_port_i('1),
      .default_mst_port_i('0)
  );

  for (genvar core = 0; core < soc_pkg::NUM_CORE; core++) begin : g_cores
    ariane #(
        .DmBaseAddress(soc_pkg::RAM_BASE),
        .CachedAddrBeg(soc_pkg::RAM_BASE)
    ) u_core_0 (
        .clk_i(core_clk_vec[core]),
        .rst_ni(core_arst_vec_n[core]),
        .boot_addr_i(boot_addr_vec[core]),
        .hart_id_i(hart_id_vec[core]),
        .irq_i('0),  // TODO
        .ipi_i('0),  // TODO
        .time_irq_i('0),  // TODO
        .debug_req_i('0),  // TODO
        .axi_req_o(core_req[core]),
        .axi_resp_i(core_resp[core])
    );
  end

  for (genvar core = 0; core < soc_pkg::NUM_CORE; core++) begin : g_core_cdc
    axi_cdc #(
        .aw_chan_t (soc_pkg::m_aw_chan_t),
        .w_chan_t  (soc_pkg::m_w_chan_t),
        .b_chan_t  (soc_pkg::m_b_chan_t),
        .ar_chan_t (soc_pkg::m_ar_chan_t),
        .r_chan_t  (soc_pkg::m_r_chan_t),
        .axi_req_t (soc_pkg::m_req_t),
        .axi_resp_t(soc_pkg::m_resp_t)
    ) u_cdc_core_xbar (
        .src_clk_i (core_clk_vec[core]),
        .src_rst_ni(sys_arst_ni),
        .src_req_i (core_req[core]),
        .src_resp_o(core_resp[core]),
        .dst_clk_i (sys_clk),
        .dst_rst_ni(sys_arst_ni),
        .dst_req_o (m_req[core]),
        .dst_resp_i(m_resp[core])
    );
  end

  soc_ctrl #(
      .NUM_CORE         (soc_pkg::NUM_CORE),
      .MEM_BASE         (soc_pkg::SOC_CTRL_BASE),
      .XLEN             (soc_pkg::XLEN),
      .FB_DIV_WIDTH     (soc_pkg::FB_DIV_WIDTH),
      .TEMP_SENSOR_WIDTH(soc_pkg::TEMP_SENSOR_WIDTH),
      .req_t            (soc_pkg::s_req_t),
      .resp_t           (soc_pkg::s_resp_t)
  ) u_soc_ctrl (
      .xtal_i,
      .sys_clk_o(sys_clk),
      .req_i(s_req[1]),
      .resp_o(s_resp[1]),
      .boot_addr_vec_o(boot_addr_vec),
      .hart_id_vec_o(hart_id_vec),
      .core_clk_vec_o(core_clk_vec),
      .core_arst_vec_no(core_arst_vec_n),
      .core_temp_sensor_vec_i('0),  // TODO
      .ram_clk_o,
      .ram_arst_no,
      .glob_arst_ni,
      .glob_arst_no(sys_arst_ni)
  );

endmodule
