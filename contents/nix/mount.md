## Examples

Mount a 5gb ramdisk for log procecssing? ;) 

```bash
mount -t tmpfs -o size=5G,nr_inodes=5k,mode=700 tmpfs /tmp
```

Mount smb

```
mount -t cifs -o username=<username> //WIN_SHARE_IP/<share_name> /mnt/win_share

```

