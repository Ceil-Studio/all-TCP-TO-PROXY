# Nettoyer les anciennes règles
sudo iptables -t nat -F REDSOCKS
sudo iptables -t nat -F OUTPUT

# Garder les exclusions localhost
sudo iptables -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN

# Exclure panel (HTTP seulement)
sudo iptables -t nat -A REDSOCKS -p tcp --dport 80 -j RETURN

# Exclure GMod
sudo iptables -t nat -A REDSOCKS -p tcp --dport 27015 -j RETURN

# Tout le reste redirigé vers redsocks (port 12345)
sudo iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345

# Appliquer la chaîne REDSOCKS sur tout le trafic sortant TCP
sudo iptables -t nat -A OUTPUT -p tcp -j REDSOCKS

