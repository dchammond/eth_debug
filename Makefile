.PHONY: vivado
vivado:
	vivado -mode tcl -source eth_debug.tcl

.PHONY: build
build: vivado clean

.PHONY: clean
clean:
	rm -f *.jou *.log *webtalk*
