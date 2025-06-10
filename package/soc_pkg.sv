package soc_pkg;

  parameter int NUM_CORE = 4;
  parameter int NUM_MASTERS = NUM_CORE + 1;
  parameter int NUM_SLAVES = 1;

  localparam int NumXbarRules = 1;
  localparam axi_pkg::xbar_rule_64_t [NumXbarRules-1:0] XbarRule = '{
      '{idx: 0, start_addr: 'h40000000, end_addr: 'h4007FFFF}
  };

  parameter longint DM_BASE_ADDR = '0;

  parameter longint ROM_BASE = 'h7FFF_0000;
  parameter longint ROM_SIZE = 16;

  parameter longint RAM_BASE = '0;
  parameter longint RAM_SIZE = 31;

  parameter longint CACHEABLE_ADDR_START = 'h8000_0000;

  parameter int NOC_M_ID_WIDTH = ariane_axi_pkg::IdWidth;
  parameter int NOC_S_ID_WIDTH = NOC_M_ID_WIDTH + $clog2(NUM_MASTERS);
  parameter int NOC_ADDR_WIDTH = ariane_axi_pkg::AddrWidth;
  parameter int NOC_DATA_WIDTH = ariane_axi_pkg::DataWidth;
  parameter int NOC_USER_WIDTH = ariane_axi_pkg::UserWidth;

  parameter type m_aw_chan_t = ariane_axi_pkg::m_aw_chan_t;
  parameter type m_w_chan_t = ariane_axi_pkg::m_w_chan_t;
  parameter type m_b_chan_t = ariane_axi_pkg::m_b_chan_t;
  parameter type m_ar_chan_t = ariane_axi_pkg::m_ar_chan_t;
  parameter type m_r_chan_t = ariane_axi_pkg::m_r_chan_t;
  parameter type m_req_t = ariane_axi_pkg::m_req_t;
  parameter type m_resp_t = ariane_axi_pkg::m_resp_t;

  `AXI_TYPEDEF_ALL(s, logic [NOC_ADDR_WIDTH-1:0], logic [NOC_S_ID_WIDTH-1:0],
                   logic [NOC_DATA_WIDTH-1:0], logic [NOC_DATA_WIDTH/8-1:0],
                   logic [NOC_USER_WIDTH-1:0])

endpackage
