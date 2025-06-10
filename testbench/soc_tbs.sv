module soc_tb;
  import soc_pkg::m_req_t;
  import soc_pkg::m_resp_t;
  import soc_pkg::s_req_t;
  import soc_pkg::s_resp_t;

  logic    glob_arst_ni;
  logic    xtal_i;
  m_req_t  ext_m_req;
  m_resp_t ext_m_resp;

  logic    ram_arst_no;
  logic    ram_clk_o;
  s_req_t  ram_req_o;
  s_resp_t ram_resp_i;

  soc u_soc (
      .glob_arst_ni,
      .xtal_i,
      .ext_m_req,
      .ext_m_resp,
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

  initial begin
    ext_m_req <= '0;
    xtal_i <= '0;
    glob_arst_ni <= '0;
    #100ns;
    glob_arst_ni <= '1;
    #100ns;
    fork
      forever begin
        xtal_i <= '1;
        #5ns;
        xtal_i <= '0;
        #5ns;
      end
    join_none
    #10us;
    $finish;
  end

endmodule
