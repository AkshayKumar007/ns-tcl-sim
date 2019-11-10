BEGIN {}
{
    if ($6 == "cwnd_")
    {
        print $1 " " $7
    }
}
END {}