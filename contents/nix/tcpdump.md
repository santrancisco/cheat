### TIPS

Capture all packets on eth0, except for port 22 and 53 and write to `out.pcap`
```bash
tcpdump -i eth0 -XX -w out.pcap port not 22 and port not 53
```

Showing connections with timestamp (`-tttt`) on an interface + do not resolve hostname or port(`-n`), use `awk` to print the time stamp, source ip,port and destination ip&port.

```bash
 tcpdump -tttt -i enp57s0f1 -n  ip | awk '{ print $1,$2, gensub(/(.*)\.(.*)/,"\\1:\\2","g",$4), $5, gensub(/(.*)\.(.*):.*/,"\\1:\\2","g",$6) }'
## Sample output:
## 2019-10-27 16:12:33.564965 192.168.5.41:33184 > 104.25.152.102:443

```