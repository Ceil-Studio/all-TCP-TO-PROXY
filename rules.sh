

sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -N REDSOCKS
# Ne pas intercepter le trafic local
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
# Ne pas intercepter ton proxy SOCKS5 (remplace IP_PROXY par ton IP)
sudo iptables -t nat -A REDSOCKS -d 93.89.213.48/32 -j RETURN
# Ne pas intercepter SSH
sudo iptables -t nat -A REDSOCKS -p tcp --dport 22 -j RETURN
# Tout le reste va vers gost/redir
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
# Appliquer aux sorties
sudo iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner vnc -j REDSOCKS


