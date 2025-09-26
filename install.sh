#!/bin/bash

# ======================================================
# Script d'installation pour le projet
# ======================================================

# Arrêter le script en cas d'erreur
set -e

echo "🚀 Début de l'installation..."

# --- 1. Mettre à jour le système ---
echo "📦 Mise à jour des paquets..."
sudo apt update

# --- 2. Installer les dépendances système ---
echo "🔧 Installation des dépendances système..."
apt install xdotool libx11-dev curl screen redsocks snapd ipset iptables netfilter-persistent ipset-persistent iptables-persistent wget python3-pip python3 htop -y

echo "📚 Installation des dépendances Python..."
pip install requests --break-system-packages
pip install python3-xlib --break-system-packages

echo "Installation de gost"

snap install snapd
snap install gost

systemctl daemon-reload
systemctl restart snapd
PATH=$PATH:/snap/bin

export PATH=$PATH:/sbin:/usr/sbin


# Demander les valeurs à l'utilisateur


# 1. Remettre les politiques par défaut à ACCEPT (sécurité SSH)
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# 2. Supprimer toutes les règles des tables
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -t raw -F

# 3. Supprimer toutes les chaînes personnalisées
sudo iptables -X
sudo iptables -t nat -X
sudo iptables -t mangle -X
sudo iptables -t raw -X

# 4. Réinitialiser les compteurs
sudo iptables -Z




echo "Configuration proxy..."
read -p "Nom de la chaîne iptables (ex: REDSOCKS) : " CHAIN_NAME
read -p "Nom de l'utilisateur dont le trafic sera intercepté (ex: vnc) : " USER_NAME
read -p "Port de redirection (ex: 12345) : " REDIRECT_PORT
read -p "IP de ton proxy SOCKS5 (ex: 93.89.213.48) : " PROXY_IP
read -p "PORT de ton proxy SOCKS5 (ex: 12324) : " PROXY_PORT
read -p "Identifiant de ton proxy SOCKS5 : " PROXY_ID
read -p "mdp de ton proxy SOCKS5  : " PROXY_PSW

echo '#!/bin/bash

# Nom de la session screen
SESSION="gost"

# Vérifier si la session existe
if screen -list | grep -q "\.${SESSION}[[:space:]]"; then
    echo "⚠  La session screen '$SESSION' existe déjà. Suppression..."
    screen -S "$SESSION" -X quit
    sleep 1
fi

# Lancer une nouvelle session
echo "🚀 Démarrage du proxy dans une nouvelle session screen '$SESSION'..."
screen -S "$SESSION" gost -L=:9050 -F=socks5://"$PROXY_ID":"$PROXY_PSW"@"$PROXY_IP":"$PROXY_PORT"

echo "✅ Proxy lancé avec succès !"
' > proxy.sh

chmod +x proxy.sh

echo "Configuration fichier proxy.sh appliquée avec succès !"

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


netfilter-persistent save

echo "Configuration iptables appliquée avec succès !"

echo 'base {
        log_debug = on;
        log_info = on;
        log = "stderr";
        daemon = on;
        redirector = iptables;
}

redsocks {
         local_ip = 127.0.0.1;
         local_port = "$REDIRECT_PORT"; 
         ip = 127.0.0.1;
         port = 9050;     
         type = socks5;
}
' > /etc/redsocks.conf


systemctl enable redsocks 
systemctl start redsocks



echo "Configuration RedSocks appliqué avec succès !"

echo "✅ Installation terminée avec succès !"
echo "💡 Pense à executé proxy.sh en root ou sudo"

