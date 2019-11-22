set ns [new Simulator]

set trace_file [open out.tr w]
$ns trace-all $trace_file

set nodes(bs1) [$ns node]
set nodes(lp) [$ns node]
set nodes(ms) [$ns node]
set nodes(bs2) [$ns node]
set nodes(is) [$ns node]

$ns duplex-link $nodes(bs1) $nodes(lp) 3Mbps 10ms DropTail
$ns duplex-link $nodes(bs2) $nodes(is) 3Mbps 50ms DropTail
$ns duplex-link $nodes(bs1) $nodes(ms) 384000 0.15 RED
$ns duplex-link $nodes(bs2) $nodes(ms) 384000 0.15 RED

$ns queue-limit $nodes(bs1) $nodes(ms) 20
$ns queue-limit $nodes(bs2) $nodes(ms) 20

source /ns2/ns-2.35/tcl/ex/wireless-scripts/web.tcl

$ns insert-delayer $nodes(ms) $nodes(bs1) [new Delayer]
$ns insert-delayer $nodes(ms) $nodes(bs2) [new Delayer]

set tcp1 [$ns create-connection TCP/Sack1 $nodes(is) TCPSink/Sack1 $nodes(lp) 0]
set ftp1 [$tcp1 attach-app FTP]

$ns at 0.8 "$ftp1 start"

proc stop {} {
    global nodes ns trace_file

    $ns flush-trace
    close $trace_file

    set sid [$nodes(is) id]
    set did [$nodes(bs2) id]

    set GETRC "/ns2/ns-2.35/bin/getrc"
    set RAW2XG "/ns2/ns-2.35/bin/raw2xg"

    exec $GETRC -s $sid -d $did out.tr | $RAW2XG -r -m 100 > plot.xgr
    exec $GETRC -s $did -d $sid out.tr | $RAW2XG -a -m 100 >> plot.xgr

    exec xgraph -x time -y packets plot.xgr &

    exit 0
}

$ns at 100 "stop"
$ns run
