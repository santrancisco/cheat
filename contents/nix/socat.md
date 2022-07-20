Poor man telnetd shell
```
socat tcp-l:2023,reuseaddr,fork exec:"/bin/bash"
```


Poor man mitm using socat and tee (connect to socat listener --> tee append to l2r --> connect remote server --> tee response to r2l):

```
socat TCP-LISTEN:8080,reuseaddr,fork SYSTEM:'tee -a l2r | socat - "TCP:google.com:80"  | tee -a r2l' 
socat TCP-LISTEN:8080,reuseaddr,fork SYSTEM:'tee -a l2r | socat - "SSL:google.com:443,verify=0"  | tee -a r2l' 
#Test:
curl -H "www.google.com" localhost:8080
```

Note: This neat trick can be used to decrypt/decode stuffs on the wire

Connect to serial port 1:
```
socat readline /dev/ttyS1,raw,echo=0,crlf,nonblock
```

Trying to create a socat tls proxy but getting SSLV3 error? openssl issue? here is how you get it sorted - install 1.7.4.3 and build it with openssl support so we can use openssl-min-proto and max-proto options!

```
sudo apt install openssl libssl-dev 
wget https://fossies.org/linux/privat/socat-1.7.4.3.tar.gz
tar -zxvf socat-1.7.4.3.tar.gz
cd socat-1.7.4.3.tar.gz
sudo ./socat -v -x openssl-listen:443,reuseaddr,cert=/letsencryptpath/fullchain12.pem,key=/letsencryptpath/privkey12.pem,verify=0,openssl-min-proto-version=TLS1.2,openssl-max-proto-version=TLS1.3,fork ssl:142.250.71.78:443,openssl-min-proto-version=TLS1.2,openssl-max-proto-version=TLS1.3,verify=0
```