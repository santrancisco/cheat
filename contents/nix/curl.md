### Tips

Useful alias to use curl with non-default Headers, fake random Referer and Cookie 

```bash
alias cur="curl -H \"Mozilla/5.0 (Linux; Android 4.4; Nexus 5 Build/_BuildID_) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/30.1.0.0 Mobile Safari/537.36\" -H \"Referer: https://mail.google.com/mail/u/0/#/`date|md5sum|cut -d ' ' -f 1`\" -H \"Accept-Encoding: deflate\" -H \"Accept-Language: en-US,en;q=0.9\" -H \"Cookie: ga=`date +%F_%H-%M-%S |md5sum|cut -d ' ' -f 1`\""
```

Going through socks proxy:

```bash
curl -v -x socks5h://167.71.117.75:1080 https://google.com
```

Write to file:

```bash
curl https://google.com -o index.html
```

readlist, curl request in 10 parallel threads

```
cat list.txt | xargs -P10 -I {} curl -X GET {}
```

Only print out http_code for each request

```bash
   curl --write-out %{http_code} --silent --output /dev/null google.com
```
