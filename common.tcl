set ns [new Simulator]

# configure trace files
set nam_file [open out.nam w]
$ns namtrace-all $nam_file
set tr_file [open out.tr w]
$ns trace-all $tr_file

proc finish {} {
    global ns nam_file tr_file
    
    # flush and close trace files
    $ns flush-trace
    foreach ftype {nam tr} {
        close [set ${ftype}_file]
    }

    # run awk and nam
    puts [exec awk -f prog.awk out.tr] 
    exec nam out.nam &
    exit 0
}
