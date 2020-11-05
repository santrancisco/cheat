Reverse DNS lookup can be very fast to do recon in a LAN environment:

```bash
santrancisco@pop-os:~/github/awsalarmtrigger$ nmap -sn -Pn -R 10.1.1.0/24  | grep cluster.local
Nmap scan report for dns.cluster.local (10.1.1.4)
Nmap scan report for bi.cluster.local (10.1.1.6)
Nmap scan report for prtg.cluster.local (10.1.1.7)
Nmap scan report for apt.cluster.local (10.1.1.80)
Nmap scan report for ntp.cluster.local (10.1.1.123)
Nmap scan report for radius.cluster.local (10.1.1.181)
```