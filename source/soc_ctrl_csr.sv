module soc_ctrl_csr #(
    parameter logic [63:0] MEM_BASE  = 0,
    parameter int          NUM_CORES = 1,
    parameter type         req_t     = logic,
    parameter type         resp_t    = logic
) (
    input  logic  clk_i,
    input  logic  arst_ni,
    input  req_t  req_i,
    output resp_t resp_o,

    output logic [NUM_CORES-1:0][63:0] boot_vector_o
);

  // BASE + 0x000 CORE_0 boot_addr
  // BASE + 0x008 CORE_1 boot_addr
  // BASE + 0x010 CORE_2 boot_addr
  // BASE + 0x018 CORE_3 boot_addr

  // BASE + 0x040 CORE_0 hart_id
  // BASE + 0x048 CORE_1 hart_id
  // BASE + 0x050 CORE_2 hart_id
  // BASE + 0x058 CORE_3 hart_id

  // BASE + 0x080 CORE_0 pll_cfg
  // BASE + 0x088 CORE_1 pll_cfg
  // BASE + 0x090 CORE_2 pll_cfg
  // BASE + 0x098 CORE_3 pll_cfg
  // BASE + 0x0A0 system pll_cfg

endmodule
