import cocotb
from cocotb.triggers import Timer, RisingEdge

@cocotb.test()
async def test(dut):
    for _ in range(10):
        await RisingEdge(dut.clk)
    await Timer(1, 'us')
