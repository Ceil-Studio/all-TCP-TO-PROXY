
sysctl -w net.ipv4.ip_forward=1


sudo iptables -t nat -N REDSOCKS 2>/dev/null

sudo iptables -t nat -F REDSOCKS
sudo iptables -t nat -F OUTPUT

sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp --dport 80 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp --dport 27015 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS

