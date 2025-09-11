
sysctl -w net.ipv4.ip_forward=1

sudo iptables -t nat -N REDSOCKS
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 93.89.213.48/32 -j RETURN  # <-- exclure le proxy distant (changer ip par celle du proxy)
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS


