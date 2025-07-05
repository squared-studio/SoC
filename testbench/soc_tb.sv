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

  logic    temp_ext_m_clk_o;
  logic    temp_ext_m_arst_no;
  m_req_t  ext_m_req_i;
  m_resp_t ext_m_resp_o;

  logic    ram_arst_no;
  logic    ram_clk_o;
  s_req_t  ram_req_o;
  s_resp_t ram_resp_i;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // VARIABLES
  //////////////////////////////////////////////////////////////////////////////////////////////////

  string core_test_name [soc_pkg::NUM_CORE];
  logic [63:0] test_symbols[int][string];
  bit test_passed = 1;

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // INSTANCIATIONS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  soc u_soc (
      .glob_arst_ni,
      .xtal_i,
      .temp_ext_m_clk_o,
      .temp_ext_m_arst_no,
      .ext_m_req_i,
      .ext_m_resp_o,
      .ram_arst_no,
      .ram_clk_o,
      .ram_req_o,
      .ram_resp_i
  );

  axi_ram #(
      // .MEM_BASE(soc_pkg::RAM_BASE),
      .MEM_BASE(0),
      // .MEM_SIZE(29),
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

  `SIMPLE_AXI_M_DRIVER(ext_m, temp_ext_m_clk_o, temp_ext_m_arst_no, ext_m_req_i, ext_m_resp_o)
  // task automatic ext_m_read_8(addr, data, resp);
  // task automatic ext_m_write_8(addr, data, resp);
  // task automatic ext_m_read_16(addr, data, resp);
  // task automatic ext_m_write_16(addr, data, resp);
  // task automatic ext_m_read_32(addr, data, resp);
  // task automatic ext_m_write_32(addr, data, resp);
  // task automatic ext_m_read_64(addr, data, resp);
  // task automatic ext_m_write_64(addr, data, resp);

  function automatic void load_symbols(string filename, int index);
    int file, r;
    string line;
    string key;
    int value;
    file = $fopen(filename, "r");
    if (file == 0) begin
      $display("Error: Could not open file %s", filename);
      $finish;
    end
    while (!$feof(
        file
    )) begin
      r = $fgets(line, file);
      if (r != 0) begin
        r = $sscanf(line, "%h %*s %s", value, key);
        test_symbols[index][key] = value;
      end
    end
    $fclose(file);
  endfunction

  task automatic wait_exit(input int idx);
    logic [7:0][7:0] exit_code;
    logic [7:0]      ref_data  [longint];

    // STDOUT
    if (test_symbols[idx].exists("putchar_stdout")) begin
      string prints;
      prints = "";
      fork
        forever begin
          @(posedge ram_clk_o);
          if ((unsigned'(u_axi_ram.mem_waddr_o) + unsigned'(u_axi_ram.MEM_BASE))
            == test_symbols[idx]["putchar_stdout"]
            && u_axi_ram.mem_wstrb_o[0] == '1 && u_axi_ram.mem_we_o) begin
            if (u_axi_ram.mem_wdata_o[0] == "\n") begin
              $display("\033[1;33mCORE%0d_STDOUT     : %s\033[0m [%0t]", idx, prints, $realtime);
              prints = "";
            end else begin
              $sformat(prints, "%s%c", prints, u_axi_ram.mem_wdata_o[0]);
            end
          end
        end
      join_none
    end

    $display("\033[0;35mCORE%0d_TOHOST     : 0x%08x\033[0m", idx, test_symbols[idx]["tohost"]);

    // CHECK EXIT CODE
    forever begin
      @(posedge ram_clk_o);
      if ((unsigned'(u_axi_ram.mem_waddr_o) + unsigned'(u_axi_ram.MEM_BASE)) ==
      test_symbols[idx]["tohost"] && u_axi_ram.mem_we_o == '1) begin
        exit_code = '0;
        foreach (exit_code[i]) begin
          if (u_axi_ram.mem_wstrb_o[i]) begin
            exit_code[i] = u_axi_ram.mem_wdata_o[i];
          end
        end
        if (exit_code[0][0]) begin
          exit_code = exit_code >> 1;
          break;
        end
      end
    end
    $display("\033[0;35mCORE%0d_EXIT_CODE  : 0x%08x\033[0m", idx, exit_code);

    ref_data.delete();
    begin
      bit [7:0] mem[longint];
      $readmemh($sformatf("prog_%0d.test_data", idx), mem);
      foreach (mem[i]) ref_data[i+test_symbols[idx]["TEST_DATA_BEGIN"]] = mem[i];
    end

    foreach (ref_data[i]) begin
      if (ref_data[i] != u_axi_ram.read_mem_b(i)) begin
        exit_code = 1;
        $display("\033[0;35mEXIT CODE      : 0x%08x\033[0m", exit_code);
        $display("\033[1;31mMEM[0x%08x]: EXP:0x%02x GOT:0x%02x\033[0m", i, ref_data[i],
                 u_axi_ram.read_mem_b(i));
      end
    end

    if (exit_code == 0) $display("\033[1;32mCORE%0d PASSED\033[0m", idx);
    else begin
      $display("\033[1;31mCORE%0d FAILED\033[0m", idx);
      test_passed = 0;
    end

  endtask


  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    logic [7:0] MEM[longint];

    // Set time format to microseconds
    $timeformat(-6, 3, "us");

    test_passed = 1;

    MEM.delete();

    `define LOAD_PROGRAM_SOC_TB(__IDX__)                                                           \
      if ($value$plusargs(`"CORE``__IDX__``_STANDALONE=%s`", core_test_name[``__IDX__``])) begin   \
        logic [7:0] mem [longint];                                                                 \
        $display(`"\033[0;35mCORE``__IDX__``_STANDALONE : %s\033[0m`",                             \
          core_test_name[``__IDX__``]);                                                            \
          mem.delete();                                                                            \
          $readmemh(`"prog_``__IDX__``.hex`", mem);                                                \
          foreach (mem[addr]) MEM[addr & 'h7FFFFFFF] = mem[addr];                                  \
          load_symbols(`"prog_``__IDX__``.sym`", ``__IDX__``);                                     \
      end else begin                                                                               \
        core_test_name[``__IDX__``] = "";                                                          \
      end                                                                                          \


    `LOAD_PROGRAM_SOC_TB(0)
    `LOAD_PROGRAM_SOC_TB(1)
    `LOAD_PROGRAM_SOC_TB(2)
    `LOAD_PROGRAM_SOC_TB(3)

    `undef LOAD_PROGRAM_SOC_TB

    if ($test$plusargs("DEBUG")) begin
      int addr;
      int cnt;
      addr = -1;
      cnt  = 0;
      $display("\033[0;33m--------------- HEX_DATA_TO_LOAD --------------\033[0m");
      foreach (MEM[i]) begin
        if (addr != i) begin
          if (cnt != 0) $display();
          $display("@%08x", i);
          cnt = 0;
        end
        $write("%02x", MEM[i]);
        if (cnt == 15) begin
          $write("\n");
          cnt = 0;
        end else begin
          $write(" ");
          cnt++;
        end
        addr = i + 1;
      end
      if (cnt != 0) $display();
      $display("\033[0;33m-----------------------------------------------\033[0m");
      foreach (test_symbols[idx, sym]) begin
        $display("\033[0;33m@%08x:\033[0m %s(%0d)", test_symbols[idx][sym], sym, idx);
      end
    end

    apply_reset();
    start_clock();

    // TODO REPLACE WITH BOOTROM
    begin
      logic [7:0][7:0] hex_data_to_load[longint];
      bit [1:0] resp;
      hex_data_to_load.delete();
      foreach (MEM[addr]) begin
        hex_data_to_load[addr&'h7FFFFFF8][addr&'h7] = MEM[addr];
      end
      $display("\033[0;33mTOTAL %0d 64b writes", hex_data_to_load.size());
      @(posedge temp_ext_m_clk_o);
      $display("\033[0;33mtemp_ext_m_clk_o active\033[0m");
      ext_m_write_64('h10000600, 3200, resp);  // ram freq
      ext_m_write_64('h10000E18, 1, resp);  // ram clk en
      foreach (hex_data_to_load[i]) begin
        fork
          ext_m_write_64(i, hex_data_to_load[i], resp);
        join_none
        #0ns;
        hex_data_to_load.delete(i);
        if (hex_data_to_load.size() % 1024 == 0) begin
          $display("%0d write remains ", hex_data_to_load.size());
        end
      end
      ext_m_write_64('h10000E18, 1, resp);  // ram clk en
      $display("\033[0;33mINSTRUCTIONS LOADED\033[0m");
    end

    MEM.delete();

    begin
      bit [ 1:0] resp;
      bit [63:0] clk_en_vec;
      clk_en_vec = '0;
      foreach (test_symbols[i]) begin
        if (test_symbols[i].exists("_start")) begin
          $display("\033[0;35mCORE%0d_BOOTADDR   : 0x%08x\033[0m", i, test_symbols[i]["_start"]);
          fork
            ext_m_write_64('h10000000 + 8 * i, test_symbols[i]["_start"], resp);
          join_none
          @(posedge temp_ext_m_clk_o);
          fork
            ext_m_write_64('h10000200 + 8 * i, i, resp);
          join_none
          @(posedge temp_ext_m_clk_o);
          fork
            ext_m_write_64('h10000400 + 8 * i, 4000, resp);
          join_none
          @(posedge temp_ext_m_clk_o);
          clk_en_vec[i] = '1;
        end
      end
      ext_m_write_64('h10000E10, clk_en_vec, resp);
    end

    fork
      if (test_symbols[0].exists("tohost")) wait_exit(0);
      if (test_symbols[1].exists("tohost")) wait_exit(1);
      if (test_symbols[2].exists("tohost")) wait_exit(2);
      if (test_symbols[3].exists("tohost")) wait_exit(3);
    join

    if (test_passed) $display("\033[1;32m************** TEST PASSED **************\033[0m");
    else $display("\033[1;31m************** TEST FAILED **************\033[0m");

    $finish;
  end

  initial begin
    #10ms;
    $fatal(1, "Simulation timeout after 1ms");
  end

endmodule
