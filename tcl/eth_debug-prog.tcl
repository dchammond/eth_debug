set bitfile [lindex $argv 0]

if { [file exists $bitfile] != 1 } {
    puts "No bitfile $bitfile"
    quit
} else {
    puts "Using bitfile $bitfile"
}

load_features labtools

open_hw_manager
connect_hw_server -url TCP:localhost:3121

set target [get_hw_targets *]
current_hw_target "$target"
open_hw_target

set first_device [lindex [get_hw_devices] 0]
current_hw_device $first_device

set_property PROGRAM.FILE "$bitfile" "$first_device"

program_hw_devices "$first_device"

refresh_hw_device "$first_device"
