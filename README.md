# README – Configuration Double Fibre avec Basculement Automatique (Failover)
## MikroTik RouterOS – Architecture Entreprise

---

##  Objectif

Mettre en place une architecture WAN redondante utilisant deux connexions fibre :

- WAN1 → Fibre principale
- WAN2 → Fibre secondaire (backup automatique)
- Basculement automatique en cas de panne
- Retour automatique lorsque WAN1 redevient disponible
- Continuité de service sans interruption manuelle

---

##  Architecture Réseau

| Interface | Rôle | Description |
|------------|------|------------|
| ether1 | WAN1 | Fibre principale |
| ether6 | WAN2 | Fibre secondaire (backup) |
| Bridge/VLAN | LAN | Réseau interne (inchangé) |

---

##  Fonctionnement Technique

### 1️ DHCP Client sur chaque WAN

Les deux interfaces WAN obtiennent automatiquement une adresse IP depuis leurs FAI respectifs.

Options importantes :
- `add-default-route=no` → empêche l'ajout automatique de route par le DHCP
- `use-peer-dns=no` → évite d'utiliser les DNS du FAI

---

### 2️ Routage avec Priorité (Distance)

Le routage fonctionne avec le mécanisme de "distance" :

- WAN1 → distance=1 (prioritaire)
- WAN2 → distance=2 (backup)

Si WAN1 devient injoignable :
- MikroTik détecte l'échec via `check-gateway=ping`
- La route WAN1 est désactivée
- WAN2 prend automatiquement le relais

Lorsque WAN1 revient :
- La route distance=1 redevient active
- Le trafic repasse automatiquement dessus

---

### 3️ NAT sur les Deux Interfaces

Deux règles NAT distinctes assurent la traduction d'adresse :

- NAT via WAN1
- NAT via WAN2

Cela garantit que le trafic sort correctement quelle que soit la fibre active.

---

### 4️ Surveillance avec Netwatch

Netwatch surveille la connectivité vers un hôte externe (ex: 8.8.8.8).

Paramètres :
- interval=10s → vérification toutes les 10 secondes
- timeout=3s → délai avant échec
- down-script → log si WAN1 tombe
- up-script → log si WAN1 revient

Cela permet :
- Monitoring
- Alertes
- Journalisation d'événements réseau

---

### 5️ DNS Public Indépendant

Les serveurs DNS sont configurés manuellement :

- 1.1.1.1
- 8.8.8.8

Avantages :
- Indépendance vis-à-vis du FAI
- Résolution stable même en cas de basculement

---

##  Séquence de Basculement

1. WAN1 fonctionne normalement.
2. WAN1 devient inaccessible.
3. MikroTik détecte l’échec via ping.
4. Route WAN1 désactivée automatiquement.
5. WAN2 prend le relais immédiatement.
6. WAN1 revient.
7. Le trafic repasse automatiquement sur WAN1.

Aucune intervention manuelle requise.

---

##  Avantages de cette Architecture

✔ Haute disponibilité Internet  
✔ Continuité de service  
✔ Pas de redémarrage nécessaire  
✔ Compatible VLAN / Hotspot / QoS  
✔ Architecture adaptée PME / ONG / Hôpital / École  

---

##  Bonnes Pratiques Recommandées

- Surveiller au moins 2 adresses externes (8.8.8.8 + 1.1.1.1)
- Sauvegarder la configuration régulièrement
- Tester le failover en débranchant physiquement WAN1
- Mettre en place des alertes email en cas de panne

---

##  Niveau d’Architecture

Type : Failover simple (Active / Standby)  
Disponibilité : Haute  
Complexité : Moyenne  
Stabilité : Très élevée  

---

##  Évolutions Possibles

- Load Balancing 50/50
- Load Balancing intelligent par VLAN
- Failover avec SLA avancé
- Double monitoring multi-host
- Notification Email / Telegram
- Monitoring Zabbix / Grafana

---

##  Conclusion

Cette configuration permet d’assurer une continité Internet fiable et professionnelle grâce à un mécanisme de basculement automatique entre deux fibres.

Elle constitue une base solide pour une infrastructure réseau entreprise sécurisée et évolutive.

---

FIN DOCUMENTATION
