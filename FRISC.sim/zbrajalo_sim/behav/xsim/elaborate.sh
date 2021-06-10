#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Thu Jun 10 17:14:48 CEST 2021
# SW Build 3064766 on Wed Nov 18 09:12:47 MST 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab -wto 8bc2488f94e34900a59283ad6faa47b7 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot Complete_tb_behav xil_defaultlib.Complete_tb -log elaborate.log"
xelab -wto 8bc2488f94e34900a59283ad6faa47b7 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot Complete_tb_behav xil_defaultlib.Complete_tb -log elaborate.log

