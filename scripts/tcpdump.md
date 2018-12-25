
sudo tcpdump -A -s 10240 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
sudo tcpdump -nnvXSs 0 -c1 tcp
sudo tcpdump -ttttnnvvS
sudo tcpdump src xxx.xxx.55.5 and dst xxx.xxx.55.7
sudo tcpdump net xxx.xxx.55.0/24 and udp
sudo tcpdump dst port 80
sudo tcpdump icmp
sudo tcpdump ip6
sudo tcpdump portrange 80-1000
sudo tcpdump less 32
sudo tcpdump greater 64
# sudo tcpdump  <= 128

sudo tcpdump -nnvvS src xxx.xxx.2.3 and dst port 3389
sudo tcpdump -nvX src net xxx.xxx.0.0/16 and dst net xxx.xxx.0.0/8 or xxx.xxx.0.0/16
sudo tcpdump dst xxx.xxx.0.2 and src net and not icmp


As a de-facto packet capture tool, tcpdump provides powerful and flexible packet filtering capabilities. The libpcap packet capture engine which tcpdump is based upon supports standard packet filtering rules such as 5-tuple packet header based filtering (i.e., based on source/destination IP addresses/ports and IP protocol type).

The packet filtering rules of tcpdump/libpcap also supports more general packet expressions, where arbitrary byte ranges in a packet are checked with relation or binary operators. For byte range representation, you can use the following format:

proto [ expr : size ]

"proto" can be one of well-known protocols (e.g., ip, arp, tcp, udp, icmp, ipv6). "expr" represents byte offset relative to the beginning of a specified protocol header. There exist well-known byte offsets such as tcpflags, or value constants such as tcp-syn, tcp-ack or tcp-fin. "size" is optional, indicating the number of bytes to check starting from the byte offset.

Using this format, you can filter TCP SYN, ACK or FIN packets as follows.
To capture only TCP SYN packets:

# tcpdump -i <interface> "tcp[tcpflags] & (tcp-syn) != 0"
To capture only TCP ACK packets:

# tcpdump -i <interface> "tcp[tcpflags] & (tcp-ack) != 0"
To capture only TCP FIN packets:

# tcpdump -i <interface> "tcp[tcpflags] & (tcp-fin) != 0"
To capture only TCP SYN or ACK packets:

# tcpdump -r <interface> "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"

tcpdump -ttttnnvvXSs 0 dst port 9100 and "tcp[tcpflags] & (tcp-fin) != 0"
URG
ACK
PSH
RST
SYN
FIN
U A P R S F
32 16 8 4 2 1


strace -Ttt -o rs curl -I -w ‘%{time_namelookup}’ xxx.cn