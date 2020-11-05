### Working with iptables

There are 5 tables we can add/modify/delete rules from: `filter`, `nat`, `mangle`, `raw`, `security`. The rules in these tables are applied in various stage of the traffic flow between machines. 

Example blow show flushing all rules, adding and deleting a prerouting rules in `nat` table.


```
root@vultr:~# iptables -F
root@vultr:~# iptables -t nat -A PREROUTING --src 0/0 --dst 167.179.116.167 -p udp --dport 80:20000 -j REDIRECT 
root@vultr:~# iptables -L -t nat --line-number1./
Chain PREROUTING (policy ACCEPT)
num  target     prot opt source               destination         
1    REDIRECT   udp  --  anywhere             167.179.116.167.vultr.com  udp dpts:80:20000 redir ports 53

Chain INPUT (policy ACCEPT)
num  target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
num  target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
num  target     prot opt source               destination         

root@vultr:~# iptables -t nat -D PREROUTING 1
```

Saving iptables state
```
Debian/Ubuntu: iptables-save > /etc/iptables/rules.v4
RHEL/CentOS: iptables-save > /etc/sysconfig/iptables
```

Most linux distro has iptables-extensions and kernel modules installed by default now but there may be instances where there kernel modules aren't loaded and we won't have access to cool modes such as `conntrack` (helps keeping track of traffic state and allow iptables become stateful), `owner` (identify which user account is the owner of the traffic), `multiport` (allows specifying a list of ports, comma seperated in a single rule),...

Checkout https://www.frozentux.net/iptables-tutorial/iptables-tutorial.html for good exaplanation on tables, state, etc...

----------

### Example rules

Example iptables script with openvpn, a chain to log and drop

```
## Creating a new chain that would log and block
iptables -N LOGGINGDROP

# THis is just a test rule to - blocking on port 25
iptables -A INPUT -p tcp --dport 25 -j LOGGINGDROP

# Blocking SACK exploit
iptables -A INPUT -p tcp -m tcpmss --mss 1:500 -j LOGGINGDROP

# OpenVPN (depending on the port you run OpenVPN)
iptables -A INPUT -i venet0 -m state --state NEW -p tcp --dport 8080 -j ACCEPT

# Allow TUN interface connections to OpenVPN server
iptables -A INPUT -i tun+ -j ACCEPT

# Allow TUN interface connections to be forwarded through other interfaces
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -o venet0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i venet0 -o tun+ -m state --state RELATED,ESTABLISHED -j ACCEPT

# NAT the VPN client traffic to the internet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o venet0 -j MASQUERADE

iptables -A OUTPUT -o tun+ -j ACCEPT

# LOGGINGDROP chain 0 log first then drop.
iptables -A LOGGINGDROP  -j LOG --log-prefix "iptables: " --log-level 7
iptables -A LOGGINGDROP -j DROP
```


Forward all UDP traffics from 80 to 200000 to a single port (53). Useful when we want to run a honeypot or a vpn server to escape out from hotel wifi.

```
iptables -t nat -A PREROUTING --src 0/0 --dst 167.179.116.167 -p udp --dport 80:20000 -j REDIRECT --to-ports 53
```
Blocking new connection to port 22 for 15 minutes after 3 new connections.

```
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 900 --hitcount 3 -j DROP
```

NAT all traffic from internal interface (eth1) to internet/external interface (eth0):

```
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --append FORWARD --in-interface eth1 -j ACCEPT
```

iptables rule to deny all outgoing traffic for user name tor but allow connections to specific local ports belong to local tor daemon SOCK proxy. 

```
sudo iptables -A OUTPUT -m owner --gid-owner tor -d 127.0.0.0/24 -p tcp -m multiport --dports 9050,9051,9150,9151 -j ACCEPT
sudo iptables -A OUTPUT -m owner --gid-owner tor -d 0.0.0.0/0 -j REJECT
```

