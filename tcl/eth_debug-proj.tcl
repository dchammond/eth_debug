# collect sources for project

create_project -in_memory "eth_debug"

set_part "xc7a100tcsg324-1"
set_param board.repoPaths "board"
set_property BOARD_PART "digilentinc.com:nexys4:1.1" [get_projects]
read_xdc "nexys4_17_100T.xdc"

proc find_files { basedir pattern } {
    set basedir [string trimright [file join [file normalize ${basedir}] {} ]]
    set filelist {}

    foreach filename [glob -nocomplain -type {f r} -directory ${basedir} -- ${pattern}] {
        lappend filelist ${filename}
    }

    foreach dirname [glob -nocomplain -type {d r} -directory ${basedir} *] {
        set subdirlist [find_files ${dirname} ${pattern}]
        if { [llength ${subdirlist}] > 0 } {
            foreach subdirfile ${subdirlist} {
                lappend filelist ${subdirfile}
            }
        }
    }

    return ${filelist}
}

set sv_user [find_files "rtl" "*.sv"]
foreach sv $sv_user {
    read_verilog -sv "$sv"
}

set vhdl_user [find_files "rtl" "*.vhd"]
foreach vhdl $vhdl_user {
    read_vhdl -vhdl2008 "$vhdl"
}

#set_property IP_REPO_PATHS "mii_to_rmii_v2_0" [get_projects]
#
#update_ip_catalog
#
#read_ip "eth_debug.srcs/sources_1/ip/mii_to_rmii_0/mii_to_rmii_0.xci"
#read_ip "eth_debug.srcs/sources_1/ip/axi_ethernetlite_0/axi_ethernetlite_0.xci"
#
#report_ip_status
#
#generate_target all [get_ips]

update_compile_order