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


ici on utilise le port 9050 coté VPS c'est fini

Partie Hote
-installer sshd et l'activé
-creer un pont entre le vps et l'hote utilisé le meme port (9050)
  ssh -fN -R 9050:localhost:9050 user@IP_VPS
-utiliser ce port recu pour le redirigé vers internet
  ssh -fN -D 9050 localhost

pour vérifier : 
curl -4 ifconfig.me
sur le vps devrais donné l'ip de l'hote

