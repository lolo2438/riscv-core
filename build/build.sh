#!/bin/bash

coredir=../cpu/core
testdir=../test/testbenches/cpu

ghdl --clean
ghdl -a $coredir/RV32I.vhd
ghdl -a $coredir/regfile.vhd
ghdl -a $coredir/decoder.vhd

#ghdl -a $coredir/alu/adder.vhd
#ghdl -a $coredir/alu/shifter.vhd
#ghdl -a $coredir/alu/comparator.vhd
ghdl -a $coredir/alu/alu.vhd

ghdl -a $coredir/core.vhd

#ghdl -a $testdir/alu_tb.vhd
ghdl -a --ieee=synopsys $testdir/core_tb.vhd

ghdl -e regfile
ghdl -e alu
ghdl -e decoder
ghdl -e core

#ghdl -e alu_tb
ghdl -e --ieee=synopsys core_tb

#ghdl -r alu_tb --vcd=wave.vcd
ghdl -r core_tb --vcd=wave.vcd

gtkwave wave.vcd
