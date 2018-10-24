#!/usr/bin/awk -f
BEGIN{
	print "start"
	num=0
}
FNR==NR{
	# array a[key]=value
	a[$4 FS $5 FS $6 FS $7 FS $8 FS $9]=$4 FS $5 FS $6 FS $7 FS $8 FS $9;
	# array b[key]=value
	b[$4 FS $5 FS $6 FS $7 FS $8 FS $9]=$1 FS $2 FS $3;
	next
	}
	{
		c=$4 FS $5 FS $6 FS $7 FS $8 FS $9
		if (a[c] == c) {
			print b[c] FS c FS $10
			num = num + 1
		}else{
			print $1 FS $2 FS $3 FS $4 FS $5 FS $6 FS $7 FS $8 FS $9 FS $10
		}
	}
END {
	print "num:",num
}
