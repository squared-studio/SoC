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

ci_simulate ariane_tb TEST=generic/gpr.S
ci_simulate ariane_tb TEST=generic/fpr.S
ci_simulate ariane_tb TEST=generic/stdout.S

ci_simulate ariane_tb TEST=rv32i/add.S
ci_simulate ariane_tb TEST=rv32i/addi.S
ci_simulate ariane_tb TEST=rv32i/and.S
ci_simulate ariane_tb TEST=rv32i/andi.S
ci_simulate ariane_tb TEST=rv32i/auipc.S
ci_simulate ariane_tb TEST=rv32i/beq.S
ci_simulate ariane_tb TEST=rv32i/bge.S
ci_simulate ariane_tb TEST=rv32i/bgeu.S
ci_simulate ariane_tb TEST=rv32i/blt.S
ci_simulate ariane_tb TEST=rv32i/bltu.S
ci_simulate ariane_tb TEST=rv32i/bne.S
ci_simulate ariane_tb TEST=rv32i/ebreak.S
ci_simulate ariane_tb TEST=rv32i/ecall.S
ci_simulate ariane_tb TEST=rv32i/fence.S
ci_simulate ariane_tb TEST=rv32i/jal.S
ci_simulate ariane_tb TEST=rv32i/jalr.S
ci_simulate ariane_tb TEST=rv32i/lb.S
ci_simulate ariane_tb TEST=rv32i/lbu.S
ci_simulate ariane_tb TEST=rv32i/lh.S
ci_simulate ariane_tb TEST=rv32i/lhu.S
ci_simulate ariane_tb TEST=rv32i/lui.S
ci_simulate ariane_tb TEST=rv32i/lw.S
ci_simulate ariane_tb TEST=rv32i/or.S
ci_simulate ariane_tb TEST=rv32i/ori.S
ci_simulate ariane_tb TEST=rv32i/sb.S
ci_simulate ariane_tb TEST=rv32i/sh.S
ci_simulate ariane_tb TEST=rv32i/sll.S
ci_simulate ariane_tb TEST=rv32i/slli.S
ci_simulate ariane_tb TEST=rv32i/slt.S
ci_simulate ariane_tb TEST=rv32i/slti.S
ci_simulate ariane_tb TEST=rv32i/sltiu.S
ci_simulate ariane_tb TEST=rv32i/sltu.S
ci_simulate ariane_tb TEST=rv32i/sra.S
ci_simulate ariane_tb TEST=rv32i/srai.S
ci_simulate ariane_tb TEST=rv32i/srl.S
ci_simulate ariane_tb TEST=rv32i/srli.S
ci_simulate ariane_tb TEST=rv32i/sub.S
ci_simulate ariane_tb TEST=rv32i/sw.S
ci_simulate ariane_tb TEST=rv32i/xor.S
ci_simulate ariane_tb TEST=rv32i/xori.S

ci_simulate ariane_tb TEST=rv64i/sd.S

ci_simulate soc_tb T0=generic/stdout.S T1=generic/stdout.S T2=generic/stdout.S T3=generic/stdout.S

################################################################################
# COLLECT & PRINT
################################################################################

rm -rf temp_ci_issues
touch temp_ci_issues

grep -s -r "TEST FAILED" ./log | sed "s/.*\.log://g" >> temp_ci_issues
grep -s -r "ERROR:" ./log | sed "s/.*\.log://g" >> temp_ci_issues
grep -s -r "Fatal:" ./log | sed "s/.*\.log://g" >> temp_ci_issues

echo -e ""
echo -e "\033[1;36m___________________________ CI REPORT ___________________________\033[0m"
grep -s -r "TEST PASSED" ./log | sed "s/.*\.log://g"
grep -s -r "TEST FAILED" ./log | sed "s/.*\.log://g"
grep -s -r "WARNING:" ./log | sed "s/.*\.log://g"
grep -s -r "ERROR:" ./log | sed "s/.*\.log://g"
grep -s -r "Fatal:" ./log | sed "s/.*\.log://g"

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
echo -n "Fatal   : "
grep -s -r "Fatal:" ./log | sed "s/.*\.log://g" | wc -l
echo -e ""

mv temp_ci_issues ./log/ci_issues.txt
