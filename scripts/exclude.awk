#!/usr/bin/awk -f
{
    b=$0;
    match($2, "\;(.*)$")
    {
        cmd=substr($2, RSTART + 1, RLENGTH)
    }
    $1=$2=""
    key = sprintf("%s%s",cmd,$0)
        

    # if (!a[key])
    if (!(key in a))
    {
        if (cmd !~ "^cd$|^cat$|^rm$|^ll$|^ls$|^l$|^which$|^tail$|^journalctl$|^history$|^ps$|^ifconfig$|^alias$|^netstat$|^pwd$|^mkdir$") {
            if ($3 !~ "^cd$|^cat$|^rm$|^ll$|^ls$|^l$|^which$|^tail$|^journalctl$|^history$|^ps$|^ifconfig$|^alias$|^netstat$|^pwd$|^mkdir$") {
                a[key] = key;
                d[key]=b
            }
        }
    }
}END {
    for (i in d) print d[i]
}