
sudo tcpdump -A -s 10240 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
sudo tcpdump -nnvXSs 0 -c1 tcp
sudo tcpdump -ttttnnvvS
sudo tcpdump src 10.211.55.5 and dst 10.211.55.7
sudo tcpdump net 10.211.55.0/24 and udp
sudo tcpdump dst port 80
sudo tcpdump icmp
sudo tcpdump ip6
sudo tcpdump portrange 80-1000
sudo tcpdump less 32
sudo tcpdump greater 64
# sudo tcpdump  <= 128

sudo tcpdump -nnvvS src 10.5.2.3 and dst port 3389
sudo tcpdump -nvX src net 192.168.0.0/16 and dst net 10.0.0.0/8 or 172.16.0.0/16
sudo tcpdump dst 192.168.0.2 and src net and not icmp


ttttnnvvXSs 0
URG
ACK
PSH
RST
SYN
FIN
U A P R S F
32 16 8 4 2 1
