source ../common.tcl

# craete nodes
foreach i {0 1 2 3} {
    set node_$i [$ns node]
}

# create links between nodes
$ns duplex-link $node_0 $node_2 0.1Mb 100ms DropTail
$ns duplex-link $node_1 $node_2 0.1Mb 100ms DropTail
$ns duplex-link $node_2 $node_3 0.1Mb 1ms DropTail

$ns queue-limit $node_0 $node_2 5
$ns queue-limit $node_1 $node_2 5

# create UDP agents and constant bit rate traffic, and attach them to 3 nodes
foreach i {0 1} {
    set udp_$i [new Agent/UDP]
    set cbr_$i [new Application/Traffic/CBR]

    [set node_$i] attach [set udp_$i]
    [set cbr_$i] attach-agent [set udp_$i]
}

# connect node_1 & node_2 -> node_4
set null [new Agent/Null]
$node_3 attach $null
$ns connect $udp_0 $null
$ns connect $udp_1 $null

# describe the simulation
$ns at 0.1 "$cbr_0 start"
$ns at 0.2 "$cbr_1 start"
$ns at 1.0 "finish"

$ns run
