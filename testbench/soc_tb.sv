`include "vip/simple_axi_m_driver.svh"

module soc_tb;

  // Display messages at the start and end of the test
  initial $display("\033[7;38m---------------------- TEST STARTED ----------------------\033[0m");
  final $display("\033[7;38m----------------------- TEST ENDED -----------------------\033[0m");

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  import soc_pkg::m_req_t;
  import soc_pkg::m_resp_t;
  import soc_pkg::s_req_t;
  import soc_pkg::s_resp_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic    glob_arst_ni;
  logic    xtal_i;
  m_req_t  ext_m_req_i;
  m_resp_t ext_m_resp_o;

  logic    ram_arst_no;
  logic    ram_clk_o;
  s_req_t  ram_req_o;
  s_resp_t ram_resp_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INSTANCIATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  soc u_soc (
      .glob_arst_ni,
      .xtal_i,
      .ext_m_req_i,
      .ext_m_resp_o,
      .ram_arst_no,
      .ram_clk_o,
      .ram_req_o,
      .ram_resp_i
  );

  axi_ram #(
      .MEM_BASE(0),
      .MEM_SIZE(32),
      .req_t   (s_req_t),
      .resp_t  (s_resp_t)
  ) u_axi_ram (
      .arst_ni(ram_arst_no),
      .clk_i  (ram_clk_o),
      .req_i  (ram_req_o),
      .resp_o (ram_resp_i)
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset(input realtime duration = 100ns);
    #(duration / 10);
    glob_arst_ni <= '0;
    xtal_i       <= '0;
    ext_m_req_i  <= '0;
    #(duration);
    glob_arst_ni <= '1;
    #(duration / 10);
  endtask

  task static start_clock(input realtime time_period = 62.5ns);
    fork
      forever begin
        xtal_i <= '1;
        #(time_period / 2);
        xtal_i <= '0;
        #(time_period / 2);
      end
    join_none
  endtask

  `SIMPLE_AXI_M_DRIVER(ext_m, xtal_i, glob_arst_ni, ext_m_req_i, ext_m_resp_o)

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    longint rd_data;
    int wr_resp;
    int rd_resp;

    apply_reset();
    start_clock();

    $finish;
  end

endmodule
