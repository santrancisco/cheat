## TIPS

Install pubkey of the chosen private key onto server under your profile

```
ssh-copy-id -i ~/.ssh/id_rsa santrancisco@192.168.100.10
```

Use Dynamic port forwarding in SSH for SOCK proxy:

```
ssh -D 9999 ebfe.pw
curl -x socks5h://localhost:9999 ifconfig.co
```

Reverse tunnel to server behind NAT (Forward port 22 of current server/desktop to port 2222 on remote ebfe server so we can hit it directly from interweb)

```
ssh -R 2222:localhost:22 ebfe.pw
```


Forward tunnel - port forwarding to a destination server. In this example, we want to forward out port 80 of server 10.1.1.1 which is reachable from our ebfe.pw webserver.

```
ssh -L localhost:8080:10.1.1.1:80
```
