`include "axi/typedef.svh"

module axi_ram #(
    parameter logic [63:0] MEM_BASE     = 'h1000,
    parameter int          MEM_SIZE     = 18,
    parameter bit          ALLOW_WRITES = 1,
    parameter type         req_t        = soc_pkg::s_req_t,
    parameter type         resp_t       = soc_pkg::s_resp_t
) (
    input  logic  clk_i,
    input  logic  arst_ni,
    input  req_t  req_i,
    output resp_t resp_o
);

  localparam int AW = $bits(req_i.aw.addr);
  localparam int DW = $bits(req_i.w.data);
  localparam int MEM_AW = MEM_SIZE - $clog2(DW / 8);

  logic  [    AW-1:0]      addr_out;

  logic                    mem_req;
  logic                    mem_we;
  logic  [MEM_AW-1:0]      mem_addr;
  logic  [  DW/8-1:0][7:0] mem_wdata;
  logic  [  DW/8-1:0]      mem_strb;
  logic                    mem_rvalid;
  logic  [  DW/8-1:0][7:0] mem_rdata;
  logic  [  DW/8-1:0][7:0] tmp_rdata;

  logic  [  DW/8-1:0][7:0] rdata_q    [$];

  bit    [       7:0]      mem        [longint];

  resp_t                   final_resp;

  always @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      rdata_q.delete();
      mem_rvalid <= '0;
    end else begin
      if (rdata_q.size()) begin
        mem_rvalid <= '1;
        mem_rdata  <= rdata_q.pop_front();
      end else begin
        mem_rvalid <= '0;
      end
      foreach (tmp_rdata[i]) begin
        tmp_rdata[i] = mem[mem_addr*8+i];
      end
      if (mem_req) begin
        rdata_q.push_back(tmp_rdata);
        foreach (mem_strb[i]) begin
          if (mem_strb[i] & mem_we & ALLOW_WRITES) begin
            mem[mem_addr*8+i] = mem_wdata[i];
          end
        end
      end
    end
  end

  always_comb begin
    addr_out = MEM_BASE + mem_addr * 8;
  end

  always_comb begin
    resp_o = final_resp;
    if (ALLOW_WRITES == 0) resp_o.b.resp = 2;
  end

  axi_to_mem_with_fifo #(
      .req_t(req_t),
      .resp_t(resp_t),
      .MEM_BASE(MEM_BASE),
      .MEM_SIZE(MEM_SIZE),
      .MEM_DW($bits(req_i.w.data))
  ) u_axi_to_mem_with_fifo (
      .clk_i(clk_i),
      .arst_ni(arst_ni),
      .req_i(req_i),
      .resp_o(final_resp),
      .mem_req_o(mem_req),
      .mem_we_o(mem_we),
      .mem_addr_o(mem_addr),
      .mem_wdata_o(mem_wdata),
      .mem_strb_o(mem_strb),
      .mem_rvalid_i(mem_rvalid),
      .mem_rdata_i(mem_rdata)
  );

  function automatic void write_mem_b(input logic [63:0] addr, input logic [7:0] data);
    mem[addr-MEM_BASE] = data;
  endfunction

  function automatic logic [7:0] read_mem_b(input logic [63:0] addr);
    return mem[addr-MEM_BASE];
  endfunction

  function automatic void write_mem_h(input logic [63:0] addr, input logic [15:0] data);
    mem[addr-MEM_BASE+1] = data[15:8];
    mem[addr-MEM_BASE+0] = data[7:0];
  endfunction

  function automatic logic [15:0] read_mem_h(input logic [63:0] addr);
    return {mem[addr-MEM_BASE+1], mem[addr-MEM_BASE+0]};
  endfunction

  function automatic void write_mem_w(input logic [63:0] addr, input logic [31:0] data);
    mem[addr-MEM_BASE+3] = data[31:24];
    mem[addr-MEM_BASE+2] = data[23:16];
    mem[addr-MEM_BASE+1] = data[15:8];
    mem[addr-MEM_BASE+0] = data[7:0];
  endfunction

  function automatic logic [31:0] read_mem_w(input logic [63:0] addr);
    return {mem[addr-MEM_BASE+3], mem[addr-MEM_BASE+2], mem[addr-MEM_BASE+1], mem[addr-MEM_BASE+0]};
  endfunction

  function automatic void write_mem_d(input logic [63:0] addr, input logic [63:0] data);
    mem[addr-MEM_BASE+7] = data[63:56];
    mem[addr-MEM_BASE+6] = data[55:48];
    mem[addr-MEM_BASE+5] = data[47:40];
    mem[addr-MEM_BASE+4] = data[39:32];
    mem[addr-MEM_BASE+3] = data[31:24];
    mem[addr-MEM_BASE+2] = data[23:16];
    mem[addr-MEM_BASE+1] = data[15:8];
    mem[addr-MEM_BASE+0] = data[7:0];
  endfunction

  function automatic logic [63:0] read_mem_d(input logic [63:0] addr);
    return {
      mem[addr-MEM_BASE+7],
      mem[addr-MEM_BASE+6],
      mem[addr-MEM_BASE+5],
      mem[addr-MEM_BASE+4],
      mem[addr-MEM_BASE+3],
      mem[addr-MEM_BASE+2],
      mem[addr-MEM_BASE+1],
      mem[addr-MEM_BASE+0]
    };
  endfunction

endmodule
