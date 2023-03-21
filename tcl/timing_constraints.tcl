set_false_path -from [get_port UART_RXD_IN]
set_false_path -from [get_port UART_RTS_IN]

set_false_path -to [get_port UART_TXD_OUT]
set_false_path -to [get_port UART_CTS_OUT]
