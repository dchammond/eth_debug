SIM = questa
TOPLEVEL_LANG = verilog

VERILOG_SOURCES += $(PWD)/sim_top.sv
#VERILOG_SOURCES += ../rtl/top.sv
#VERILOG_SOURCES += ../rtl/uart/uart_tx.sv
#VERILOG_SOURCES += ../rtl/uart/uart_rx.sv

TOPLEVEL = sim_top

MODULE = test

VOPT_OPT_LEVEL = 4
VLOG_OPT_LEVEL = 4

ifneq ($(GUI), 1)
	SIM_ARGS += -no_autoacc
endif
RUN_ARGS += -noautoldlibpath

COCOTB_RESOLVE_X = RANDOM
COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

include $(shell cocotb-config --makefiles)/Makefile.sim
