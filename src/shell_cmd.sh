#!/usr/bin/env bash

# HUP(1) 挂起，通常因终端掉线或用户退出而引发
# INT(2) 中断，通常因按下Ctrl+c组合键而引发
# QUIT(3)退出，通常因按下Ctrl+\组合键而引发
# ABRT(6)中止，通常因某些严重的执行错误而引发
# ALRM(14)报警，通常用来处理超时
# TERM(15)终止，通常在系统关机时发送
# TSTP(20)停止进程的运行，但该信号可以被处理和忽略，通常因按下Ctrl+z组合键而引发

trap 'echo "正在退出。。。"; sleep 2000;exit 0' 2