`include "rvfi_types.svh"
`include "cvxif_types.svh"

module csr_regfile_wrapper;
    import ariane_pkg::*;
    import config_pkg::*;

    localparam int unsigned NZNrCommitPorts         = 8;
    localparam int unsigned NZXLEN                  = 64;
    localparam int unsigned NZVLEN                  = 64;
    localparam int unsigned NZPLEN                  = 64;
    localparam int unsigned NZGPLEN                 = 64;
    localparam int unsigned NZPPNW                  = 64;
    localparam int unsigned NZASID_WIDTH            = 4;
    localparam int unsigned NZVMID_WIDTH            = 4;
    localparam int unsigned NZTRANS_ID_BITS         = 64;
    localparam int unsigned NZNrPMPEntries          = 64;
    localparam config_pkg::cva6_cfg_t CVA6Cfg = config_pkg::cva6_cfg_empty;

    localparam type exception_t = struct packed {
      logic [NZXLEN-1:0] cause;
      logic [NZXLEN-1:0] tval;
      logic [NZGPLEN-1:0] tval2;
      logic [31:0] tinst;
      logic gva;
      logic valid;
    };

    localparam type irq_ctrl_t = struct packed {
      logic [NZXLEN-1:0] mie;
      logic [NZXLEN-1:0] mip;
      logic [NZXLEN-1:0] mideleg;
      logic [NZXLEN-1:0] hideleg;
      logic                    sie;
      logic                    global_enable;
    };

    localparam type branchpredict_sbe_t = struct packed {
      cf_t                     cf;
      logic [NZVLEN-1:0] predict_address;
    };

    localparam type scoreboard_entry_t = struct packed {
      logic [NZVLEN-1:0] pc;
      logic [NZTRANS_ID_BITS-1:0] trans_id;
      fu_t fu;
      fu_op op;
      logic [REG_ADDR_SIZE-1:0] rs1;
      logic [REG_ADDR_SIZE-1:0] rs2;
      logic [REG_ADDR_SIZE-1:0] rd;
      logic [NZXLEN-1:0] result;
      logic valid;
      logic use_imm;
      logic use_zimm;
      logic use_pc;
      exception_t ex;
      branchpredict_sbe_t bp;
      logic                     is_compressed;
      logic is_macro_instr;
      logic is_last_macro_instr;
      logic is_double_rd_macro_instr;
      logic vfp;
    };

    parameter type rvfi_probes_csr_t = `RVFI_PROBES_CSR_T(CVA6Cfg);
    localparam int                    VmidWidth          = 1;
    localparam int unsigned           MHPMCounterNum     = 6;

    logic clk_i;
    logic rst_ni;
    logic time_irq_i;
    logic flush_o;
    logic halt_csr_o;
    scoreboard_entry_t commit_instr_i;
    logic [NZNrCommitPorts-1:0] commit_ack_i;
    logic [NZVLEN-1:0] boot_addr_i;
    logic [NZXLEN-1:0] hart_id_i;
    exception_t ex_i;
    fu_op csr_op_i;
    logic [11:0] csr_addr_i;
    logic [NZXLEN-1:0] csr_wdata_i;
    logic [NZXLEN-1:0] csr_rdata_o;
    logic dirty_fp_state_i;
    logic csr_write_fflags_i;
    logic dirty_v_state_i;
    logic [NZVLEN-1:0] pc_i;
    exception_t csr_exception_o;
    logic [NZVLEN-1:0] epc_o;
    logic eret_o;
    logic [NZVLEN-1:0] trap_vector_base_o;
    riscv::priv_lvl_t priv_lvl_o;
    logic v_o;
    logic [4:0] acc_fflags_ex_i;
    logic acc_fflags_ex_valid_i;
    riscv::xs_t fs_o;
    riscv::xs_t vfs_o;
    logic [4:0] fflags_o;
    logic [2:0] frm_o;
    logic [6:0] fprec_o;
    riscv::xs_t vs_o;
    irq_ctrl_t irq_ctrl_o;
    logic en_translation_o;
    logic en_g_translation_o;
    logic en_ld_st_translation_o;
    logic en_ld_st_g_translation_o;
    riscv::priv_lvl_t ld_st_priv_lvl_o;
    logic ld_st_v_o;
    logic csr_hs_ld_st_inst_i;
    logic sum_o;
    logic vs_sum_o;
    logic mxr_o;
    logic vmxr_o;
    logic [NZPPNW-1:0] satp_ppn_o;
    logic [NZASID_WIDTH-1:0] asid_o;
    logic [NZPPNW-1:0] vsatp_ppn_o;
    logic [NZASID_WIDTH-1:0] vs_asid_o;
    logic [NZPPNW-1:0] hgatp_ppn_o;
    logic [NZVMID_WIDTH-1:0] vmid_o;
    logic [1:0] irq_i;
    logic ipi_i;
    logic debug_req_i;
    logic set_debug_pc_o;
    logic tvm_o;
    logic tw_o;
    logic vtw_o;
    logic tsr_o;
    logic hu_o;
    logic debug_mode_o;
    logic single_step_o;
    logic icache_en_o;
    logic dcache_en_o;
    logic acc_cons_en_o;
    logic [11:0] perf_addr_o;
    logic [NZXLEN-1:0] perf_data_o;
    logic [NZXLEN-1:0] perf_data_i;
    logic perf_we_o;
    riscv::pmpcfg_t [(NZNrPMPEntries > 0 ? NZNrPMPEntries-1 : 0):0] pmpcfg_o;
    logic [(NZNrPMPEntries > 0 ? NZNrPMPEntries-1 : 0):0][NZPLEN-3:0] pmpaddr_o;
    logic [31:0] mcountinhibit_o;
    rvfi_probes_csr_t rvfi_csr_;

    csr_regfile #(
      .CVA6Cfg           (CVA6Cfg),
      .NZNrCommitPorts   (NZNrCommitPorts),
      .NZXLEN            (NZXLEN),
      .NZVLEN            (NZVLEN),
      .NZPLEN            (NZPLEN),
      .NZGPLEN           (NZGPLEN),
      .NZPPNW            (NZPPNW),
      .NZASID_WIDTH      (NZASID_WIDTH),
      .NZVMID_WIDTH      (NZVMID_WIDTH),
      .NZTRANS_ID_BITS   (NZTRANS_ID_BITS),
      .NZNrPMPEntries    (NZNrPMPEntries),
      .exception_t       (exception_t),
      .irq_ctrl_t        (irq_ctrl_t),
      .scoreboard_entry_t(scoreboard_entry_t),
      .rvfi_probes_csr_t (rvfi_probes_csr_t),
      .MHPMCounterNum    (MHPMCounterNum)
  ) csr_regfile_i (
      .clk_i,
      .rst_ni,
      .time_irq_i,
      .flush_o                 (flush_o),
      .halt_csr_o              (halt_csr_o),
      .commit_instr_i          (commit_instr_i),
      .commit_ack_i            (commit_ack_i),
      .boot_addr_i             (boot_addr_i),
      .hart_id_i               (hart_id_i),
      .ex_i                    (ex_i),
      .csr_op_i                (csr_op_i),
      .csr_addr_i              (csr_addr_i),
      .csr_wdata_i             (csr_wdata_i),
      .csr_rdata_o             (csr_rdata_o),
      .dirty_fp_state_i        (dirty_fp_state_i),
      .csr_write_fflags_i      (csr_write_fflags_i),
      .dirty_v_state_i         (dirty_v_state_i),
      .pc_i                    (pc_i),
      .csr_exception_o         (csr_exception_o),
      .epc_o                   (epc_o),
      .eret_o                  (eret_o),
      .trap_vector_base_o      (trap_vector_base_o),
      .priv_lvl_o              (priv_lvl_o),
      .v_o                     (v_o),
      .acc_fflags_ex_i         (acc_fflags_ex_i),
      .acc_fflags_ex_valid_i   (acc_fflags_ex_valid_i),
      .fs_o                    (fs_o),
      .vfs_o                   (vfs_o),
      .fflags_o                (fflags_o),
      .frm_o                   (frm_o),
      .fprec_o                 (fprec_o),
      .vs_o                    (vs_o),
      .irq_ctrl_o              (irq_ctrl_o),
      .en_translation_o        (en_translation_o),
      .en_g_translation_o      (en_g_translation_o),
      .en_ld_st_translation_o  (en_ld_st_translation_o),
      .en_ld_st_g_translation_o(en_ld_st_g_translation_o),
      .ld_st_priv_lvl_o        (ld_st_priv_lvl_o),
      .ld_st_v_o               (ld_st_v_o),
      .csr_hs_ld_st_inst_i     (csr_hs_ld_st_inst_i),
      .sum_o                   (sum_o),
      .vs_sum_o                (vs_sum_o),
      .mxr_o                   (mxr_o),
      .vmxr_o                  (vmxr_o),
      .satp_ppn_o              (satp_ppn_o),
      .asid_o                  (asid_o),
      .vsatp_ppn_o             (vsatp_ppn_o),
      .vs_asid_o               (vs_asid_o),
      .hgatp_ppn_o             (hgatp_ppn_o),
      .vmid_o                  (vmid_o),
      .irq_i,
      .ipi_i,
      .debug_req_i,
      .set_debug_pc_o          (set_debug_pc_o),
      .tvm_o                   (tvm_o),
      .tw_o                    (tw_o),
      .vtw_o                   (vtw_o),
      .tsr_o                   (tsr_o),
      .hu_o                    (hu_o),
      .debug_mode_o            (debug_mode_o),
      .single_step_o           (single_step_o),
      .icache_en_o             (icache_en_o),
      .dcache_en_o             (dcache_en_o),
      .acc_cons_en_o           (acc_cons_en_o),
      .perf_addr_o             (perf_addr_o),
      .perf_data_o             (perf_data_o),
      .perf_data_i             (perf_data_i),
      .perf_we_o               (perf_we_o),
      .pmpcfg_o                (pmpcfg_o),
      .pmpaddr_o               (pmpaddr_o),
      .mcountinhibit_o         (mcountinhibit_o),
      .rvfi_csr_o              (rvfi_csr_o)
  );

endmodule
