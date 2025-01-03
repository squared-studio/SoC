submodules/cva6/core/cvfpu/src/fpnew_pkg.sv:  localparam fp_encoding_t [0:NUM_FP_FORMATS-1] FP_ENCODINGS  = '{
submodules/cva6/core/cvfpu/src/fpnew_pkg.sv:  typedef unit_type_t [0:NUM_FP_FORMATS-1] fmt_unit_types_t;
submodules/cva6/core/cvfpu/src/fpnew_pkg.sv:  typedef fmt_unit_types_t [0:NUM_OPGROUPS-1] opgrp_fmt_unit_types_t;
submodules/cva6/core/cvfpu/src/fpnew_pkg.sv:  typedef fmt_unsigned_t [0:NUM_OPGROUPS-1] opgrp_fmt_unsigned_t;
submodules/cva6/core/cvfpu/src/fpnew_cast_multi.sv:  fpnew_pkg::int_format_e [0:NUM_INP_REGS]                  inp_pipe_int_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_cast_multi.sv:  fpnew_pkg::fp_info_t [NUM_FORMATS-1:0] info;
submodules/cva6/core/cvfpu/src/fpnew_cast_multi.sv:  fpnew_pkg::int_format_e [0:NUM_MID_REGS]                    mid_pipe_int_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_cast_multi.sv:  fpnew_pkg::status_t [0:NUM_OUT_REGS]            out_pipe_status_q;
submodules/cva6/core/cvfpu/src/fpnew_classifier.sv:  output fpnew_pkg::fp_info_t [NumOperands-1:0]            info_o
submodules/cva6/core/cvfpu/src/fpnew_divsqrt_multi.sv:  fpnew_pkg::roundmode_e [0:NUM_INP_REGS]                       inp_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_divsqrt_multi.sv:  fpnew_pkg::operation_e [0:NUM_INP_REGS]                       inp_pipe_op_q;
submodules/cva6/core/cvfpu/src/fpnew_divsqrt_multi.sv:  fpnew_pkg::fp_format_e [0:NUM_INP_REGS]                       inp_pipe_dst_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_divsqrt_multi.sv:  fpnew_pkg::status_t [0:NUM_OUT_REGS]            out_pipe_status_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::roundmode_e [0:NUM_INP_REGS]                       inp_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::operation_e [0:NUM_INP_REGS]                       inp_pipe_op_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::fp_format_e [0:NUM_INP_REGS]                       inp_pipe_src_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::fp_format_e [0:NUM_INP_REGS]                       inp_pipe_dst_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::fp_info_t [NUM_FORMATS-1:0][2:0] info_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::status_t [NUM_FORMATS-1:0] fmt_special_status;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::roundmode_e [0:NUM_MID_REGS]                         mid_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::fp_format_e [0:NUM_MID_REGS]                         mid_pipe_dst_fmt_q;
submodules/cva6/core/cvfpu/src/fpnew_fma_multi.sv:  fpnew_pkg::status_t [0:NUM_OUT_REGS]            out_pipe_status_q;
submodules/cva6/core/cvfpu/src/fpnew_fma.sv:  fpnew_pkg::roundmode_e [0:NUM_INP_REGS]                 inp_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_fma.sv:  fpnew_pkg::operation_e [0:NUM_INP_REGS]                 inp_pipe_op_q;
submodules/cva6/core/cvfpu/src/fpnew_fma.sv:  fpnew_pkg::fp_info_t [2:0] info_q;
submodules/cva6/core/cvfpu/src/fpnew_fma.sv:  fpnew_pkg::roundmode_e [0:NUM_MID_REGS]                         mid_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_fma.sv:  fpnew_pkg::status_t [0:NUM_OUT_REGS] out_pipe_status_q;
submodules/cva6/core/cvfpu/src/fpnew_noncomp.sv:  fpnew_pkg::roundmode_e [0:NUM_INP_REGS]                 inp_pipe_rnd_mode_q;
submodules/cva6/core/cvfpu/src/fpnew_noncomp.sv:  fpnew_pkg::operation_e [0:NUM_INP_REGS]                 inp_pipe_op_q;
submodules/cva6/core/cvfpu/src/fpnew_noncomp.sv:  fpnew_pkg::fp_info_t [1:0] info_q;
submodules/cva6/core/cvfpu/src/fpnew_noncomp.sv:  fpnew_pkg::classmask_e [0:NUM_OUT_REGS] out_pipe_class_mask_q;
submodules/cva6/core/cvfpu/src/fpnew_opgroup_block.sv:  output_t [NUM_FORMATS-1:0] fmt_outputs;
submodules/cva6/core/cvfpu/src/fpnew_opgroup_fmt_slice.sv:  fpnew_pkg::classmask_e [NUM_LANES-1:0] lane_class_mask;
submodules/cva6/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv:  fpnew_pkg::status_t [NUM_LANES-1:0]   lane_status;
submodules/cva6/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv:  TagType [NUM_LANES-1:0]               lane_tags;
submodules/cva6/core/cvfpu/src/fpnew_top.sv:  output_t [NUM_OPGROUPS-1:0] opgrp_outputs;
submodules/cva6/core/cva6_fifo_v3.sv:  dtype [FifoDepth - 1:0] mem_n, mem_q;
submodules/cva6/core/cvfpu/src/common_cells/src/fifo_v3.sv:    dtype [FifoDepth - 1:0] mem_n, mem_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/fifo_v3.sv:    dtype [FifoDepth - 1:0] mem_n, mem_q;
submodules/cva6/core/cvfpu/src/common_cells/src/stream_arbiter.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/core/cvfpu/src/common_cells/src/stream_arbiter_flushable.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/core/cvfpu/src/common_cells/src/stream_mux.sv:  input  DATA_T [N_INP-1:0]     inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_mux.sv:  input  DATA_T [N_INP-1:0]     inp_data_i,
submodules/cva6/core/cvfpu/src/common_cells/src/rr_arb_tree.sv:  input  DataType [NumIn-1:0] data_i,
submodules/cva6/core/cvfpu/src/common_cells/src/rr_arb_tree.sv:    DataType [2**NumLevels-2:0] data_nodes;
submodules/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv:  input  DataType [NumIn-1:0] data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv:    DataType [2**NumLevels-2:0] data_nodes;
submodules/cva6/core/cvfpu/src/common_cells/src/shift_reg.sv:        dtype [Depth-1:0] reg_d, reg_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/shift_reg.sv:        dtype [Depth-1:0] reg_d, reg_q;
submodules/cva6/core/cva6.sv:  fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_if_id;
submodules/cva6/core/cva6.sv:  scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_entry_id_issue, issue_entry_id_issue_prev;
submodules/cva6/core/cva6.sv:  fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_id_ex;
submodules/cva6/core/cva6.sv:  scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_id_commit;
submodules/cva6/core/cva6.sv:  riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0] pmpcfg;
submodules/cva6/core/cva6.sv:  dcache_req_i_t [2:0] dcache_req_ports_ex_cache;
submodules/cva6/core/cva6.sv:  dcache_req_o_t [2:0] dcache_req_ports_cache_ex;
submodules/cva6/core/cva6.sv:  dcache_req_i_t [1:0] dcache_req_ports_acc_cache;
submodules/cva6/core/cva6.sv:  dcache_req_o_t [1:0] dcache_req_ports_cache_acc;
submodules/cva6/core/cva6.sv:  exception_t [CVA6Cfg.NrWbPorts-1:0] ex_ex_ex_id;
submodules/cva6/core/cva6.sv:  dcache_req_i_t [NumPorts-1:0] dcache_req_to_cache;
submodules/cva6/core/cva6.sv:  dcache_req_o_t [NumPorts-1:0] dcache_req_from_cache;
submodules/cva6/core/cva6_rvfi_probes.sv:    input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
submodules/cva6/core/csr_regfile.sv:    output riscv::pmpcfg_t [(CVA6Cfg.NrPMPEntries > 0 ? CVA6Cfg.NrPMPEntries-1 : 0):0] pmpcfg_o,
submodules/cva6/core/csr_regfile.sv:  riscv::pmpcfg_t [63:0] pmpcfg_q, pmpcfg_d, pmpcfg_next;
submodules/cva6/core/decoder.sv:                  illegal_instr = 1'b1;
submodules/cva6/core/decoder.sv:                  illegal_instr = 1'b1;
submodules/cva6/core/decoder.sv:                  illegal_instr = 1'b1;
submodules/cva6/core/ex_stage.sv:    input fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_i,
submodules/cva6/core/ex_stage.sv:    input dcache_req_o_t [2:0] dcache_req_ports_i,
submodules/cva6/core/ex_stage.sv:    output dcache_req_i_t [2:0] dcache_req_ports_o,
submodules/cva6/core/ex_stage.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0] pmpcfg_i,
submodules/cva6/core/id_stage.sv:    input fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_i,
submodules/cva6/core/id_stage.sv:    output scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_entry_o,
submodules/cva6/core/id_stage.sv:    output scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_entry_o_prev,
submodules/cva6/core/id_stage.sv:  issue_struct_t [CVA6Cfg.NrIssuePorts-1:0] issue_n, issue_q;
submodules/cva6/core/id_stage.sv:  scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0]       decoded_instruction;
submodules/cva6/core/issue_read_operands.sv:    input scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_instr_i,
submodules/cva6/core/issue_read_operands.sv:    input scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] issue_instr_i_prev,
submodules/cva6/core/issue_read_operands.sv:    output fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_o,
submodules/cva6/core/issue_read_operands.sv:  fus_busy_t [CVA6Cfg.NrIssuePorts-1:0] fus_busy;
submodules/cva6/core/issue_read_operands.sv:  rs3_len_t [CVA6Cfg.NrIssuePorts-1:0] operand_c_regfile, operand_c_gpr;
submodules/cva6/core/issue_read_operands.sv:  fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_n, fu_data_q;
submodules/cva6/core/issue_read_operands.sv:  fu_t [2**ariane_pkg::REG_ADDR_SIZE-1:0] rd_clobber_gpr, rd_clobber_fpr;
submodules/cva6/core/issue_read_operands.sv:  ariane_pkg::fu_t [         CVA6Cfg.NR_SB_ENTRIES:0]                          clobber_fu;
submodules/cva6/core/issue_stage.sv:    input scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_i,
submodules/cva6/core/issue_stage.sv:    input scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0] decoded_instr_i_prev,
submodules/cva6/core/issue_stage.sv:    output fu_data_t [CVA6Cfg.NrIssuePorts-1:0] fu_data_o,
submodules/cva6/core/issue_stage.sv:    input exception_t [CVA6Cfg.NrWbPorts-1:0] ex_ex_i,
submodules/cva6/core/issue_stage.sv:    output scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_o,
submodules/cva6/core/issue_stage.sv:    writeback_t [CVA6Cfg.NrWbPorts-1:0] wb;
submodules/cva6/core/issue_stage.sv:    scoreboard_entry_t [CVA6Cfg.NR_SB_ENTRIES-1:0] sbe;
submodules/cva6/core/issue_stage.sv:  scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0]                   issue_instr_sb_iro;
submodules/cva6/core/load_unit.sv:  ldbuf_t [CVA6Cfg.NrLoadBufEntries-1:0] ldbuf_q;
submodules/cva6/core/load_store_unit.sv:    input  dcache_req_o_t [2:0] dcache_req_ports_i,
submodules/cva6/core/load_store_unit.sv:    output dcache_req_i_t [2:0] dcache_req_ports_o,
submodules/cva6/core/load_store_unit.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0]                   pmpcfg_i,
submodules/cva6/core/lsu_bypass.sv:  lsu_ctrl_t [1:0] mem_n, mem_q;
submodules/cva6/core/perf_counters.sv:    input  scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
submodules/cva6/core/perf_counters.sv:    input dcache_req_i_t [2:0] l1_dcache_access_i,
submodules/cva6/core/scoreboard.sv:    output scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_o,
submodules/cva6/core/scoreboard.sv:    input  scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0]       decoded_instr_i,
submodules/cva6/core/scoreboard.sv:    output scoreboard_entry_t [CVA6Cfg.NrIssuePorts-1:0]       issue_instr_o,
submodules/cva6/core/scoreboard.sv:    input exception_t [CVA6Cfg.NrWbPorts-1:0] ex_i,
submodules/cva6/core/scoreboard.sv:  sb_mem_t [CVA6Cfg.NR_SB_ENTRIES-1:0] mem_q, mem_n;
submodules/cva6/core/scoreboard.sv:  writeback_t [CVA6Cfg.NrWbPorts-1:0] wb;
submodules/cva6/core/load_store_unit.sv:    input  dcache_req_o_t [2:0] dcache_req_ports_i,
submodules/cva6/core/load_store_unit.sv:    output dcache_req_i_t [2:0] dcache_req_ports_o,
submodules/cva6/core/load_store_unit.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0]                   pmpcfg_i,
submodules/cva6/core/commit_stage.sv:    input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
submodules/cva6/core/acc_dispatcher.sv:    input pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0] pmpcfg_i,
submodules/cva6/core/acc_dispatcher.sv:    input scoreboard_entry_t [CVA6Cfg.NrCommitPorts-1:0] commit_instr_i,
submodules/cva6/core/acc_dispatcher.sv:    input dcache_req_i_t [2:0] dcache_req_ports_i,
submodules/cva6/core/acc_dispatcher.sv:    output dcache_req_i_t [1:0] acc_dcache_req_ports_o,
submodules/cva6/core/acc_dispatcher.sv:    input dcache_req_o_t [1:0] acc_dcache_req_ports_i,
submodules/cva6/core/cva6_fifo_v3.sv:  dtype [FifoDepth - 1:0] mem_n, mem_q;
submodules/cva6/core/frontend/btb.sv:    output btb_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0] btb_prediction_o
submodules/cva6/core/frontend/bht.sv:    output ariane_pkg::bht_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0] bht_prediction_o
submodules/cva6/core/frontend/bht.sv:    ariane_pkg::bht_t [CVA6Cfg.INSTR_PER_FETCH-1:0] bht;
submodules/cva6/core/frontend/bht.sv:    ariane_pkg::bht_t [CVA6Cfg.INSTR_PER_FETCH-1:0] bht_updated;
// submodules/cva6/core/frontend/ras.sv:  ras_t [DEPTH-1:0] stack_d, stack_q; DONE
submodules/cva6/core/frontend/instr_queue.sv:    input ariane_pkg::cf_t [CVA6Cfg.INSTR_PER_FETCH-1:0] cf_type_i,
submodules/cva6/core/frontend/instr_queue.sv:    output fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_o,
submodules/cva6/core/frontend/instr_queue.sv:  instr_data_t [CVA6Cfg.INSTR_PER_FETCH-1:0] instr_data_in, instr_data_out;
submodules/cva6/core/frontend/instr_queue.sv:  ariane_pkg::cf_t [CVA6Cfg.INSTR_PER_FETCH*2-1:0] cf;
submodules/cva6/core/frontend/frontend.sv:    output fetch_entry_t [CVA6Cfg.NrIssuePorts-1:0] fetch_entry_o,
submodules/cva6/core/frontend/frontend.sv:  bht_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0]                   bht_prediction;
submodules/cva6/core/frontend/frontend.sv:  btb_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0]                   btb_prediction;
submodules/cva6/core/frontend/frontend.sv:  bht_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0]                   bht_prediction_shifted;
submodules/cva6/core/frontend/frontend.sv:  btb_prediction_t [CVA6Cfg.INSTR_PER_FETCH-1:0]                   btb_prediction_shifted;
submodules/cva6/core/cache_subsystem/wt_dcache_mem.sv:    input wbuffer_t [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_data_i
submodules/cva6/core/cache_subsystem/wt_dcache_wbuffer.sv:    output wbuffer_t [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_data_o,
submodules/cva6/core/cache_subsystem/wt_dcache_wbuffer.sv:  tx_stat_t [CVA6Cfg.DCACHE_MAX_TX-1:0] tx_stat_d, tx_stat_q;
submodules/cva6/core/cache_subsystem/wt_dcache_wbuffer.sv:  wbuffer_t [CVA6Cfg.WtDcacheWbufDepth-1:0] wbuffer_d, wbuffer_q;
submodules/cva6/core/cache_subsystem/wt_dcache.sv:    input  dcache_req_i_t [NumPorts-1:0] req_ports_i,
submodules/cva6/core/cache_subsystem/wt_dcache.sv:    output dcache_req_o_t [NumPorts-1:0] req_ports_o,
submodules/cva6/core/cache_subsystem/wt_dcache.sv:  wbuffer_t [     CVA6Cfg.WtDcacheWbufDepth-1:0]                                  wbuffer_data;
submodules/cva6/core/cache_subsystem/wt_cache_subsystem.sv:    input dcache_req_i_t [NumPorts-1:0] dcache_req_ports_i,
submodules/cva6/core/cache_subsystem/wt_cache_subsystem.sv:    output dcache_req_o_t [NumPorts-1:0] dcache_req_ports_o,
submodules/cva6/core/cache_subsystem/tag_cmp.sv:    input l_data_t [NR_PORTS-1:0] wdata_i,
submodules/cva6/core/cache_subsystem/tag_cmp.sv:    input l_be_t [NR_PORTS-1:0] be_i,
submodules/cva6/core/cache_subsystem/tag_cmp.sv:    output l_data_t [CVA6Cfg.DCACHE_SET_ASSOC-1:0] rdata_o,
submodules/cva6/core/cache_subsystem/tag_cmp.sv:    input  l_data_t [CVA6Cfg.DCACHE_SET_ASSOC-1:0] rdata_i
submodules/cva6/core/cache_subsystem/miss_handler.sv:    input cache_line_t [CVA6Cfg.DCACHE_SET_ASSOC-1:0] data_i,
submodules/cva6/core/cache_subsystem/miss_handler.sv:    input  req_t [NR_PORTS-1:0] req_i,
submodules/cva6/core/cache_subsystem/miss_handler.sv:    output rsp_t [NR_PORTS-1:0] rsp_o,
submodules/cva6/core/cache_subsystem/cache_ctrl.sv:    input cache_line_t [CVA6Cfg.DCACHE_SET_ASSOC-1:0] data_i,
submodules/cva6/core/cache_subsystem/std_cache_subsystem.sv:    input dcache_req_i_t [NumPorts-1:0] dcache_req_ports_i,
submodules/cva6/core/cache_subsystem/std_cache_subsystem.sv:    output dcache_req_o_t [NumPorts-1:0] dcache_req_ports_o,
submodules/cva6/core/cache_subsystem/std_nbdcache.sv:    input dcache_req_i_t [NumPorts-1:0] req_ports_i,
submodules/cva6/core/cache_subsystem/std_nbdcache.sv:    output dcache_req_o_t [NumPorts-1:0] req_ports_o,
submodules/cva6/core/cache_subsystem/std_nbdcache.sv:  cache_line_t [  CVA6Cfg.DCACHE_SET_ASSOC-1:0]                                 rdata;
submodules/cva6/core/cache_subsystem/std_nbdcache.sv:  cache_line_t [                    NumPorts:0]                                 wdata;
submodules/cva6/core/cache_subsystem/std_nbdcache.sv:  cache_line_t [  CVA6Cfg.DCACHE_SET_ASSOC-1:0]                                 rdata_ram;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_read_arbiter.sv:    input  hpdcache_mem_req_t [N-1:0] mem_req_read_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/utils/hpdcache_mem_req_write_arbiter.sv:    input  hpdcache_mem_req_w_t [N-1:0] mem_req_write_data_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_demux.sv:    output data_t [NOUTPUT-1:0] data_o
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fifo_reg.sv:        fifo_data_t [FIFO_DEPTH-1:0] fifo_mem_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fifo_reg_initialized.sv:    input  fifo_data_t [FIFO_DEPTH-1:0] initial_value_i
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_fifo_reg_initialized.sv:    fifo_data_t [FIFO_DEPTH-1:0] fifo_mem_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_mux.sv:    input  data_t [NINPUT-1:0] data_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_downsize.sv:    rdata_t [DEPTH-1:0][RD_WORDS-1:0] buf_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_downsize.sv:    wordptr_t [DEPTH-1:0] words_q, words_d;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_upsize.sv:    wdata_t [DEPTH-1:0][WR_WORDS-1:0] buf_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/common/hpdcache_data_upsize.sv:    wordptr_t [DEPTH-1:0]  words_q, words_d;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv:    input  hpdcache_req_t [NUM_HW_PREFETCH-1:0] hwpf_stride_req_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv:    output hpdcache_rsp_t [NUM_HW_PREFETCH-1:0] hwpf_stride_rsp_o,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_arb.sv:    hpdcache_req_t [NUM_HW_PREFETCH-1:0] hwpf_stride_req;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv:    input  hwpf_stride_throttle_t [NUM_HW_PREFETCH-1:0] hwpf_stride_throttle_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv:    output hwpf_stride_throttle_t [NUM_HW_PREFETCH-1:0] hwpf_stride_throttle_o,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv:    input  hpdcache_req_offset_t [NUM_SNOOP_PORTS-1:0]  snoop_addr_offset_i,
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv:    hpdcache_req_offset_t [NUM_SNOOP_PORTS-1:0] snoop_addr_offset_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv:    hpdcache_nline_t [NUM_HW_PREFETCH-1:0] hwpf_snoop_nline;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv:    typedef hpdcache_data_word_t [HPDcacheCfg.u.accessWords-1:0] hpdcache_access_data_t;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv:    typedef hpdcache_data_be_t [HPDcacheCfg.u.accessWords-1:0] hpdcache_access_be_t;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv:    hpdcache_mem_req_t [1:0] arb_mem_req_read;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache.sv:    hpdcache_mem_req_w_t [2:0] arb_mem_req_write_data;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv:    hpdcache_req_t [HPDcacheCfg.u.nRequesters-1:0] core_req;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv:    hpdcache_tag_t [HPDcacheCfg.u.nRequesters-1:0] core_req_tag;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_core_arbiter.sv:    hpdcache_pma_t [HPDcacheCfg.u.nRequesters-1:0] core_req_pma;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv:    typedef hpdcache_data_row_enable_t [HPDCACHE_DATA_RAM_Y_CUTS-1:0] hpdcache_data_enable_t;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv:    hpdcache_dir_entry_t [HPDcacheCfg.u.ways-1:0] dir_wentry;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv:    hpdcache_dir_entry_t [HPDcacheCfg.u.ways-1:0] dir_rentry;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv:    hpdcache_tag_t [HPDcacheCfg.u.ways-1:0] dir_tags;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_memctrl.sv:    hpdcache_req_data_t [HPDCACHE_DATA_REQ_RATIO-1:0][HPDcacheCfg.u.ways-1:0] data_read_words;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv:    hpdcache_set_t [HPDcacheCfg.u.mshrSets*HPDcacheCfg.u.mshrWays-1:0] mshr_cache_set_q;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv:    mshr_sram_data_t [HPDcacheCfg.u.mshrWays-1:0] mshr_wdata;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv:    mshr_sram_data_t [HPDcacheCfg.u.mshrWays-1:0] mshr_rdata;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv:        mshr_sram_wbyteenable_t [HPDcacheCfg.u.mshrWays-1:0] mshr_wbyteenable;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_mshr.sv:        mshr_sram_wmask_t [HPDcacheCfg.u.mshrWays-1:0] mshr_wmask;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_rtab.sv:    hpdcache_req_addr_t [N-1:0]  addr;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_victim_plru.sv:    way_vector_t [HPDcacheCfg.u.sets-1:0] plru_q, plru_d;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv:    typedef wbuf_data_t [WBUF_DATA_NWORDS-1:0] wbuf_data_buf_t;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv:    typedef wbuf_be_t [WBUF_DATA_NWORDS-1:0] wbuf_be_buf_t;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv:    wbuf_data_entry_t [WBUF_DATA_NENTRIES-1:0]  wbuf_data_q, wbuf_data_d;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv:    wbuf_send_meta_t [WBUF_DIR_NENTRIES-1:0]    wbuf_meta_pend;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_wbuf.sv:    wbuf_data_ptr_t [WBUF_DIR_NENTRIES-1:0]     wbuf_meta_pend_data_ptr;
submodules/cva6/core/cache_subsystem/hpdcache/rtl/src/hpdcache_flush.sv:    typedef flush_entry_t [FlushEntries-1:0] flush_dir_t;
submodules/cva6/core/cache_subsystem/cva6_hpdcache_subsystem_axi_arbiter.sv:  typedef hpdcache_mem_id_t [MEM_RESP_RT_DEPTH-1:0] mem_resp_rt_t;
submodules/cva6/core/cache_subsystem/cva6_hpdcache_subsystem_axi_arbiter.sv:  hpdcache_mem_req_t [1:0] mem_req_read;
submodules/cva6/core/cache_subsystem/cva6_hpdcache_wrapper.sv:  hwpf_stride_pkg::hwpf_stride_throttle_t [NrHwPrefetchers-1:0] hwpf_throttle_in;
submodules/cva6/core/cache_subsystem/cva6_hpdcache_wrapper.sv:  hwpf_stride_pkg::hwpf_stride_throttle_t [NrHwPrefetchers-1:0] hwpf_throttle_out;
submodules/cva6/core/pmp/src/pmp.sv:    input riscv::pmpcfg_t [NR_ENTRIES-1:0] conf_i,
submodules/cva6/core/pmp/src/pmp_data_if.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0] pmpcfg_i,
submodules/cva6/common/local/util/instr_tracer.sv:  input scoreboard_entry_t [1:0] commit_instr,
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  addr_t [NumPorts-1:0] r_addr_q;
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  data_t [NumPorts-1:0][Latency-1:0] rdata_q,  rdata_d;
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  addr_t [NumPorts-1:0] r_addr_q;
submodules/cva6/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv:  data_t [NumPorts-1:0][Latency-1:0] rdata_q,  rdata_d;
submodules/cva6/core/cva6_mmu/cva6_mmu.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0]                   pmpcfg_i,
submodules/cva6/core/cva6_mmu/cva6_ptw.sv:    input riscv::pmpcfg_t [CVA6Cfg.NrPMPEntries-1:0] pmpcfg_i,
submodules/cva6/core/cva6_mmu/cva6_shared_tlb.sv:  shared_tag_t [SHARED_TLB_WAYS-1:0] shared_tag_rd;
submodules/cva6/core/cva6_mmu/cva6_shared_tlb.sv:  pte_cva6_t [SHARED_TLB_WAYS-1:0][HYP_EXT:0] pte;


submodules/cva6/vendor/pulp-platform/common_cells/src/addr_decode.sv:  input  rule_t [NoRules-1:0] addr_map_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/cb_filter.sv:  parameter cb_filter_pkg::cb_seed_t [KHashes-1:0] Seeds = cb_filter_pkg::EgSeeds
submodules/cva6/vendor/pulp-platform/common_cells/src/cb_filter.sv:  parameter cb_filter_pkg::cb_seed_t [NoHashes-1:0] Seeds = cb_filter_pkg::EgSeeds
submodules/cva6/vendor/pulp-platform/common_cells/src/cb_filter_pkg.sv:  localparam cb_seed_t [2:0] EgSeeds = '{
submodules/cva6/vendor/pulp-platform/common_cells/src/cdc_fifo_gray.sv:  T [2**LOG_DEPTH-1:0] async_data;
submodules/cva6/vendor/pulp-platform/common_cells/src/cdc_fifo_gray.sv:  output T [2**LOG_DEPTH-1:0] async_data_o,
submodules/cva6/vendor/pulp-platform/common_cells/src/cdc_fifo_gray.sv:  T [2**LOG_DEPTH-1:0] data_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/cdc_fifo_gray.sv:  input  T [2**LOG_DEPTH-1:0] async_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/fifo_v3.sv:    dtype [FifoDepth - 1:0] mem_n, mem_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/id_queue.sv:    head_tail_t [HtCapacity-1:0]    head_tail_d,    head_tail_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/id_queue.sv:    linked_data_t [CAPACITY-1:0]    linked_data_d,  linked_data_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/isochronous_spill_register.sv:    T [1:0] mem_d, mem_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv:  input  DataType [NumIn-1:0] data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv:    DataType [2**NumLevels-2:0] data_nodes;
submodules/cva6/vendor/pulp-platform/common_cells/src/shift_reg.sv:        dtype [Depth-1:0] reg_d, reg_q;
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv:    input  DATA_T [N_INP-1:0] inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_mux.sv:  input  DATA_T [N_INP-1:0]     inp_data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:  input  idx_inp_t [NumOut-1:0] rr_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:  input  payload_t [NumInp-1:0] data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:  input  sel_oup_t [NumInp-1:0] sel_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:  output payload_t [NumOut-1:0] data_o,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:  output idx_inp_t [NumOut-1:0] idx_o,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:    omega_data_t [NumLevels-1:0][NumRouters-1:0][Radix-1:0] inp_router_data;
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:    omega_data_t [NumLevels-1:0][NumRouters-1:0][Radix-1:0] out_router_data;
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_omega_net.sv:        sel_t [Radix-1:0] sel_router;
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  input  idx_inp_t [NumOut-1:0] rr_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  input  payload_t [NumInp-1:0] data_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  input  sel_oup_t [NumInp-1:0] sel_i,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  output payload_t [NumOut-1:0] data_o,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  output idx_inp_t [NumOut-1:0] idx_o,
submodules/cva6/vendor/pulp-platform/common_cells/src/stream_xbar.sv:  payload_t [NumOut-1:0][NumInp-1:0] out_data;

submodules/cva6/common/local/util/instr_tracer.sv:  input scoreboard_entry_t [1:0] commit_instr,
submodules/cva6/common/local/util/tc_sram_fpga_wrapper.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/common/local/util/tc_sram_fpga_wrapper.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/common/local/util/tc_sram_fpga_wrapper.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/common/local/util/tc_sram_wrapper.sv:  output data_t [NumPorts-1:0] rdata_o
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  input  addr_t [NumPorts-1:0] addr_i,
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  input  data_t [NumPorts-1:0] wdata_i,
submodules/cva6/common/local/util/tc_sram_wrapper_cache_techno.sv:  output data_t [NumPorts-1:0] rdata_o
