
# CONFIGURATION WAN1 (PRINCIPAL)
############################################
/ip dhcp-client
add interface=ether1 add-default-route=no use-peer-dns=no disabled=no comment="WAN1 FIBRE PRINCIPALE"


# CONFIGURATION WAN2 (SECONDAIRE)
############################################
/ip dhcp-client
add interface=ether6 add-default-route=no use-peer-dns=no disabled=no comment="WAN2 FIBRE BACKUP"


# ROUTES AVEC PRIORITÉ
############################################
# WAN1 priorité haute (distance 1)
/ip route
add dst-address=0.0.0.0/0 gateway=ether1 distance=1 check-gateway=ping comment="DEFAULT VIA WAN1"

# WAN2 backup (distance 2)
add dst-address=0.0.0.0/0 gateway=ether6 distance=2 check-gateway=ping comment="DEFAULT VIA WAN2"


# NAT POUR LES DEUX FIBRES
############################################
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade comment="NAT WAN1"
add chain=srcnat out-interface=ether6 action=masquerade comment="NAT WAN2"


# NETWATCH POUR SURVEILLANCE RÉELLE
############################################
/tool netwatch
add host=8.8.8.8 interval=10s timeout=3s \
down-script="/log warning WAN1_DOWN" \
up-script="/log info WAN1_UP"


# DNS PUBLIC (indépendant ISP)
############################################
/ip dns
set servers=1.1.1.1,8.8.8.8 allow-remote-requests=yes


# FIN 
######
