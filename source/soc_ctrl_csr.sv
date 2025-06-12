module soc_ctrl_csr #(
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
    output logic [NUM_CORES-1:0]                   core_clk_en_o,
    output logic [NUM_CORES-1:0]                   core_arst_o,
    output logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_o,
    input  logic [NUM_CORES-1:0]                   core_pll_locked_i,
    input  logic [NUM_CORES-1:0][FB_DIV_WIDTH-1:0] core_pll_fb_div_vec_i,

    output logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_o,
    input  logic                    ram_pll_locked_i,
    input  logic [FB_DIV_WIDTH-1:0] ram_pll_fb_div_i,

    output logic glob_arst_o,

    output logic [NUM_GPR-1:0] grp_o
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

  // ################## OTHER PLL FB DIV #################
  // PLL FB DIV RAM ----------------------------- 0x600 RW

  // ############### ACTUAL CORE PLL FB DIV ##############
  // PLL FB DIV CORE_0 -------------------------- 0x800 RO
  // PLL FB DIV CORE_1 -------------------------- 0x808 RO
  // PLL FB DIV CORE_2 -------------------------- 0x810 RO
  // PLL FB DIV CORE_3 -------------------------- 0x818 RO

  // ############## ACTUAL OTHER PLL FB DIV ##############
  // PLL FB DIV RAM ----------------------------- 0xA00 RO

  // ######################## CSR ########################
  // CORE PLL LOCKED ---------------------------- 0xE00 RO
  // OTHER PLL LOCKED --------------------------- 0xE08 RO
  // CORE CLOCK ENABLE -------------------------- 0xE10 RW
  // CORE RESET --------------------------------- 0xE20 RW
  // SOFTWARE GLOBAL RESET ---------------------- 0xE30 RW
  // REG0 --------------------------------------- 0xFE0 RW
  // REG1 --------------------------------------- 0xFE8 RW
  // REG2 --------------------------------------- 0xFF0 RW
  // REG3 --------------------------------------- 0xFF8 RW

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
      // OTHER PLL FB DIV --------------------------------------------------------------------------
      3'b011: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, ram_pll_fb_div_o};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // ACTUAL CORE PLL FB DIV --------------------------------------------------------------------
      3'b100: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_pll_fb_div_vec_i[0]};
          1: mem_rdata_i = {'0, core_pll_fb_div_vec_i[1]};
          2: mem_rdata_i = {'0, core_pll_fb_div_vec_i[2]};
          3: mem_rdata_i = {'0, core_pll_fb_div_vec_i[3]};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // ACTUAL OTHER PLL FB DIV -------------------------------------------------------------------
      3'b101: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, ram_pll_fb_div_i};
          default: mem_rresp_i = 2'b10;
        endcase
      end
      // CSR ---------------------------------------------------------------------------------------
      3'b111: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_i = {'0, core_pll_locked_i};
          1: mem_rdata_i = {'0, ram_pll_locked_i};
          2: mem_rdata_i = {'0, core_clk_en_o};
          4: mem_rdata_i = {'0, core_arst_o};
          6: mem_rdata_i = {'0, glob_arst_o};
          60: mem_rdata_i = grp_o[0];
          61: mem_rdata_i = grp_o[1];
          62: mem_rdata_i = grp_o[2];
          63: mem_rdata_i = grp_o[3];
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
    case (mem_raddr_o[11:9])
      // BOOT ADDR ---------------------------------------------------------------------------------
      3'b000: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_ = boot_addr_vec_o[0];
          1: mem_rdata_ = boot_addr_vec_o[1];
          2: mem_rdata_ = boot_addr_vec_o[2];
          3: mem_rdata_ = boot_addr_vec_o[3];
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // HART ID -----------------------------------------------------------------------------------
      3'b001: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_ = hart_id_vec_o[0];
          1: mem_rdata_ = hart_id_vec_o[1];
          2: mem_rdata_ = hart_id_vec_o[2];
          3: mem_rdata_ = hart_id_vec_o[3];
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // CORE PLL FB DIV ---------------------------------------------------------------------------
      3'b010: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_ = {'0, core_pll_fb_div_vec_o[0]};
          1: mem_rdata_ = {'0, core_pll_fb_div_vec_o[1]};
          2: mem_rdata_ = {'0, core_pll_fb_div_vec_o[2]};
          3: mem_rdata_ = {'0, core_pll_fb_div_vec_o[3]};
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // OTHER PLL FB DIV --------------------------------------------------------------------------
      3'b011: begin
        case (mem_raddr_o[8:3])
          0: mem_rdata_ = {'0, ram_pll_locked_i};
          default: mem_wresp_i = 2'b10;
        endcase
      end
      // CSR ---------------------------------------------------------------------------------------
      3'b111: begin
        case (mem_raddr_o[8:3])
          2: mem_rdata_ = {'0, core_clk_en_o};
          4: mem_rdata_ = {'0, core_arst_o};
          6: mem_rdata_ = {'0, glob_arst_o};
          60: mem_rdata_ = grp_o[0];
          61: mem_rdata_ = grp_o[1];
          62: mem_rdata_ = grp_o[2];
          63: mem_rdata_ = grp_o[3];
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
      core_clk_en_o         <= '0;
      core_arst_o           <= '0;
      core_pll_fb_div_vec_o <= '0;
      glob_arst_o           <= '0;
      grp_o                 <= '0;
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
        // OTHER PLL FB DIV ------------------------------------------------------------------------
        3'b011: begin
          case (mem_waddr_o[8:3])
            0: ram_pll_fb_div_o <= mem_wdata_;
          endcase
        end
        // CSR -------------------------------------------------------------------------------------
        3'b111: begin
          case (mem_waddr_o[8:3])
            2:  core_clk_en_o <= mem_wdata_;
            4:  core_arst_o <= mem_wdata_;
            6:  glob_arst_o <= mem_wdata_;
            60: grp_o[0] <= mem_wdata_;
            61: grp_o[1] <= mem_wdata_;
            62: grp_o[2] <= mem_wdata_;
            63: grp_o[3] <= mem_wdata_;
          endcase
        end
      endcase
    end
  end


endmodule
