BEGIN	{
    count1 = 0
    count2 = 0
    pack1 = 0
    pack2 = 0
    time1 = 0
    time2 = 0
}
{
    if ($1 == "r" && $3 == "_1_" && $4 == "AGT")
    {
        count1 += 1;
        pack1 += $8;
        time1 = $2;
    }
    if ($1 == "r" && $3 == "_2_" && $4 == "AGT")
    {
        count2 += 1;
        time2 = $2;
        pack2 += $8;
    }
}
END	{
    print "Throughput from n0 to n1: " (count1 * pack1 * 8) / (time1 * 1000000) " Mbps"
    print "Throughput from n1 to n2: " (count2 * pack2 * 8) / (time2 * 1000000) " Mbps"
}
