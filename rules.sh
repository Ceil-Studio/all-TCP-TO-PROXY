
sysctl -w net.ipv4.ip_forward=1

sudo iptables -t nat -N REDSOCKS
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 93.89.213.48/32 -j RETURN  # <-- exclure le proxy distant (changer ip par celle du proxy)
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS

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
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS


