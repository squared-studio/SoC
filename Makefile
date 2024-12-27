TOP := cva6

CVA6_REPO_DIR := $(shell realpath submodules/cva6)
HPDCACHE_DIR := $(shell realpath submodules/cva6/core/cache_subsystem/hpdcache)

.DEFAULT_GOAL := clean

TARGET_CFG := cv64a6_mmu

XVLOG_DEFS += -d CFG_$(TARGET_CFG)
XVLOG_DEFS += -d XSIM
XVLOG_DEFS += -d VERILATOR

INCDR += -i ${CVA6_REPO_DIR}/core/include/
INCDR += -i ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/include/
INCDR += -i ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/
INCDR += -i ${CVA6_REPO_DIR}/vendor/pulp-platform/axi/include/
INCDR += -i ${CVA6_REPO_DIR}/common/local/util/
INCDR += -i ${HPDCACHE_DIR}/rtl/include

FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/SyncDpRam.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/AsyncDpRam.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/AsyncThreePortRam.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_cast_multi.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_classifier.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_divsqrt_multi.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_fma_multi.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_fma.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_noncomp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_opgroup_block.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_opgroup_fmt_slice.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_opgroup_multifmt_slice.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_rounding.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpnew_top.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv
FLIST += ${CVA6_REPO_DIR}/core/include/config_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/${TARGET_CFG}_config_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/riscv_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/ariane_pkg.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/axi/src/axi_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/wt_cache_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/std_cache_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/instr_tracer_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/include/build_config_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_compressed_if_driver.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_issue_register_commit_if_driver.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_example/include/cvxif_instr_pkg.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_fu.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_example/cvxif_example_coprocessor.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_example/instr_decoder.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_example/compressed_instr_decoder.sv
FLIST += ${CVA6_REPO_DIR}/core/cvxif_example/copro_alu.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/fifo_v3.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lfsr.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_arbiter.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_mux.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_demux.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lzc.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/shift_reg.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/unread.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/popcount.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/exp_backoff.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/counter.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/delta_counter.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_rvfi_probes.sv
FLIST += ${CVA6_REPO_DIR}/core/alu.sv
FLIST += ${CVA6_REPO_DIR}/core/fpu_wrap.sv
FLIST += ${CVA6_REPO_DIR}/core/branch_unit.sv
FLIST += ${CVA6_REPO_DIR}/core/compressed_decoder.sv
FLIST += ${CVA6_REPO_DIR}/core/macro_decoder.sv
FLIST += ${CVA6_REPO_DIR}/core/controller.sv
FLIST += ${CVA6_REPO_DIR}/core/csr_buffer.sv
FLIST += ${CVA6_REPO_DIR}/core/csr_regfile.sv
FLIST += ${CVA6_REPO_DIR}/core/decoder.sv
FLIST += ${CVA6_REPO_DIR}/core/ex_stage.sv
FLIST += ${CVA6_REPO_DIR}/core/instr_realign.sv
FLIST += ${CVA6_REPO_DIR}/core/id_stage.sv
FLIST += ${CVA6_REPO_DIR}/core/issue_read_operands.sv
FLIST += ${CVA6_REPO_DIR}/core/issue_stage.sv
FLIST += ${CVA6_REPO_DIR}/core/load_unit.sv
FLIST += ${CVA6_REPO_DIR}/core/load_store_unit.sv
FLIST += ${CVA6_REPO_DIR}/core/lsu_bypass.sv
FLIST += ${CVA6_REPO_DIR}/core/mult.sv
FLIST += ${CVA6_REPO_DIR}/core/multiplier.sv
FLIST += ${CVA6_REPO_DIR}/core/serdiv.sv
FLIST += ${CVA6_REPO_DIR}/core/perf_counters.sv
FLIST += ${CVA6_REPO_DIR}/core/ariane_regfile_ff.sv
FLIST += ${CVA6_REPO_DIR}/core/ariane_regfile_fpga.sv
FLIST += ${CVA6_REPO_DIR}/core/scoreboard.sv
FLIST += ${CVA6_REPO_DIR}/core/store_buffer.sv
FLIST += ${CVA6_REPO_DIR}/core/amo_buffer.sv
FLIST += ${CVA6_REPO_DIR}/core/store_unit.sv
FLIST += ${CVA6_REPO_DIR}/core/commit_stage.sv
FLIST += ${CVA6_REPO_DIR}/core/axi_shim.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_accel_first_pass_decoder_stub.sv
FLIST += ${CVA6_REPO_DIR}/core/acc_dispatcher.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_fifo_v3.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/btb.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/bht.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/ras.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/instr_scan.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/instr_queue.sv
FLIST += ${CVA6_REPO_DIR}/core/frontend/frontend.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_dcache_ctrl.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_dcache_mem.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_dcache_missunit.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_dcache_wbuffer.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_dcache.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_icache.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_cache_subsystem.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/wt_axi_adapter.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/tag_cmp.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/axi_adapter.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/miss_handler.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cache_ctrl.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_icache_axi_wrapper.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/std_cache_subsystem.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/std_nbdcache.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_pkg.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_req_read_arbiter.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_req_write_arbiter.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_demux.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_lfsr.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_sync_buffer.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_fifo_reg.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_fifo_reg_initialized.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_fxarb.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_rrarb.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_mux.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_decoder.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_1hot_to_binary.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_prio_1hot_encoder.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_sram.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_sram_wbyteenable.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_sram_wmask.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_regbank_wbyteenable_1rw.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_regbank_wmask_1rw.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_data_downsize.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_data_upsize.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/hpdcache_data_resize.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hwpf_stride/hwpf_stride_pkg.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hwpf_stride/hwpf_stride.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hwpf_stride/hwpf_stride_arb.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hwpf_stride/hwpf_stride_wrapper.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_amo.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_cmo.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_core_arbiter.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_ctrl.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_ctrl_pe.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_memctrl.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_miss_handler.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_mshr.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_rtab.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_uncached.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_victim_plru.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_victim_random.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_victim_sel.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_wbuf.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/hpdcache_flush.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_resp_demux.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_to_axi_read.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_to_axi_write.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_hpdcache_subsystem.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_hpdcache_subsystem_axi_arbiter.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_hpdcache_if_adapter.sv
FLIST += ${CVA6_REPO_DIR}/core/cache_subsystem/cva6_hpdcache_wrapper.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_1rw.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_1rw.sv
FLIST += ${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wmask_1rw.sv
FLIST += ${CVA6_REPO_DIR}/core/pmp/src/pmp.sv
FLIST += ${CVA6_REPO_DIR}/core/pmp/src/pmp_entry.sv
FLIST += ${CVA6_REPO_DIR}/core/pmp/src/pmp_data_if.sv
FLIST += ${CVA6_REPO_DIR}/common/local/util/instr_tracer.sv
FLIST += ${CVA6_REPO_DIR}/common/local/util/tc_sram_wrapper.sv
FLIST += ${CVA6_REPO_DIR}/common/local/util/tc_sram_wrapper_cache_techno.sv
FLIST += ${CVA6_REPO_DIR}/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv
FLIST += ${CVA6_REPO_DIR}/common/local/util/sram.sv
FLIST += ${CVA6_REPO_DIR}/common/local/util/sram_cache.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_mmu/cva6_mmu.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_mmu/cva6_ptw.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_mmu/cva6_tlb.sv
FLIST += ${CVA6_REPO_DIR}/core/cva6_mmu/cva6_shared_tlb.sv

build:
	@mkdir -p build
	@echo "*" > build/.gitignore
	@git add build > /dev/null 2>&1

.PHONY: clean
clean:
	@echo -e "\033[3;35mCleaning build directory...\033[0m"
	@rm -rf build
	@make -s build
	@echo -e "\033[3;35mCleaned build directory\033[0m"

submodules/cva6/core/Flist.cva6:
	@echo -e "\033[3;35mInitializing submodules...\033[0m"
	@git submodule update --init --recursive --depth 1
	@echo -e "\033[3;35mInitialized submodules\033[0m"

define compile
  $(eval SUB_LIB := $(shell echo "$(wordlist 1, 25,$(COMPILE_LIB))"))
  cd build; xvlog $(INCDR) -sv $(SUB_LIB) --nolog $(XVLOG_DEFS)
  $(eval COMPILE_LIB := $(wordlist 26, $(words $(COMPILE_LIB)), $(COMPILE_LIB)))
  $(if $(COMPILE_LIB), $(call compile))
endef

.PHONY: xvlog
xvlog: build submodules/cva6/core/Flist.cva6
	@echo -e "\033[3;35mCompiling cva6...\033[0m"
	@$(eval COMPILE_LIB := $(FLIST))
	@$(call compile)
	@echo -e "\033[3;35mCompiled cva6\033[0m"

.PHONY: xelab
xelab:
	@echo -e "\033[3;35mElaborating cva6...\033[0m"
	@cd build; xelab -debug typical $(TOP) --nolog
	@echo -e "\033[3;35mElaborated cva6\033[0m"

.PHONY: compile
compile: clean xvlog xelab
