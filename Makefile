.PHONY: program
program:
	vivado -mode tcl -nolog -nojournal -source tcl/eth_debug-prog.tcl -tclargs "${BITFILE}"

.PHONY: vivado-bit
vivado-bit: vivado-prep
	vivado -mode tcl -source tcl/eth_debug-bit.tcl

vivado-opt: vivado-prep
	vivado -mode tcl -source tcl/eth_debug-opt.tcl

vivado-pnr: vivado-prep
	vivado -mode tcl -source tcl/eth_debug-pnr.tcl

vivado-synth: vivado-prep 
	vivado -mode tcl -source tcl/eth_debug-synth.tcl

.PHONY: vivado-elab
vivado-elab: vivado-prep 
	vivado -mode tcl -source tcl/eth_debug-elab.tcl

.PHONY: vivado-prep
vivado-prep:
	mkdir -p outputs

.PHONY: vivado-post
vivado-post:
	mv vivado.log outputs/vivado.log

.PHONY: build-bit
build-bit: vivado-bit clean-dep

.PHONY: build-opt
build-opt: vivado-opt clean-dep

.PHONY: build-pnr
build-pnr: vivado-pnr clean-dep

.PHONY: build-synth
build-synth: vivado-synth clean-dep

.PHONY: build
build: build-bit

.PHONY: clean-dep
clean-dep: vivado-post
	rm -f *.jou *.log *webtalk*
	rm -rf .Xil

.PHONY: clean
clean: full-clean
	rm -f *.jou *.log *webtalk*
	rm -rf .Xil

.PHONY: full-clean
full-clean:
	@echo -n "Okay to clear outputs ? [y/N] " && read ans && [ $${ans:-N} = y ]
	rm -f outputs/*
