Generate Self-signed SSL certificate for nginx

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
```

Below is a script to generate a custom CA + cert ...this way we can add custom CA into trust store and generate all the certs we want.

```bash
#!/bin/bash
# Generate private key for our CA
openssl genrsa -des3 -out myCA.key 2048
# Generate root certificate for our CA
openssl req -x509 -new -nodes -key myCA.key -sha256 -days 825 -out myCA.pem

NAME=$1 # argument 1 of the script is the domain name for the cert
# Generate a private key
openssl genrsa -out $NAME.key 2048
# Create a certificate-signing request (CSR)
openssl req -new -key $NAME.key -out $NAME.csr
# Create a config file for the extensions
>$NAME.ext cat <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $NAME # Be sure to include the domain name here because Common Name is not so commonly honoured by itself
DNS.2 = *.$NAME # Optionally, add additional domains (I've added a subdomain here)
IP.1 = 127.0.0.1 # Optionally, add an IP address (if the connection which you have planned requires it)
EOF
# Create the signed certificate
openssl x509 -req -in $NAME.csr -CA myCA.pem -CAkey myCA.key -CAcreateserial \
-out $NAME.crt -days 825 -sha256 -extfile $NAME.ext
```