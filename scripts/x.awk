#!/usr/bin/awk -f
BEGIN{
	print "start"
	num=0
}
FNR==NR{
	a[$1]=$2
	b[$1]=$0
	c[FNR]=$0

	print FNR
	print NR
	next
}
{
	print FNR
	print NR
	# c[$1]=$2
	# d[$1]=$0
}
{
	print FNR
	print NR
# 	if(a[$1] == $2 && c[$1] == $2) {
# 		print b[$1] FS "-" FS d[$1] FS "-" FS $0
# 	}else{
# 		# print $0
# 	}
}
END {
	for (k in a) {
		print k FS "--" FS a[k]
	}
	for (i=0; i<=NR; i++) {
		print c[i]
	}
	print FNR
	print NR
	print "num:",num
}
