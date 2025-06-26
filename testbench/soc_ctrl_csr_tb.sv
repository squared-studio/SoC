`include "vip/simple_axi_m_driver.svh"

module soc_ctrl_csr_tb;


  // Display messages at the start and end of the test
  initial $display("\033[7;38m---------------------- TEST STARTED ----------------------\033[0m");
  final $display("\033[7;38m----------------------- TEST ENDED -----------------------\033[0m");

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // IMPORTS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  import soc_pkg::NUM_CORE;
  import soc_pkg::XLEN;
  import soc_pkg::FB_DIV_WIDTH;
  import soc_pkg::TEMP_SENSOR_WIDTH;
  import soc_pkg::s_req_t;
  import soc_pkg::s_resp_t;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // SIGNALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  logic                                                  clk_i;
  logic                                                  arst_ni;
  s_req_t                                                req_i;
  s_resp_t                                               resp_o;

  logic    [        NUM_CORE-1:0][             XLEN-1:0] boot_addr_vec_o;
  logic    [        NUM_CORE-1:0][             XLEN-1:0] hart_id_vec_o;
  logic    [        NUM_CORE-1:0]                        core_clk_en_vec_o;
  logic    [        NUM_CORE-1:0]                        core_arst_vec_o;
  logic    [        NUM_CORE-1:0][     FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o;
  logic    [        NUM_CORE-1:0]                        core_pll_locked_i;
  logic    [        NUM_CORE-1:0][TEMP_SENSOR_WIDTH-1:0] core_temp_sensor_vec_i;

  logic                                                  ram_clk_en_o;
  logic                                                  ram_arst_o;
  logic    [    FB_DIV_WIDTH-1:0]                        ram_pll_fb_div_o;
  logic                                                  ram_pll_locked_i;

  logic                                                  glob_arst_o;
  logic    [$clog2(NUM_CORE+1)-1:0]                      sys_pll_select_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INSTANCIATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  soc_ctrl_csr #(
      .NUM_CORE         (NUM_CORE),
      .MEM_BASE         ('h10000000),
      .XLEN             (XLEN),
      .FB_DIV_WIDTH     (FB_DIV_WIDTH),
      .TEMP_SENSOR_WIDTH(TEMP_SENSOR_WIDTH),
      .req_t            (s_req_t),
      .resp_t           (s_resp_t)
  ) u_dut (
      .clk_i,
      .arst_ni,
      .req_i,
      .resp_o,
      .boot_addr_vec_o,
      .hart_id_vec_o,
      .core_clk_en_vec_o,
      .core_arst_vec_o,
      .core_pll_fb_div_vec_o,
      .core_pll_locked_i,
      .core_temp_sensor_vec_i,
      .ram_clk_en_o,
      .ram_arst_o,
      .ram_pll_fb_div_o,
      .ram_pll_locked_i,
      .glob_arst_o,
      .sys_pll_select_i
  );

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // METHODS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  task static apply_reset(input realtime duration = 100ns);
    #(duration / 10);
    clk_i <= '0;
    arst_ni <= '0;
    req_i <= '0;
    core_pll_locked_i <= '0;
    core_temp_sensor_vec_i <= '0;
    ram_pll_locked_i <= '0;
    sys_pll_select_i <= '0;
    #(duration);
    arst_ni <= '1;
    #(duration / 10);
  endtask

  task static start_clock(input realtime time_period = 10ns);
    fork
      forever begin
        clk_i <= '1;
        #(time_period / 2);
        clk_i <= '0;
        #(time_period / 2);
      end
    join_none
  endtask

  `SIMPLE_AXI_M_DRIVER(csr, clk_i, arst_ni, req_i, resp_o)
  // task automatic csr_read_8(addr, data, resp);
  // task automatic csr_write_8(addr, data, resp);
  // task automatic csr_read_16(addr, data, resp);
  // task automatic csr_write_16(addr, data, resp);
  // task automatic csr_read_32(addr, data, resp);
  // task automatic csr_write_32(addr, data, resp);
  // task automatic csr_read_64(addr, data, resp);
  // task automatic csr_write_64(addr, data, resp);

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    // $dumpfile("soc_ctrl_csr_tb.vcd");
    // $dumpvars(0, soc_ctrl_csr_tb);

    apply_reset();
    start_clock();

    @(posedge clk_i);

    for (int i = 0; i < NUM_CORE; i++) begin
      repeat (10) begin
        logic [ 1:0] resp;
        logic [63:0] rdata;
        logic [63:0] wdata;
        wdata = {$urandom, $urandom};
        csr_write_64('h10000000 + 8 * i, wdata, resp);
        csr_read_64('h10000000 + 8 * i, rdata, resp);
        if (wdata !== rdata)
          #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
        if (wdata !== boot_addr_vec_o[i])
          #100ns
          $fatal(
              1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, boot_addr_vec_o[i]
          );
      end
    end
    $display("boot_addr_vec_o \033[1;32mOK\033[0m");

    for (int i = 0; i < NUM_CORE; i++) begin
      repeat (10) begin
        logic [ 1:0] resp;
        logic [63:0] rdata;
        logic [63:0] wdata;
        wdata = {$urandom, $urandom};
        csr_write_64('h10000200 + 8 * i, wdata, resp);
        csr_read_64('h10000200 + 8 * i, rdata, resp);
        if (wdata !== rdata)
          #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
        if (wdata !== hart_id_vec_o[i])
          #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, hart_id_vec_o[i]);
      end
    end
    $display("hart_id_vec_o \033[1;32mOK\033[0m");

    for (int i = 0; i < NUM_CORE; i++) begin
      repeat (10) begin
        logic [ 1:0] resp;
        logic [63:0] rdata;
        logic [63:0] wdata;
        wdata = $urandom & (2 ** FB_DIV_WIDTH - 1);
        csr_write_64('h10000400 + 8 * i, wdata, resp);
        csr_read_64('h10000400 + 8 * i, rdata, resp);
        if (wdata !== rdata)
          #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
        if (wdata !== core_pll_fb_div_vec_o[i])
          #100ns
          $fatal(
              1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, core_pll_fb_div_vec_o[i]
          );
      end
    end
    $display("core_pll_fb_div_vec_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & (2 ** FB_DIV_WIDTH - 1);
      csr_write_64('h10000600, wdata, resp);
      csr_read_64('h10000600, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== ram_pll_fb_div_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, ram_pll_fb_div_o);
    end
    $display("ram_pll_fb_div_o \033[1;32mOK\033[0m");

    for (int i = 0; i < NUM_CORE; i++) begin
      repeat (10) begin
        logic [ 1:0] resp;
        logic [63:0] rdata;
        logic [63:0] wdata;
        wdata = $urandom & (2 ** TEMP_SENSOR_WIDTH - 1);
        core_temp_sensor_vec_i[i] <= wdata;
        csr_read_64('h10000C00 + 8 * i, rdata, resp);
        if (wdata !== rdata)
          #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      end
    end
    $display("core_temp_sensor_vec_i \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & (2 ** NUM_CORE - 1);
      core_pll_locked_i <= wdata;
      csr_read_64('h10000E00, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
    end
    $display("core_pll_locked_i \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & 'h01;
      ram_pll_locked_i <= wdata;
      csr_read_64('h10000E08, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
    end
    $display("ram_pll_locked_i \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & (2 ** NUM_CORE - 1);
      csr_write_64('h10000E10, wdata, resp);
      csr_read_64('h10000E10, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== core_clk_en_vec_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, core_clk_en_vec_o);
    end
    $display("core_clk_en_vec_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & 1;
      csr_write_64('h10000E18, wdata, resp);
      csr_read_64('h10000E18, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== ram_clk_en_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, ram_clk_en_o);
    end
    $display("ram_clk_en_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & (2 ** NUM_CORE - 1);
      csr_write_64('h10000E20, wdata, resp);
      csr_read_64('h10000E20, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== core_arst_vec_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, core_arst_vec_o);
    end
    $display("core_arst_vec_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & 1;
      csr_write_64('h10000E28, wdata, resp);
      csr_read_64('h10000E28, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== ram_arst_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, ram_arst_o);
    end
    $display("ram_arst_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & 1;
      csr_write_64('h10000E30, wdata, resp);
      csr_read_64('h10000E30, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
      if (wdata !== glob_arst_o)
        #100ns $fatal(1, "WDATA DOESN'T MATCH OUTPUT EXP:0x%x GOT:0x%x", wdata, glob_arst_o);
    end
    $display("glob_arst_o \033[1;32mOK\033[0m");

    repeat (10) begin
      logic [ 1:0] resp;
      logic [63:0] rdata;
      logic [63:0] wdata;
      wdata = $urandom & 'h03;
      sys_pll_select_i <= wdata;
      csr_read_64('h10000E38, rdata, resp);
      if (wdata !== rdata)
        #100ns $fatal(1, "WDATA DOESN'T MATCH RDATA EXP:0x%x GOT:0x%x", wdata, rdata);
    end
    $display("sys_pll_select_i \033[1;32mOK\033[0m");

    $finish;
  end

endmodule
