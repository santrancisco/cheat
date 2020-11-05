Find all file with .php extension and build a list of URLs we could try to access directly. Access these URLs, printout http_code for each of them to our terminal and include all 200 responses in a text file.

```bash
find . -iname "*.php" | sed 's/^\.\//https:\/\/www.serveraddress.com\//g' | \
   xargs -I {} -P100 curl -s -H "san-debug: pentest" --write-out '{}: %{http_code}\n' -o /dev/null {} | \
   tee /dev/tty | grep 200 > 200.txt
```