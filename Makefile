.PHONY: vivado
vivado: full-clean
	mkdir -p outputs
	vivado -mode tcl -source eth_debug.tcl/eth_debug-bit.tcl
	mv vivado.log outputs/vivado.log

.PHONY: build
build: vivado clean-dep

.PHONY: clean-dep
clean-dep: vivado
	rm -f *.jou *.log *webtalk*
	rm -rf .Xil

.PHONY: clean
clean:
	rm -f *.jou *.log *webtalk*
	rm -rf .Xil

.PHONY: full-clean
full-clean: clean
	@echo -n "Okay to clear outputs ? [y/N] " && read ans && [ $${ans:-N} = y ]
	rm -f outputs/*
