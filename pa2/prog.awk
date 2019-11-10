BEGIN {
    d = 0
}
{
    if ($1 == "d") {
        d += 1
    }
}
END {
    print "Total packets dropped: " d
}