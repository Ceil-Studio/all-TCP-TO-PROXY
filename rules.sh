
sysctl -w net.ipv4.ip_forward=1


sudo iptables -t nat -N REDSOCKS 2>/dev/null

sudo iptables -t nat -F REDSOCKS
sudo iptables -t nat -F OUTPUT

sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp --dport 80 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp --dport 27015 -j RETURN

sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS

# regle de base qui fonctionne :

sudo iptables -t nat -N REDSOCKS
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
sudo iptables -t nat -A REDSOCKS -d 93.89.213.48/32 -j RETURN  # <-- exclure le proxy distant
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS


