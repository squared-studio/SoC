#!/bin/bash

################################################################################
# FUNCTIONS
################################################################################

ci_simulate () {
  start_time=$(date +%s)
  echo -n -e " $(date +%x\ %H:%M:%S) - \033[1;33mSIMULATING $1 $2... \033[0m"
  make -s simulate TOP=$1 $2 $3 $4 $5 $6 $7 $8 $9 > /dev/null 2>&1
  end_time=$(date +%s)
  time_diff=$((end_time - start_time))
  echo -e "\033[1;32mDone!\033[0m ($time_diff seconds)"
}

################################################################################
# CLEANUP
################################################################################

start_time=$(date +%s)
clear
make -s print_logo
echo -n -e " $(date +%x\ %H:%M:%S) - \033[1;33mCLEANING UP TEMPORATY FILES... \033[0m"
make -s clean_full > /dev/null 2>&1
end_time=$(date +%s)
time_diff=$((end_time - start_time))
echo -e "\033[1;32mDone!\033[0m ($time_diff seconds)"

################################################################################
# SIMULATE
################################################################################

ci_simulate soc_ctrl_csr_tb

ci_simulate ariane_tb TEST=generic/gpr.s
ci_simulate ariane_tb TEST=generic/stdout.s

ci_simulate ariane_tb TEST=rv32i/add.s
ci_simulate ariane_tb TEST=rv32i/addi.s
ci_simulate ariane_tb TEST=rv32i/and.s
ci_simulate ariane_tb TEST=rv32i/andi.s
ci_simulate ariane_tb TEST=rv32i/auipc.s
ci_simulate ariane_tb TEST=rv32i/beq.s
ci_simulate ariane_tb TEST=rv32i/bge.s
ci_simulate ariane_tb TEST=rv32i/bgeu.s
ci_simulate ariane_tb TEST=rv32i/blt.s
ci_simulate ariane_tb TEST=rv32i/bltu.s
ci_simulate ariane_tb TEST=rv32i/bne.s
ci_simulate ariane_tb TEST=rv32i/ebreak.s
ci_simulate ariane_tb TEST=rv32i/ecall.s
ci_simulate ariane_tb TEST=rv32i/fence.s
ci_simulate ariane_tb TEST=rv32i/jal.s
ci_simulate ariane_tb TEST=rv32i/jalr.s
ci_simulate ariane_tb TEST=rv32i/lb.s
ci_simulate ariane_tb TEST=rv32i/lbu.s
ci_simulate ariane_tb TEST=rv32i/lh.s
ci_simulate ariane_tb TEST=rv32i/lhu.s
ci_simulate ariane_tb TEST=rv32i/lui.s
ci_simulate ariane_tb TEST=rv32i/lw.s
ci_simulate ariane_tb TEST=rv32i/or.s
ci_simulate ariane_tb TEST=rv32i/ori.s
ci_simulate ariane_tb TEST=rv32i/sb.s
ci_simulate ariane_tb TEST=rv32i/sh.s
ci_simulate ariane_tb TEST=rv32i/sll.s
ci_simulate ariane_tb TEST=rv32i/slli.s
ci_simulate ariane_tb TEST=rv32i/slt.s
ci_simulate ariane_tb TEST=rv32i/slti.s
ci_simulate ariane_tb TEST=rv32i/sltiu.s
ci_simulate ariane_tb TEST=rv32i/sltu.s
ci_simulate ariane_tb TEST=rv32i/sra.s
ci_simulate ariane_tb TEST=rv32i/srai.s
ci_simulate ariane_tb TEST=rv32i/srl.s
ci_simulate ariane_tb TEST=rv32i/srli.s
ci_simulate ariane_tb TEST=rv32i/sub.s
ci_simulate ariane_tb TEST=rv32i/sw.s
ci_simulate ariane_tb TEST=rv32i/xor.s
ci_simulate ariane_tb TEST=rv32i/xori.s

ci_simulate ariane_tb TEST=rv64i/sd.s

ci_simulate soc_tb T0=generic/stdout.s T1=generic/stdout.s T2=generic/stdout.s T3=generic/stdout.s

################################################################################
# COLLECT & PRINT
################################################################################

rm -rf temp_ci_issues
touch temp_ci_issues

grep -s -r "TEST FAILED" ./log | sed "s/.*\.log://g" >> temp_ci_issues
grep -s -r "ERROR:" ./log | sed "s/.*\.log://g" >> temp_ci_issues

echo -e ""
echo -e "\033[1;36m___________________________ CI REPORT ___________________________\033[0m"
grep -s -r "TEST PASSED" ./log | sed "s/.*\.log://g"
grep -s -r "TEST FAILED" ./log | sed "s/.*\.log://g"
grep -s -r "WARNING:" ./log | sed "s/.*\.log://g"
grep -s -r "ERROR:" ./log | sed "s/.*\.log://g"

echo -e "\n"
echo -e "\033[1;36m____________________________ SUMMARY ____________________________\033[0m"
echo -n "PASS    : "
grep -s -r "TEST PASSED" ./log | sed "s/.*\.log://g" | wc -l
echo -n "FAIL    : "
grep -s -r "TEST FAILED" ./log | sed "s/.*\.log://g" | wc -l
echo -n "WARNING : "
grep -s -r "WARNING:" ./log | sed "s/.*\.log://g" | wc -l
echo -n "ERROR   : "
grep -s -r "ERROR:" ./log | sed "s/.*\.log://g" | wc -l
echo -e ""

mv temp_ci_issues ./log/ci_issues.txt
