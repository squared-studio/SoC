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

  event ext_master_aw_channel_done_trigger;
  longint ext_master_aw_channel_next_id = 0;
  longint ext_master_aw_channel_access_q[$];
  task automatic ext_master_aw_channel_send(input logic [63:0] addr);
    longint this_task_id;
    this_task_id = ext_master_aw_channel_next_id;
    ext_master_aw_channel_next_id++;
    ext_master_aw_channel_access_q.push_back(this_task_id);
    while ((ext_master_aw_channel_access_q[0] != this_task_id) || (glob_arst_ni == 0))
      @(ext_master_aw_channel_done_trigger);
    ext_m_req_i.aw.id     <= '0;
    ext_m_req_i.aw.addr   <= addr;
    ext_m_req_i.aw.len    <= '0;
    ext_m_req_i.aw.size   <= 3;
    ext_m_req_i.aw.burst  <= 1;
    ext_m_req_i.aw.lock   <= '0;
    ext_m_req_i.aw.cache  <= '0;
    ext_m_req_i.aw.prot   <= '0;
    ext_m_req_i.aw.qos    <= '0;
    ext_m_req_i.aw.region <= '0;
    ext_m_req_i.aw.user   <= '0;
    ext_m_req_i.aw.atop   <= '0;
    ext_m_req_i.aw_valid  <= '1;
    do @(posedge xtal_i); while (ext_m_resp_o.aw_ready !== '1);
    ext_m_req_i.aw_valid <= '0;
    ext_master_aw_channel_access_q.delete(0);
    ->ext_master_aw_channel_done_trigger;
  endtask

  event ext_master_w_channel_done_trigger;
  longint ext_master_w_channel_next_id = 0;
  longint ext_master_w_channel_access_q[$];
  task automatic ext_master_w_channel_send(input logic [63:0] data, input logic [7:0] strb);
    longint this_task_id;
    this_task_id = ext_master_w_channel_next_id;
    ext_master_w_channel_next_id++;
    ext_master_w_channel_access_q.push_back(this_task_id);
    while ((ext_master_w_channel_access_q[0] != this_task_id) || (glob_arst_ni == 0))
      @(ext_master_w_channel_done_trigger);
    ext_m_req_i.w.data  <= data;
    ext_m_req_i.w.strb  <= strb;
    ext_m_req_i.w.last  <= '1;
    ext_m_req_i.w.user  <= '0;
    ext_m_req_i.w_valid <= '1;
    do @(posedge xtal_i); while (ext_m_resp_o.w_ready !== '1);
    ext_m_req_i.w_valid <= '0;
    ext_master_w_channel_access_q.delete(0);
    ->ext_master_w_channel_done_trigger;
  endtask

  event ext_master_b_channel_done_trigger;
  longint ext_master_b_channel_next_id = 0;
  longint ext_master_b_channel_access_q[$];
  task automatic ext_master_b_channel_recv(output logic [1:0] resp);
    longint this_task_id;
    this_task_id = ext_master_b_channel_next_id;
    ext_master_b_channel_next_id++;
    ext_master_b_channel_access_q.push_back(this_task_id);
    while ((ext_master_b_channel_access_q[0] != this_task_id) || (glob_arst_ni == 0))
      @(ext_master_b_channel_done_trigger);
    ext_m_req_i.b_ready <= '1;
    do @(posedge xtal_i); while (ext_m_resp_o.b_valid !== '1);
    resp = ext_m_resp_o.b.resp;
    ext_m_req_i.b_ready <= '0;
    ext_master_b_channel_access_q.delete(0);
    ->ext_master_b_channel_done_trigger;
  endtask

  event ext_master_ar_channel_done_trigger;
  longint ext_master_ar_channel_next_id = 0;
  longint ext_master_ar_channel_access_q[$];
  task automatic ext_master_ar_channel_send(input logic [63:0] addr);
    longint this_task_id;
    this_task_id = ext_master_ar_channel_next_id;
    ext_master_ar_channel_next_id++;
    ext_master_ar_channel_access_q.push_back(this_task_id);
    while ((ext_master_ar_channel_access_q[0] != this_task_id) || (glob_arst_ni == 0))
      @(ext_master_ar_channel_done_trigger);
    ext_m_req_i.ar.id     <= '0;
    ext_m_req_i.ar.addr   <= addr;
    ext_m_req_i.ar.len    <= '0;
    ext_m_req_i.ar.size   <= 3;
    ext_m_req_i.ar.burst  <= 1;
    ext_m_req_i.ar.lock   <= '0;
    ext_m_req_i.ar.cache  <= '0;
    ext_m_req_i.ar.prot   <= '0;
    ext_m_req_i.ar.qos    <= '0;
    ext_m_req_i.ar.region <= '0;
    ext_m_req_i.ar.user   <= '0;
    ext_m_req_i.ar_valid  <= '1;
    do @(posedge xtal_i); while (ext_m_resp_o.ar_ready !== '1);
    ext_m_req_i.ar_valid <= '0;
    ext_master_ar_channel_access_q.delete(0);
    ->ext_master_ar_channel_done_trigger;
  endtask

  event ext_master_r_channel_done_trigger;
  longint ext_master_r_channel_next_id = 0;
  longint ext_master_r_channel_access_q[$];
  task automatic ext_master_r_channel_recv(output logic [63:0] data, output logic [1:0] resp);
    longint this_task_id;
    this_task_id = ext_master_r_channel_next_id;
    ext_master_r_channel_next_id++;
    ext_master_r_channel_access_q.push_back(this_task_id);
    while ((ext_master_r_channel_access_q[0] != this_task_id) || (glob_arst_ni == 0))
      @(ext_master_r_channel_done_trigger);
    ext_m_req_i.r_ready <= '1;
    do @(posedge xtal_i); while (ext_m_resp_o.r_valid !== '1);
    data = ext_m_resp_o.r.data;
    resp = ext_m_resp_o.r.resp;
    ext_m_req_i.r_ready <= '0;
    ext_master_r_channel_access_q.delete(0);
    ->ext_master_r_channel_done_trigger;
  endtask

  //////////////////////////////////////////////////////////////////////////////////////////////////
  // PROCEDURALS
  //////////////////////////////////////////////////////////////////////////////////////////////////

  initial begin
    longint rd_data;
    int wr_resp;
    int rd_resp;

    apply_reset();
    start_clock();

    repeat (10) @(posedge xtal_i);

    u_axi_ram.write_mem_d('h40000000, 'hFEDCBA9876543210);

    fork
      ext_master_ar_channel_send('h40000000);
      ext_master_r_channel_recv(rd_data, rd_resp);
    join

    $display("rd_data:0x%x", rd_data);

    fork
      ext_master_ar_channel_send('h40000008);
      ext_master_r_channel_recv(rd_data, rd_resp);
    join

    $display("rd_data:0x%x", rd_data);

    fork
      begin
        fork
          ext_master_aw_channel_send('h40000000);
          ext_master_w_channel_send('hFFFFFFFFFFFFFFFF, 'b10100011);
          ext_master_b_channel_recv(wr_resp);
        join
      end
      begin
        #1ns;
        fork
          ext_master_aw_channel_send('h40000000);
          ext_master_w_channel_send('hFFFFFFFFFFFFFFFF, 'b01011100);
          ext_master_b_channel_recv(wr_resp);
        join
      end
      begin
        #2ns;
        fork
          ext_master_aw_channel_send('h40000000);
          ext_master_w_channel_send('h0, 'b01010101);
          ext_master_b_channel_recv(wr_resp);
        join
      end
    join

    fork
      ext_master_ar_channel_send('h40000000);
      ext_master_r_channel_recv(rd_data, rd_resp);
    join

    $display("rd_data:0x%x", rd_data);

    repeat (10) @(posedge xtal_i);

    $finish;
  end

endmodule
