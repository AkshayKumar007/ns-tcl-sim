BEGIN {
    c = 0
}
{
    if ($1 == "d") {
        c += 1
        print "[" $2 "] "  $3 " -> " $4 ", type: " $5 , ", size: " $6 ", seq: " $11
    }    
}
END {
    print "Number of packets dropped: " c
}