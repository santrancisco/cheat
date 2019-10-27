## TIPS

`cut` is lighter/faster than `awk`. Example for `cut` to extract field 1 and 3 using comma as delimeter and print in `Name: PhoneN0` form:

```bash
echo "Name, Age, PhoneNo, Description" | cut -d "," -f 1,3 --output-delimiter=":"
```

This is helpful when you want to color the first part of the command only using awk by printing it first then set that collumn to nothing "" and print the whole command $0

```bash
history | tail -n 20 | awk '{ printf "033[35m" $1 "033[0m"; $1 = ""; print $0;}'
```

Simnple example of using `gensub` to get 2 capturing groups and print them out in different way: `gensub(/(capturing group 1)\.(capturing group 2)/,"\\1:\\2","g",$4)`, or in practice with tcpdump:

```bash
## Sample Input: 
## 2019-10-27 16:14:50.154497 IP 192.168.5.41.33184 > 104.25.151.102.443: Flags [P.], seq 1267794636:1267794709, ack 2827291787, win 9814, length 73
tcpdump -tttt -i enp57s0f1 -n  ip | awk '{ print $1,$2, gensub(/(.*)\.(.*)/,"\\1:\\2","g",$4), $5, gensub(/(.*)\.(.*):.*/,"\\1:\\2","g",$6) }'
## Sample output:
## 2019-10-27 16:14:50.154497 192.168.5.41:33184 > 104.25.152.102:443
```