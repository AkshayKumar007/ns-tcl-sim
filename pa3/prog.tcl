source ../common.tcl

foreach i {0 1 2 3 4 5} {
    set node_$i [$ns node]    
}

$node_0 color "magenta"
$node_0 label "src1"
$node_2 color "magenta"
$node_2 label "src2"
$node_5 color "blue"
$node_5 label "dest1"
$node_3 color "blue"
$node_3 label "dest2"

$ns make-lan "$node_0 $node_1 $node_2 $node_3 $node_4" 100Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $node_4 $node_5 100Mb 1ms DropTail

foreach s {0 2} d {5 3} {
    set tcp_$s [new Agent/TCP]
    set ftp_$s [new Application/FTP]
    
    [set node_$s] attach [set tcp_$s]    
    [set ftp_$s] attach-agent [set tcp_$s]

    set sink_$d [new Agent/TCPSink]
    [set node_$d] attach [set sink_$d]    

    $ns connect [set tcp_$s] [set sink_$d]

    set file [open tcp_$s.tr w]
    [set tcp_$s] attach $file
    [set tcp_$s] trace cwnd_
}

$ftp_0 set packetSize_ 10
$ftp_0 set interval_ 0.0001
$ftp_2 set packetSize_ 10
$ftp_2 set interval_ 0.0001

foreach {t1 t2} {0.1 5 7 14 0.2 8 10 15} n {0 0 2 2} {
    $ns at $t1 "[set ftp_$n] start"
    $ns at $t2 "[set ftp_$n] stop"
}

proc _finish {} {
    foreach i {0 2} {
        set file [open xgraph_$i.tr w]
        puts $file [exec awk -f prog.awk tcp_$i.tr]
        close $file
    }

    exec xgraph xgraph_0.tr xgraph_2.tr &

    finish
}

$ns at 16 "_finish"
$ns run
