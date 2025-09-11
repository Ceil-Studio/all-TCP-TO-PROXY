Partie VPS : 
-Installer Redsocks
-config redsocks dans /etc/redsocks.cfg
  base {
 log_debug = on;
 log_info = on;	
 log = "stderr";
 daemon = on;
 redirector = iptables;
}

redsocks {
 local_ip = 127.0.0.1;
 local_port = 12345; 
 ip = 127.0.0.1;
 port = 9050;     
 type = socks4;
}

-installer gost 
pre requis snapd

ici on utilise le port 9050 pour gost (voir config resocks)
lancer dans un screen la commande 
gost -L=:9050 -F=socks5://user:psw@proxy_IP:proxy_PORT


pour vérifier : 
curl ifconfig.me
sur le vps devrais donné l'ip du proxy

