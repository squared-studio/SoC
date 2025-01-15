module ariane_tb;

  logic                     clk_i;
  logic                     rst_ni;
  // Core ID, Cluster ID and boot address are considered more or less static
  logic              [63:0] boot_addr_i;  // reset boot address
  logic              [63:0] hart_id_i;  // hart id in a multicore environment (reflected in a CSR)

  // Interrupt inputs
  logic              [ 1:0] irq_i;  // level sensitive IR lines, mip & sip (async)
  logic                     ipi_i;  // inter-processor interrupts (async)
  // Timer facilities
  logic                     time_irq_i;  // timer interrupt in (async)
  logic                     debug_req_i;  // debug request (async)

  // memory side, AXI Master
  ariane_axi_pkg::m_req_t         axi_req_o;
  ariane_axi_pkg::m_resp_t        axi_resp_i;

  ariane #(
      .DmBaseAddress(soc_pkg::DM_BASE_ADDR),
      .CachedAddrBeg(soc_pkg::CACHEABLE_ADDR_START)
  ) u_core (
      .clk_i,
      .rst_ni,
      .boot_addr_i,
      .hart_id_i,
      .irq_i,
      .ipi_i,
      .time_irq_i,
      .debug_req_i,
      .axi_req_o,
      .axi_resp_i
  );

endmodule
