
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


ttttnnvvXSs 0
URG
ACK
PSH
RST
SYN
FIN
U A P R S F
32 16 8 4 2 1
