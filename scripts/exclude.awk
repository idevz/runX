#!/usr/bin/awk -f
{
    b=$0;
    c=$1;
    $1="";
    if (!($0 in a))
    {
        if ($2 !~ "cd|cat|rm|ll|which|tail|journalctl|history|ps|ifconfig|alias|netstat|pwd|mkdir") {
            if ($3 !~ "cd|cat|rm|ll|which|tail|journalctl|history|ps|ifconfig|alias|netstat|pwd|mkdir") {
                a[$0] = $0;
                d[c]=b
            }
        }
    }
}END {
    for (i in d) print d[i]
}