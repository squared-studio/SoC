module block_memory_tb;

  // Parameters
  parameter int ADDR_WIDTH = 12;
  parameter int DATA_WIDTH = 256;
  parameter int NUM_ROW = 32;
  parameter int NUM_COL = 8;

  // Signals
  logic clk;
  logic arst_n;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH/8-1:0][7:0] wdata;
  logic [DATA_WIDTH/8-1:0] be;
  logic we;
  logic [DATA_WIDTH/8-1:0][7:0] rdata;

  // Instantiate the block_memory module
  block_memory #(
      .ADDR_WIDTH(ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .NUM_ROW(NUM_ROW),
      .NUM_COL(NUM_COL)
  ) dut (
      .clk_i(clk),
      .arst_ni(arst_n),
      .addr_i(addr),
      .wdata_i(wdata),
      .be_i(be),
      .we_i(we),
      .rdata_o(rdata)
  );

  task static apply_reset();
    #100ns;
    clk   <= '0;
    // arst_n <= '0; // TODO IMPLEMENT RESET CHECK
    addr  <= '0;
    wdata <= '0;
    be    <= '0;
    we    <= '0;
    #100ns;
    arst_n <= '1;
    #100ns;
  endtask

  task static start_clock;
    fork
      forever begin
        clk <= ~clk;
        #5ns;
      end
    join_none
  endtask

  task static start_checking();
    int eff_addr;
    logic [7:0] ref_mem[longint];
    fork
      forever begin
        @(posedge clk);
        eff_addr = addr & 'hFE0;
        foreach (rdata[i]) begin
          if (rdata[i] !== ref_mem[eff_addr+i]) begin
            $display("\033[1;31mRead Error at Addr:0x%h EXP:0x%h GOT:0x%h\033[0m %0t",
                     eff_addr + i, ref_mem[eff_addr+i], rdata[i], $realtime);
            repeat (2) @(posedge clk);
            $finish;
          end
        end
        if (we) begin
          foreach (wdata[i]) begin
            if (be[i]) begin
              ref_mem[eff_addr+i] = wdata[i];
              // $display("\033[1;33mmem[0x%08x]<-0x%02x\033[0m %0t", eff_addr + i, wdata[i],
              //          $realtime);
            end
          end
        end
      end
    join_none
  endtask

  task static random_drive();
    fork
      forever begin
        @(posedge clk);
        addr  <= $urandom;
        wdata <= {$urandom,$urandom,$urandom,$urandom,$urandom,$urandom,$urandom,$urandom};
        be    <= $urandom;
        we    <= $urandom;
      end
    join_none
  endtask

  // Test sequence
  initial begin

    $timeformat(-6, 2, "us", 10);

    $dumpfile("block_memory_tb.vcd");
    $dumpvars(0, block_memory_tb);

    apply_reset();
    start_clock();
    start_checking();
    random_drive();

    #1ms;

    $display("\033[1;32mTEST PASSED\033[0m");
    $finish;

  end

endmodule
