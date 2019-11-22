set ns [new Simulator]

set topo [new Topography]
$topo load_flatgrid 1000 1000

set tr_file [open out.tr w]
$ns trace-all $tr_file
set nam_file [open out.nam w]
$ns namtrace-all-wireless $nam_file 1000 1000

$ns node-config -adhocRouting DSDV \
        -llType LL \
        -macType Mac/802_11 \
        -ifqType Queue/DropTail \
        -ifqLen 50 \
        -topoInstance $topo \
        -phyType Phy/WirelessPhy \
        -channelType Channel/WirelessChannel \
        -propType Propagation/TwoRayGround \
        -antType Antenna/OmniAntenna \
        -agentTrace ON \
        -routerTrace ON

$ns node-config -adhocRouting DSDV \
        -llType LL \
        -macType Mac/802_11 \
        -ifqType Queue/DropTail \
        -ifqLen 50 \
        -topoInstance $topo \
        -phyType Phy/WirelessPhy \
        -channelType Channel/WirelessChannel \
        -propType Propagation/TwoRayGround \
        -antType Antenna/OmniAntenna \
        -agentTrace ON \
        -routerTrace ON
create-god 3

foreach i {0 1 2} {
    set n$i [$ns node]
}

$n0 label "tcp0"
$n1 label "tcp1/sink1"
$n2 label "sink2"

set tcp0 [new Agent/TCP]
set tcp1 [new Agent/TCP]
set ftp0 [new Application/FTP]
set ftp1 [new Application/FTP]
set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]

$n0 attach $tcp0
$ftp0 attach-agent $tcp0

$n1 attach $sink1
$n1 attach $tcp1
$ftp1 attach-agent $tcp1

$n2 attach $sink2

$ns connect $tcp0 $sink1
$ns connect $tcp1 $sink2

$n0 set X_ 50
$n0 set Y_ 50
$n0 set Z_ 0
$n1 set X_ 100
$n1 set Y_ 100
$n1 set Z_ 0
$n2 set X_ 600
$n2 set Y_ 600
$n2 set Z_ 0

$ns at 0.1 "$n0 setdest 50 50 15"
$ns at 0.1 "$n1 setdest 100 100 25"
$ns at 0.1 "$n2 setdest 600 600 25"
$ns at 100 "$n1 setdest 550 550 15"
$ns at 190 "$n1 setdest 70 70 25"

$ns at 5 "$ftp0 start"
$ns at 5 "$ftp1 start"

proc finish {} {
    global ns nam_file tr_file

    $ns flush-trace
    close $nam_file
    close $tr_file

    puts [exec awk -f main.awk out.tr]
    exec nam out.nam &

    exit
}

$ns at 250 "finish"
$ns run