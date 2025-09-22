#!/bin/bash

# Demander les valeurs à l'utilisateur
read -p "Nom de la chaîne iptables (ex: REDSOCKS) : " CHAIN_NAME
read -p "Nom de l'utilisateur dont le trafic sera intercepté (ex: vnc) : " USER_NAME
read -p "Port de redirection (ex: 12345) : " REDIRECT_PORT
read -p "IP de ton proxy SOCKS5 (ex: 93.89.213.48) : " PROXY_IP

# Créer la chaîne
sudo iptables -t nat -N "$CHAIN_NAME"

# Ne pas intercepter le trafic local
sudo iptables -t nat -A "$CHAIN_NAME" -d 127.0.0.0/8 -j RETURN

# Ne pas intercepter le proxy SOCKS5
sudo iptables -t nat -A "$CHAIN_NAME" -d "$PROXY_IP"/32 -j RETURN

# Ne pas intercepter SSH
sudo iptables -t nat -A "$CHAIN_NAME" -p tcp --dport 22 -j RETURN

# Tout le reste vers le port de redirection
sudo iptables -t nat -A "$CHAIN_NAME" -p tcp -j REDIRECT --to-ports "$REDIRECT_PORT"

# Appliquer la chaîne aux sorties de l'utilisateur
sudo iptables -t nat -A OUTPUT -p tcp -m owner --uid-owner "$USER_NAME" -j "$CHAIN_NAME"

echo "Configuration iptables appliquée avec succès !"

