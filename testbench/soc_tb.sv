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
      .MEM_BASE(soc_pkg::RAM_BASE),
      .MEM_SIZE(29),
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

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin

    // TODO REPLACE WITH MASS STORAGE
    logic [7:0][7:0] hex_data_to_load[longint];

    hex_data_to_load.delete();

    `define LOAD_PROGRAM_SOC_TB(__IDX__)                                                           \
      if ($value$plusargs(`"CORE``__IDX__``_STANDALONE=%s`", core_test_name[``__IDX__``])) begin   \
        logic [7:0] mem [longint];                                                                 \
        $display(`"\033[0;35mCORE``__IDX__``_STANDALONE : %s\033[0m`",                             \
          core_test_name[``__IDX__``]);                                                            \
          mem.delete();                                                                            \
          $readmemh(`"prog_``__IDX__``.hex`", mem);                                                \
          foreach (mem[addr]) begin                                                                \
            hex_data_to_load[addr & 'h7FFFFFF8][addr & 'h7] = mem[addr];                           \
          end                                                                                      \
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
      automatic int addr;
      addr = -1;
      $write("\033[0;33m--------------- HEX_DATA_TO_LOAD --------------\033[0m");
      foreach (hex_data_to_load[i]) begin
        if (addr != i) begin
          $display("\n@%08x", i);
          if (i & 'h08) $write("xx xx xx xx xx xx xx xx ");
        end
        for (int j = 0; j < 8; j++) $write("%02x ", hex_data_to_load[i][j]);
        addr = i + 8;
        if (i & 'h08) $display();
      end
      if (addr & 'h08) $display();
      $display("\033[0;33m-----------------------------------------------\033[0m");
      foreach (test_symbols[idx, sym]) begin
        $display("\033[0;33m@%08x:\033[0m %0d:%s", test_symbols[idx][sym], idx, sym);
      end
    end

    apply_reset();
    start_clock();

    $display("\033[1;33mTOTAL %0d 64b writes", hex_data_to_load.size());
    // TODO REPLACE WITH BOOTROM
    begin
      bit [1:0] resp;
      @(posedge temp_ext_m_clk_o);
      $display("\033[1;33mtemp_ext_m_clk_o active\033[0m");
      ext_m_write_64('h10000600, 3200, resp);  // ram freq
      ext_m_write_64('h10000E18, 1, resp);  // ram clk en
      foreach (hex_data_to_load[i]) begin
        fork
          ext_m_write_64(i, hex_data_to_load[i], resp);
        join_none
        @(posedge temp_ext_m_clk_o);
        hex_data_to_load.delete(i);
        if (hex_data_to_load.size() % 1024 == 0) begin
          $display("%0d write remains ", hex_data_to_load.size());
        end
      end
      ext_m_write_64('h10000E18, 1, resp);  // ram clk en
      $display("\033[1;33mINSTRUCTIONS LOADED\033[0m");
    end

    #1us;

    $finish;
  end

endmodule
