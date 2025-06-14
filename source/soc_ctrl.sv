module soc_ctrl #(
    parameter int          NUM_CORE          = 4,
    parameter logic [63:0] MEM_BASE          = 0,
    parameter int          XLEN              = 64,
    parameter int          FB_DIV_WIDTH      = 12,
    parameter int          TEMP_SENSOR_WIDTH = 10,
    parameter type         req_t             = soc_pkg::s_req_t,
    parameter type         resp_t            = soc_pkg::s_resp_t
) (
    input logic xtal_i,

    output logic sys_clk_o,

    input  req_t  req_i,
    output resp_t resp_o,

    output logic [NUM_CORE-1:0][             XLEN-1:0] boot_addr_vec_o,
    output logic [NUM_CORE-1:0][             XLEN-1:0] hart_id_vec_o,
    output logic [NUM_CORE-1:0]                        core_clk_vec_o,
    output logic [NUM_CORE-1:0]                        core_arst_vec_no,
    input  logic [NUM_CORE-1:0][TEMP_SENSOR_WIDTH-1:0] core_temp_sensor_vec_i,

    output logic ram_clk_o,
    output logic ram_arst_no,

    input  logic glob_arst_ni,
    output logic glob_arst_no
);

  logic [          NUM_CORE-1:0]                   core_clk_en_vec;
  logic [          NUM_CORE-1:0]                   core_arst_vec;

  logic [          NUM_CORE-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o;
  logic [          NUM_CORE-1:0]                   core_pll_locked;

  logic                                            ram_clk_en;
  logic                                            ram_arst;

  logic [      FB_DIV_WIDTH-1:0]                   ram_pll_fb_div_o;
  logic                                            ram_pll_locked;

  logic                                            glob_arst;

  logic [$clog2(NUM_CORE+1)-1:0]                   sys_pll_select;
  logic [$clog2(NUM_CORE+1)-1:0]                   sys_pll_select_next;

  logic [          NUM_CORE-1:0]                   core_clk_vec_pll;
  logic                                            ram_clk_pll;

  logic [          NUM_CORE-1:0]                   filtered_core_clk_vec_pll;
  logic                                            filtered_ram_clk_pll;


  always_comb glob_arst_no = glob_arst_ni & (~glob_arst);
  always_comb ram_arst_no = glob_arst_no & (~ram_arst);
  always_comb begin
    for (int core = 0; core < NUM_CORE; core++) begin
      core_arst_vec_no[core] = glob_arst_no & (~core_arst_vec[core]);
    end
  end

  soc_ctrl_csr #(
      .NUM_CORE(NUM_CORE),
      .MEM_BASE(MEM_BASE),
      .XLEN(XLEN),
      .FB_DIV_WIDTH(FB_DIV_WIDTH),
      .TEMP_SENSOR_WIDTH(TEMP_SENSOR_WIDTH),
      .req_t(req_t),
      .resp_t(resp_t)
  ) u_csr (
      .clk_i(sys_clk_o),
      .arst_ni(glob_arst_no),
      .req_i,
      .resp_o,
      .boot_addr_vec_o,
      .hart_id_vec_o,
      .core_clk_en_vec_o(core_clk_en_vec),
      .core_arst_vec_o(core_arst_vec),
      .core_pll_fb_div_vec_o,
      .core_pll_locked_i(core_pll_locked),
      .core_temp_sensor_vec_i,
      .ram_clk_en_o(ram_clk_en),
      .ram_arst_o(ram_arst),
      .ram_pll_fb_div_o,
      .ram_pll_locked_i(ram_pll_locked),
      .glob_arst_o(glob_arst),
      .sys_pll_select_i(sys_pll_select)
  );

  for (genvar core = 0; core < NUM_CORE; core++) begin : g_pll_cores
    pll #(
        .REF_DEV_WIDTH(5),
        .FB_DIV_WIDTH (FB_DIV_WIDTH)
    ) u_pll_core (
        .arst_ni(core_arst_vec_no[core]),
        .clk_ref_i(xtal_i),
        .refdiv_i(5'd16),
        .fbdiv_i(core_pll_fb_div_vec_o[core]),
        .clk_o(core_clk_vec_pll[core]),
        .locked_o(core_pll_locked[core])
    );
  end

  for (genvar core = 0; core < NUM_CORE; core++) begin : g_cg_f_cores
    clk_gate u_cg_core_f (
        .arst_ni(core_arst_vec_no[core]),
        .en_i(core_pll_locked[core]),
        .clk_i(core_clk_vec_pll[core]),
        .clk_o(filtered_core_clk_vec_pll[core])
    );
  end

  for (genvar core = 0; core < NUM_CORE; core++) begin : g_cg_cores
    clk_gate u_cg_core (
        .arst_ni(core_arst_vec_no[core]),
        .en_i(core_clk_en_vec[core]),
        .clk_i(filtered_core_clk_vec_pll[core]),
        .clk_o(core_clk_vec_o[core])
    );
  end

  pll #(
      .REF_DEV_WIDTH(5),
      .FB_DIV_WIDTH (FB_DIV_WIDTH)
  ) u_pll_ram (
      .arst_ni(ram_arst_no),
      .clk_ref_i(xtal_i),
      .refdiv_i(5'd16),
      .fbdiv_i(ram_pll_fb_div_o),
      .clk_o(ram_clk_pll),
      .locked_o(ram_pll_locked)
  );

  clk_gate u_cg_ram_f (
      .arst_ni(ram_arst_no),
      .en_i(ram_pll_locked),
      .clk_i(ram_clk_pll),
      .clk_o(filtered_ram_clk_pll)
  );

  clk_gate u_cg_ram (
      .arst_ni(ram_arst_no),
      .en_i(ram_clk_en),
      .clk_i(filtered_ram_clk_pll),
      .clk_o(ram_clk_o)
  );

  always_comb begin
    logic [FB_DIV_WIDTH-1:0] current_max_value;
    current_max_value   = ram_pll_fb_div_o;
    sys_pll_select_next = 4;
    for (int i = 0; i < NUM_CORE; i++) begin
      if (core_pll_fb_div_vec_o[i] > current_max_value) begin
        current_max_value   = core_pll_fb_div_vec_o[i];
        sys_pll_select_next = i;
      end
    end
  end

  always_ff @(posedge xtal_i or negedge glob_arst_no) begin
    if (~glob_arst_no) begin
      sys_pll_select <= '0;
    end else begin
      sys_pll_select <= sys_pll_select_next;
    end
  end

/////////////////// FILTERED CLOCKS ONLY //////////////
//                                                   //
//   CORE_0                                          //
//         \                                         //
//          CLOCK_LINE_0                             //
//         /            \                            //
//   CORE_1              \                           //
//                        \                          //
//                         CLOCK_LINE_2              //
//                        /            \             //
//   CORE_2              /              \            //
//         \            /                \           //
//          CLOCK_LINE_1                  \          //
//         /                               SYS_CLK   //
//   CORE_3                                /         //
//                                        /          //
//                                       /           //
//                                      /            //
//                                   RAM             //
//                                                   //
///////////////////////////////////////////////////////

  logic clk_l0;
  logic clk_l1;
  logic clk_l2;

  clk_mux cl_0 (
    .arst_ni(glob_arst_no),
    .sel_i(sys_pll_select[0]),
    .clk0_i(filtered_core_clk_vec_pll[0]),
    .clk1_i(filtered_core_clk_vec_pll[1]),
    .clk_o(clk_l0)
  );

  clk_mux cl_1 (
    .arst_ni(glob_arst_no),
    .sel_i(sys_pll_select[0]),
    .clk0_i(filtered_core_clk_vec_pll[2]),
    .clk1_i(filtered_core_clk_vec_pll[3]),
    .clk_o(clk_l1)
  );

  clk_mux cl_2 (
    .arst_ni(glob_arst_no),
    .sel_i(sys_pll_select[1]),
    .clk0_i(clk_l0),
    .clk1_i(clk_l1),
    .clk_o(clk_l2)
  );

  clk_mux cl_f (
    .arst_ni(glob_arst_no),
    .sel_i(sys_pll_select[2]),
    .clk0_i(clk_l2),
    .clk1_i(filtered_ram_clk_pll),
    .clk_o(sys_clk_o)
  );

endmodule
