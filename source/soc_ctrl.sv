module soc_ctrl #(
    parameter int          NUM_CORES    = 4,
    parameter logic [63:0] MEM_BASE     = 0,
    parameter int          XLEN         = 64,
    parameter int          FB_DIV_WIDTH = 12,
    parameter int          NUM_GPR      = 4,
    parameter type         req_t        = soc_pkg::s_req_t,
    parameter type         resp_t       = soc_pkg::s_resp_t
) (
    input  logic  clk_i,
    input  logic  arst_ni,
    input  req_t  req_i,
    output resp_t resp_o,

    output logic [NUM_CORES-1:0][        XLEN-1:0] boot_addr_vec_o,
    output logic [NUM_CORES-1:0][        XLEN-1:0] hart_id_vec_o,
    output logic [NUM_CORES-1:0]                   core_clk_o,
    output logic [NUM_CORES-1:0]                   core_arst_no,
    output logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o,
    input  logic [NUM_CORES-1:0]                   core_pll_locked_i,
    input  logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_i,

    output logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_o,
    input  logic                    ram_pll_locked_i,
    input  logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_i,

    output logic glob_arst_o,

    output logic [NUM_GPR-1:0] grp_o
);

  logic [NUM_CORES-1:0] core_clk_en_o;
  logic [NUM_CORES-1:0] core_arst_o;

  /*
soc_ctrl_csr #(
    .NUM_CORES(NUM_CORES),
    .MEM_BASE(MEM_BASE),
    .XLEN(XLEN),
    .FB_DIV_WIDTH(FB_DIV_WIDTH),
    .NUM_GPR(NUM_GPR),
    .req_t(req_t),
    .resp_t(resp_t)
) u_soc_ctrl_csr (
    .clk_i,
    .arst_ni,
    .req_i,
    .resp_o,
    .boot_addr_vec_o,
    .hart_id_vec_o,
    .core_clk_en_o,
    .core_arst_o,
    output logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o,
    input  logic [NUM_CORES-1:0]                   core_pll_locked_i,
    input  logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_i,

    output logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_o,
    input  logic                    ram_pll_locked_i,
    input  logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_i,
    .glob_arst_o,
    .grp_o
);
*/

endmodule
