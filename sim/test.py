import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb_bus.drivers.avalon import AvalonST as AvalonSTDriver
from cocotb_bus.monitors.avalon import AvalonST as AvalonSTMonitor
from cocotb_bus.scoreboard import Scoreboard

@cocotb.test()
async def test(dut):
    for _ in range(10):
        await RisingEdge(dut.clk_100)

    driver = AvalonSTDriver(dut, 'byte_in', dut.clk_100)
    exp_mon = AvalonSTMonitor(dut, 'byte_in', dut.clk_100)
    res_mon = AvalonSTMonitor(dut, 'byte_out', dut.clk_100)

    expected_data = list()

    scoreboard = Scoreboard(dut)
    scoreboard.add_interface(res_mon, expected_data)

    exp_mon.add_callback(lambda b: expected_data.append(b))

    dut.byte_out_ready.value = 1

    await driver.send(0x5A)

    await Timer(1, 'ms')

    raise scoreboard.result
