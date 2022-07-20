## Transfer file

Using verbose to know if connection success and `-N` to close socket once EOF reaches

```bash
nc -vl 44444 > pick_desired_name_for_received_file
nc -Nv 10.11.12.10 44444 < /path/to/file/you/want/to/send
```

Listening on 443 with legit cert (if used letsencyrpt, use the chained cert)
```
 sudo ncat -k --listen --ssl --ssl-cert /etc/letsencrypt/live/ebfe.pw/cert.pem --ssl-key /etc/letsencrypt/live/ebfe.pw/privkey.pem  -p 443 -v
```