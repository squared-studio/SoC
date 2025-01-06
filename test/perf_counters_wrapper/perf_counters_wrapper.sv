`include "rvfi_types.svh"
`include "cvxif_types.svh"

module perf_counters_wrapper;
    import ariane_pkg::*;
    import config_pkg::*;

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
    localparam type dcache_req_i_t = struct packed {
      logic [CVA6Cfg.DCACHE_INDEX_WIDTH-1:0] address_index;
      logic [CVA6Cfg.DCACHE_TAG_WIDTH-1:0]   address_tag;
      logic [CVA6Cfg.XLEN-1:0]               data_wdata;
      logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0]  data_wuser;
      logic                                  data_req;
      logic                                  data_we;
      logic [(CVA6Cfg.XLEN/8)-1:0]           data_be;
      logic [1:0]                            data_size;
      logic [CVA6Cfg.DcacheIdWidth-1:0]      data_id;
      logic                                  kill_req;
      logic                                  tag_valid;
    };
    localparam type dcache_req_o_t = struct packed {
      logic                                 data_gnt;
      logic                                 data_rvalid;
      logic [CVA6Cfg.DcacheIdWidth-1:0]     data_rid;
      logic [CVA6Cfg.XLEN-1:0]              data_rdata;
      logic [CVA6Cfg.DCACHE_USER_WIDTH-1:0] data_ruser;
    };
    localparam type exception_t = struct packed {
      logic [CVA6Cfg.XLEN-1:0] cause;
      logic [CVA6Cfg.XLEN-1:0] tval;
      logic [CVA6Cfg.GPLEN-1:0] tval2;
      logic [31:0] tinst;
      logic gva;
      logic valid;
    };
    localparam type icache_dreq_t = struct packed {
      logic                    req;
      logic                    kill_s1;
      logic                    kill_s2;
      logic                    spec;
      logic [CVA6Cfg.VLEN-1:0] vaddr;
    };
    localparam type branchpredict_sbe_t = struct packed {
      cf_t                     cf;               // type of control flow prediction
      logic [CVA6Cfg.VLEN-1:0] predict_address;  // target address at which to jump, or not
    };
    localparam type scoreboard_entry_t = struct packed {
      logic [CVA6Cfg.VLEN-1:0] pc;
      logic [CVA6Cfg.TRANS_ID_BITS-1:0] trans_id;
      fu_t fu;
      fu_op op;
      logic [REG_ADDR_SIZE-1:0] rs1;
      logic [REG_ADDR_SIZE-1:0] rs2;
      logic [REG_ADDR_SIZE-1:0] rd;
      logic [CVA6Cfg.XLEN-1:0] result;



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
    localparam int unsigned NumPorts = 3;

    logic clk_i;
    logic rst_ni;
    logic debug_mode_i;
    logic [11:0] addr_i;
    logic we_i;
    logic [CVA6Cfg.XLEN-1:0] data_i;
    scoreboard_entry_t commit_instr_i [CVA6Cfg.NrCommitPorts];
    logic [CVA6Cfg.NrCommitPorts-1:0] commit_ack_i;
    logic l1_icache_miss_i;
    logic l1_dcache_miss_i;
    logic itlb_miss_i;
    logic dtlb_miss_i;
    logic sb_full_i;
    logic if_empty_i;
    exception_t ex_i;
    logic eret_i;
    bp_resolve_t resolved_branch_i;
    exception_t branch_exceptions_i;
    icache_dreq_t l1_icache_access_i;
    dcache_req_i_t l1_dcache_access_i [3];
    logic [NumPorts-1:0][CVA6Cfg.DCACHE_SET_ASSOC-1:0]miss_vld_bits_i;
    logic i_tlb_flush_i;
    logic stall_issue_i;
    logic [31:0] mcountinhibit_i;
    logic [CVA6Cfg.XLEN-1:0] data_o;

    perf_counters #(
        .CVA6Cfg(CVA6Cfg),
        .bp_resolve_t(bp_resolve_t),
        .exception_t(exception_t),
        .scoreboard_entry_t(scoreboard_entry_t),
        .icache_dreq_t(icache_dreq_t),
        .dcache_req_i_t(dcache_req_i_t),
        .dcache_req_o_t(dcache_req_o_t),
        .NumPorts(NumPorts)
    ) perf_counters_i (
        .clk_i              (clk_i),
        .rst_ni             (rst_ni),
        .debug_mode_i       (debug_mode_i),
        .addr_i             (addr_i),
        .we_i               (we_i),
        .data_i             (data_i),
        .data_o             (data_o),
        .commit_instr_i     (commit_instr_i),
        .commit_ack_i       (commit_ack_i),
        .l1_icache_miss_i   (l1_icache_miss_i),
        .l1_dcache_miss_i   (l1_dcache_miss_i),
        .itlb_miss_i        (itlb_miss_i),
        .dtlb_miss_i        (dtlb_miss_i),
        .sb_full_i          (sb_full_i),
        .if_empty_i         (if_empty_i),
        .ex_i               (ex_i),
        .eret_i             (eret_i),
        .resolved_branch_i  (resolved_branch_i),
        .branch_exceptions_i(branch_exceptions_i),
        .l1_icache_access_i (l1_icache_access_i),
        .l1_dcache_access_i (l1_dcache_access_i),
        .miss_vld_bits_i    (miss_vld_bits_i),
        .i_tlb_flush_i      (i_tlb_flush_i),
        .stall_issue_i      (stall_issue_i),
        .mcountinhibit_i    (mcountinhibit_i)
    );

endmodule
