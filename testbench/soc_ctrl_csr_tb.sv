`include "vip/simple_axi_m_driver.svh"

module soc_ctrl_csr_tb;

  import soc_pkg::NUM_CORE;
  import soc_pkg::XLEN;
  import soc_pkg::FB_DIV_WIDTH;
  import soc_pkg::TEMP_SENSOR_WIDTH;
  import soc_pkg::s_req_t;
  import soc_pkg::s_resp_t;

  logic                                                  clk_i;
  logic                                                  arst_ni;
  s_req_t                                                req_i;
  s_resp_t                                               resp_o;

  logic    [        NUM_CORE-1:0][             XLEN-1:0] boot_addr_vec_o;
  logic    [        NUM_CORE-1:0][             XLEN-1:0] hart_id_vec_o;
  logic    [        NUM_CORE-1:0]                        core_clk_en_o;
  logic    [        NUM_CORE-1:0]                        core_arst_o;
  logic    [        NUM_CORE-1:0][     FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o;
  logic    [        NUM_CORE-1:0]                        core_pll_locked_i;
  logic    [        NUM_CORE-1:0][     FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_i;
  logic    [        NUM_CORE-1:0][TEMP_SENSOR_WIDTH-1:0] core_temp_sensor_vec_i;

  logic    [    FB_DIV_WIDTH-1:0]                        ram_pll_fb_div_o;
  logic                                                  ram_pll_locked_i;
  logic    [    FB_DIV_WIDTH-1:0]                        ram_pll_fb_div_i;

  logic                                                  glob_arst_o;
  logic    [$clog2(NUM_CORE)-1:0]                        sys_pll_select_o;


  `SIMPLE_AXI_M_DRIVER(csr, clk_i, arst_ni, req_i, resp_o)

  soc_ctrl_csr #(
      .NUM_CORE         (NUM_CORE),
      .MEM_BASE         (0),
      .XLEN             (XLEN),
      .FB_DIV_WIDTH     (FB_DIV_WIDTH),
      .TEMP_SENSOR_WIDTH(TEMP_SENSOR_WIDTH),
      .NUM_GPR          (4),
      .req_t            (s_req_t),
      .resp_t           (s_resp_t)
  ) u_dut (
      .clk_i,
      .arst_ni,
      .req_i,
      .resp_o,

      .boot_addr_vec_o,
      .hart_id_vec_o,
      .core_clk_en_o,
      .core_arst_o,
      .core_pll_fb_div_vec_o,
      .core_pll_locked_i,
      .core_pll_fb_div_vec_i,
      .core_temp_sensor_vec_i,

      .ram_pll_fb_div_o,
      .ram_pll_locked_i,
      .ram_pll_fb_div_i,

      .glob_arst_o,
      .sys_pll_select_o,

      .grp_o()
  );


endmodule
