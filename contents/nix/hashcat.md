### Tips

Straight forward cracking using hashcat and dictionary on handshakes captured by Pwnagotchi (WPA-PMKID-PBKDF2):
(Use `hcxpcaptool` to extract pmkid from all pcap files). Hash type`-m 16800` for pmkid cracking mode, `-a 0` means straight comparision with wordlist, `-w 3` means use work load profile 3(HIGH power consumption).

```
hcxpcaptool /root/handshakes/*.pcap -z multi.pmkid
hashcat -m 16800 -a 0 -w 3 multi.pmkid luckynumber.txt
```

pmkid cracking is the new attack and a lot quicker than straight up 4 way handshake cracking, however many handshakes are also captured this way. Thus, we may also need to convert the pcap file to hashcat format (hccapx) which we can use hash type `-m 2500` for WPA/WPA2.

```
hcxpcaptool /root/handshakes/*.pcap -o oldschoolhandshake.hccapx
hashcat -m 2500 -a 0 -w 3 oldschoolhandshake.hccapx luckynumber.txt
```

Generates `luckynumbers.txt` file where all passwords start with the word `lucky` and end with all possible permutation of 6,7,8,9. `--stdout` tells hashcat to generate candidates only and not cracking.

```
hashcat --stdout -o luckynumbers.txt -1'6789' "lucky?1?1"
```

Show previous cracked password from potfile (*pot file does not contains name of SSID*):
```
hashcat -m 16800 --show multi.pmkid
```

Hashcat comes with some nice rules to transform wordlist. Example to use leetspeak rules to generate new password list from a list of AP name:

```
hashcat --stdout -r rules/unix-ninja-leetspeak.rule name.txt
```



**Resource** : https://hashcat.net/wiki/doku.php?id=hashcat