source ../common.tcl

foreach i {0 1 2 3 4 5} {
    set node_$i [$ns node]
}

foreach i {0 1 2 3 5} {
    $ns duplex-link [set node_$i] $node_4 "10Mb" "10ms" DropTail
}

foreach i {0 1 2 3 5} {
    set ping_$i [new Agent/Ping]
    [set node_$i] attach [set ping_$i]
}

$ping_0 set packetSize_ 500000
$ping_2 set packetSize_ 300000
$ns queue-limit $node_0 $node_4 5
$ns queue-limit $node_2 $node_4 3
$ns queue-limit $node_4 $node_5 2

$ns connect $ping_0 $ping_5
$ns connect $ping_2 $ping_3

Agent/Ping instproc recv {from rtt} {
    $self instvar node_
    puts "Node [$node_ id] recv from node $from with rtt: $rtt"
}


foreach n {0 2} {
    for {set i 0} {$i < 30} {incr i} {
        set t [expr $i / 10.0]
        $ns at $t "[set ping_$n] send"
    }
}

$ns at 3.0 "finish"
$ns run
