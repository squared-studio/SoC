module soc_ctrl_csr #(
    parameter int          NUM_CORE          = 4,
    parameter logic [63:0] MEM_BASE          = 0,
    parameter int          XLEN              = 64,
    parameter int          FB_DIV_WIDTH      = 12,
    parameter int          TEMP_SENSOR_WIDTH = 10,
    parameter int          NUM_GPR           = 4,
    parameter type         req_t             = soc_pkg::s_req_t,
    parameter type         resp_t            = soc_pkg::s_resp_t
) (
    input  logic  clk_i,
    input  logic  arst_ni,
    input  req_t  req_i,
    output resp_t resp_o,

    output logic [NUM_CORE-1:0][             XLEN-1:0] boot_addr_vec_o,
    output logic [NUM_CORE-1:0][             XLEN-1:0] hart_id_vec_o,
    output logic [NUM_CORE-1:0]                        core_clk_en_vec_o,
    output logic [NUM_CORE-1:0]                        core_arst_vec_o,
    output logic [NUM_CORE-1:0][     FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o,
    input  logic [NUM_CORE-1:0]                        core_pll_locked_i,
    input  logic [NUM_CORE-1:0][     FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_i,
    input  logic [NUM_CORE-1:0][TEMP_SENSOR_WIDTH-1:0] core_temp_sensor_vec_i,

    output logic                    ram_clk_en_o,
    output logic                    ram_arst_o,
    output logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_o,
    input  logic                    ram_pll_locked_i,
    input  logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_i,

    output logic                        glob_arst_o,
    input  logic [$clog2(NUM_CORE)-1:0] sys_pll_select_i
);

  // ######################## BOOT #######################
  // BOOT_ADDR CORE_0 --------------------------- 0x000 RW
  // BOOT_ADDR CORE_1 --------------------------- 0x008 RW
  // BOOT_ADDR CORE_2 --------------------------- 0x010 RW
  // BOOT_ADDR CORE_3 --------------------------- 0x018 RW

  // ###################### HART ID ######################
  // HART ID CORE_0 ----------------------------- 0x200 RW
  // HART ID CORE_1 ----------------------------- 0x208 RW
  // HART ID CORE_2 ----------------------------- 0x210 RW
  // HART ID CORE_3 ----------------------------- 0x218 RW

  // ################## CORE PLL FB DIV ##################
  // PLL FB DIV CORE_0 -------------------------- 0x400 RW
  // PLL FB DIV CORE_1 -------------------------- 0x408 RW
  // PLL FB DIV CORE_2 -------------------------- 0x410 RW
  // PLL FB DIV CORE_3 -------------------------- 0x418 RW

  // ############### ACTUAL CORE PLL FB DIV ##############
  // PLL FB DIV CORE_0 -------------------------- 0x600 RO
  // PLL FB DIV CORE_1 -------------------------- 0x608 RO
  // PLL FB DIV CORE_2 -------------------------- 0x610 RO
  // PLL FB DIV CORE_3 -------------------------- 0x618 RO

  // ################## OTHER PLL FB DIV #################
  // PLL FB DIV RAM ----------------------------- 0x800 RW

  // ############## ACTUAL OTHER PLL FB DIV ##############
  // PLL FB DIV RAM ----------------------------- 0x900 RO

  // ################# CORE TEMP SENSORS #################
  // TEMP SENSORS CORE_0 ------------------------ 0xC00 RO
  // TEMP SENSORS CORE_0 ------------------------ 0xC08 RO
  // TEMP SENSORS CORE_0 ------------------------ 0xC10 RO
  // TEMP SENSORS CORE_0 ------------------------ 0xC18 RO

  // ######################## CSR ########################
  // CORE PLL LOCKED ---------------------------- 0xE00 RO
  // OTHER PLL LOCKED --------------------------- 0xE08 RO
  // CORE CLOCK ENABLE -------------------------- 0xE10 RW
  // OTHER CLOCK ENABLE ------------------------- 0xE18 RW
  //   ram ----------------------------------- b0
  // CORE RESET --------------------------------- 0xE20 RW
  // OTHER RESET -------------------------------- 0xE28 RW
  //   ram ----------------------------------- b0
  // SOFTWARE GLOBAL RESET ---------------------- 0xE30 RW
  // SYSTEM PLL SELECT -------------------------- 0xE38 RO

  logic             mem_we_o;
  logic [11:0]      mem_waddr_o;
  logic [ 7:0][7:0] mem_wdata_o;
  logic [ 7:0]      mem_wstrb_o;
  logic [ 1:0]      mem_wresp_i;

  logic             mem_re_o;
  logic [11:0]      mem_raddr_o;
  logic [ 7:0][7:0] mem_rdata_i;
  logic [ 1:0]      mem_rresp_i;

  logic [ 7:0][7:0] mem_rdata_;
  logic [ 7:0][7:0] mem_wdata_;

  axi_to_simple_if #(
      .axi_req_t (req_t),
      .axi_resp_t(resp_t),
      .MEM_BASE  (MEM_BASE),
      .MEM_SIZE  (12)
  ) u_cvt (
      .arst_ni,
      .clk_i,
      .req_i,
      .resp_o,
      .mem_we_o,
      .mem_waddr_o,
      .mem_wdata_o,
      .mem_wstrb_o,
      .mem_wresp_i,
      .mem_re_o,
      .mem_raddr_o,
      .mem_rdata_i,
      .mem_rresp_i
  );

  always_comb begin : read_head
    mem_rdata_i = '0;
    mem_rresp_i = '0;
    case (mem_raddr_o[11:9])
      // BOOT ADDR ---------------------------------------------------------------------------------
      3'b000: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = boot_addr_vec_o[0];
          1: mem_rdata_i = boot_addr_vec_o[1];
          2: mem_rdata_i = boot_addr_vec_o[2];
          3: mem_rdata_i = boot_addr_vec_o[3];
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // HART ID -----------------------------------------------------------------------------------
      3'b001: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = hart_id_vec_o[0];
          1: mem_rdata_i = hart_id_vec_o[1];
          2: mem_rdata_i = hart_id_vec_o[2];
          3: mem_rdata_i = hart_id_vec_o[3];
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // CORE PLL FB DIV ---------------------------------------------------------------------------
      3'b010: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_pll_fb_div_vec_o[0]};
          1: mem_rdata_i = {'0, core_pll_fb_div_vec_o[1]};
          2: mem_rdata_i = {'0, core_pll_fb_div_vec_o[2]};
          3: mem_rdata_i = {'0, core_pll_fb_div_vec_o[3]};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // ACTUAL CORE PLL FB DIV --------------------------------------------------------------------
      3'b011: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_pll_fb_div_vec_i[0]};
          1: mem_rdata_i = {'0, core_pll_fb_div_vec_i[1]};
          2: mem_rdata_i = {'0, core_pll_fb_div_vec_i[2]};
          3: mem_rdata_i = {'0, core_pll_fb_div_vec_i[3]};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // OTHER PLL FB DIV + ACTUAL -----------------------------------------------------------------
      3'b100: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, ram_pll_fb_div_o};
          32: mem_rdata_i = {'0, ram_pll_fb_div_i};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // CORE TEMP SENSORS -------------------------------------------------------------------------
      3'b110: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_temp_sensor_vec_i[0]};
          1: mem_rdata_i = {'0, core_temp_sensor_vec_i[1]};
          2: mem_rdata_i = {'0, core_temp_sensor_vec_i[2]};
          3: mem_rdata_i = {'0, core_temp_sensor_vec_i[3]};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // CSR ---------------------------------------------------------------------------------------
      3'b111: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_pll_locked_i};
          1: mem_rdata_i = {'0, ram_pll_locked_i};
          2: mem_rdata_i = {'0, core_clk_en_vec_o};
          3: mem_rdata_i = {'0, ram_clk_en_o};
          4: mem_rdata_i = {'0, core_arst_vec_o};
          5: mem_rdata_i = {'0, ram_arst_o};
          6: mem_rdata_i = {'0, glob_arst_o};
          7: mem_rdata_i = {'0, sys_pll_select_i};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // ERROR -------------------------------------------------------------------------------------
      default: begin
        mem_rresp_i = 2'b10;
      end
    endcase
  end


  always_comb begin : strb_head
    mem_rdata_  = '0;
    mem_wresp_i = '0;
    case (mem_waddr_o[11:9])
      // BOOT ADDR ---------------------------------------------------------------------------------
      3'b000: begin
        case (mem_waddr_o[8:3])
          0: mem_rdata_ = boot_addr_vec_o[0];
          1: mem_rdata_ = boot_addr_vec_o[1];
          2: mem_rdata_ = boot_addr_vec_o[2];
          3: mem_rdata_ = boot_addr_vec_o[3];
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // HART ID -----------------------------------------------------------------------------------
      3'b001: begin
        case (mem_waddr_o[8:3])
          0: mem_rdata_ = hart_id_vec_o[0];
          1: mem_rdata_ = hart_id_vec_o[1];
          2: mem_rdata_ = hart_id_vec_o[2];
          3: mem_rdata_ = hart_id_vec_o[3];
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // CORE PLL FB DIV ---------------------------------------------------------------------------
      3'b010: begin
        case (mem_waddr_o[8:3])
          0: mem_rdata_ = {'0, core_pll_fb_div_vec_o[0]};
          1: mem_rdata_ = {'0, core_pll_fb_div_vec_o[1]};
          2: mem_rdata_ = {'0, core_pll_fb_div_vec_o[2]};
          3: mem_rdata_ = {'0, core_pll_fb_div_vec_o[3]};
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // OTHER PLL FB DIV + ACTUAL -----------------------------------------------------------------
      3'b100: begin
        case (mem_waddr_o[8:3])
          0: mem_rdata_ = {'0, ram_pll_fb_div_o};
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // CSR ---------------------------------------------------------------------------------------
      3'b111: begin
        case (mem_waddr_o[8:3])
          2: mem_rdata_ = {'0, core_clk_en_vec_o};
          3: mem_rdata_ = {'0, ram_clk_en_o};
          4: mem_rdata_ = {'0, core_arst_vec_o};
          5: mem_rdata_ = {'0, ram_arst_o};
          6: mem_rdata_ = {'0, glob_arst_o};
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // ERROR -------------------------------------------------------------------------------------
      default: begin
        mem_wresp_i = 2'b10;
      end
    endcase
  end

  always_comb begin : write_value
    foreach (mem_wstrb_o[i]) mem_wdata_[i] = mem_wstrb_o[i] ? mem_wdata_o[i] : mem_rdata_[i];
  end

  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      boot_addr_vec_o       <= '0;
      hart_id_vec_o         <= '0;
      core_clk_en_vec_o     <= '0;
      core_arst_vec_o       <= '0;
      core_pll_fb_div_vec_o <= '0;
      ram_clk_en_o          <= '0;
      ram_arst_o            <= '0;
      ram_pll_fb_div_o      <= '0;
      glob_arst_o           <= '0;
    end else if (mem_we_o && (mem_wresp_i == 0)) begin
      case (mem_waddr_o[11:9])
        // BOOT ADDR -------------------------------------------------------------------------------
        3'b000: begin
          case (mem_waddr_o[8:3])
            0: boot_addr_vec_o[0] <= mem_wdata_;
            1: boot_addr_vec_o[1] <= mem_wdata_;
            2: boot_addr_vec_o[2] <= mem_wdata_;
            3: boot_addr_vec_o[3] <= mem_wdata_;
          endcase
        end
        // HART ID ---------------------------------------------------------------------------------
        3'b001: begin
          case (mem_waddr_o[8:3])
            0: hart_id_vec_o[0] <= mem_wdata_;
            1: hart_id_vec_o[1] <= mem_wdata_;
            2: hart_id_vec_o[2] <= mem_wdata_;
            3: hart_id_vec_o[3] <= mem_wdata_;
          endcase
        end
        // CORE PLL FB DIV -------------------------------------------------------------------------
        3'b010: begin
          case (mem_waddr_o[8:3])
            0: core_pll_fb_div_vec_o[0] <= mem_wdata_;
            1: core_pll_fb_div_vec_o[1] <= mem_wdata_;
            2: core_pll_fb_div_vec_o[2] <= mem_wdata_;
            3: core_pll_fb_div_vec_o[3] <= mem_wdata_;
          endcase
        end
        // OTHER PLL FB DIV + ACTUAL ---------------------------------------------------------------
        3'b100: begin
          case (mem_waddr_o[8:3])
            0: ram_pll_fb_div_o <= mem_wdata_;
          endcase
        end
        // CSR -------------------------------------------------------------------------------------
        3'b111: begin
          case (mem_waddr_o[8:3])
            2: core_clk_en_vec_o <= mem_wdata_;
            3: ram_clk_en_o <= mem_wdata_;
            4: core_arst_vec_o <= mem_wdata_;
            5: ram_arst_o <= mem_wdata_;
            6: glob_arst_o <= mem_wdata_;
          endcase
        end
      endcase
    end
  end

  // // TODO MAKE EXTERNAL

  // logic [$clog2(NUM_CORE)-1:0]      sys_pll_select_next;

  // always_comb begin
  //   logic [FB_DIV_WIDTH-1:0] current_max_value;
  //   current_max_value   = core_pll_fb_div_vec_i[0];
  //   sys_pll_select_next = 0;
  //   for (int i = 1; i < NUM_CORE; i++) begin
  //     if (core_pll_fb_div_vec_i[i] > current_max_value) begin
  //       current_max_value   = core_pll_fb_div_vec_i[i];
  //       sys_pll_select_next = i;
  //     end
  //   end
  // end

  // always_ff @(posedge clk_i or negedge arst_ni) begin
  //   if (~arst_ni) begin
  //     sys_pll_select_i <= '0;
  //   end else begin
  //     sys_pll_select_i <= sys_pll_select_next;
  //   end
  // end

endmodule
