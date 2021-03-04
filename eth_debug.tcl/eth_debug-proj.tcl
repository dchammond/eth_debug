# collect sources for project

create_project -in_memory "eth_debug"

set_part "xc7a100tcsg324-1"
set_param board.repoPaths "eth_debug.board"
set_property BOARD_PART "digilentinc.com:nexys4:1.1" [get_projects]
read_xdc "nexys4_17_100T.xdc"

set sv_user [glob -directory "eth_debug.srcs/sources_1/new" -- "*.sv"]
foreach sv $sv_user {
    read_verilog -sv "$sv"
}

set_property IP_REPO_PATHS "mii_to_rmii_v2_0" [get_projects]

update_ip_catalog

read_ip "eth_debug.srcs/sources_1/ip/mii_to_rmii_0/mii_to_rmii_0.xci"
read_ip "eth_debug.srcs/sources_1/ip/axi_ethernetlite_0/axi_ethernetlite_0.xci"

report_ip_status

generate_target all [get_ips]
