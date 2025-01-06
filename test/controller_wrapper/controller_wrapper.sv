`include "rvfi_types.svh"
`include "cvxif_types.svh"

module controller_wrapper;
  import ariane_pkg::*;

  localparam config_pkg::cva6_cfg_t CVA6Cfg = build_config_pkg::build_config(
      cva6_config_pkg::cva6_cfg
  );

  localparam type bp_resolve_t = struct packed {
    logic                    valid;
    logic [CVA6Cfg.VLEN-1:0] pc;
    logic [CVA6Cfg.VLEN-1:0] target_address;
    logic                    is_mispredict;
    logic                    is_taken;
    cf_t                     cf_type;
  };

  logic        clk_i;
  logic        rst_ni;
  logic        v_i;
  logic        set_pc_commit_o;
  logic        flush_if_o;
  logic        flush_unissued_instr_o;
  logic        flush_id_o;
  logic        flush_ex_o;
  logic        flush_bp_o;
  logic        flush_icache_o;
  logic        flush_dcache_o;
  logic        flush_dcache_ack_i;
  logic        flush_tlb_o;
  logic        flush_tlb_vvma_o;
  logic        flush_tlb_gvma_o;
  logic        halt_csr_i;
  logic        halt_acc_i;
  logic        halt_o;
  logic        eret_i;
  logic        ex_valid_i;
  logic        set_debug_pc_i;
  bp_resolve_t resolved_branch_i;
  logic        flush_csr_i;
  logic        fence_i_i;
  logic        fence_i;
  logic        sfence_vma_i;
  logic        hfence_vvma_i;
  logic        hfence_gvma_i;
  logic        flush_commit_i;
  logic        flush_acc_i;

  controller #(
      .CVA6Cfg(CVA6Cfg),
      .bp_resolve_t(bp_resolve_t)
  ) controller_i (
      .clk_i,
      .rst_ni,
      // virtualization mode
      .v_i                   (v_i),
      .set_pc_commit_o       (set_pc_commit_o),
      .flush_if_o            (flush_if_o),
      .flush_unissued_instr_o(flush_unissued_instr_o),
      .flush_id_o            (flush_id_o),
      .flush_ex_o            (flush_ex_o),
      .flush_bp_o            (flush_bp_o),
      .flush_icache_o        (flush_icache_o),
      .flush_dcache_o        (flush_dcache_o),
      .flush_dcache_ack_i    (flush_dcache_ack_i),
      .flush_tlb_o           (flush_tlb_o),
      .flush_tlb_vvma_o      (flush_tlb_vvma_o),
      .flush_tlb_gvma_o      (flush_tlb_gvma_o),
      .halt_csr_i            (halt_csr_i),
      .halt_acc_i            (halt_acc_i),
      .halt_o                (halt_o),
      .eret_i                (eret_i),
      .ex_valid_i            (ex_valid_i),
      .set_debug_pc_i        (set_debug_pc_i),
      .resolved_branch_i     (resolved_branch_i),
      .flush_csr_i           (flush_csr_i),
      .fence_i_i             (fence_i_i),
      .fence_i               (fence_i),
      .sfence_vma_i          (sfence_vma_i),
      .hfence_vvma_i         (hfence_vvma_i),
      .hfence_gvma_i         (hfence_gvma_i),
      .flush_commit_i        (flush_commit_i),
      .flush_acc_i           (flush_acc_i)
  );
endmodule
