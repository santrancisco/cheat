### XARGS in script
If you want to run some function, you might wanna try to `export -f` it first so you can use it in subshell.
```bash 
function hello {
  echo "Hello $1"
}
export -f hello
echo -e "Nick\nMarry" | xargs -I {} bash -c "hello {}"
```

### XARG snippets

Here is an example of using xargs with bash -c to run multiple commands. this is very slow script to search for anything that return httpcode 302 from a list of URL and request it again to grab the location headerfrom the response. A better approach would be using async script in python, nodejs or go routines.

```bash
cat listofURL.txt | xargs -I {} bash -c 'if [ "$(curl --write-out %{http_code} --silent --output /dev/null {})" == "302" ]; then echo -n "{}"; curl -v "{}" 2>&1 | grep "location: ";fi
```

Here is a WTF example, We read the a list in csv format, pulling unique IP addresses in collumn 6 using `awk`, comparing them with the dodgyiplist.txt. For all the matches, pipe them to the next `xargs` command where we pull back the full row from the original huge list again and re-format it using awk for readability (eg building a URL in this case and some other variables we are intesrested in)


```bash
cat hugelist.csv | \
  awk -F "," '{ print $6 }'  | \
  sort -u  | \
  xargs -I {} bash -c "if ! grep -q '{}' dodgyiplist.txt ;then echo {}; fi" | \
  xargs -I [] bash -c 'grep [] hugelist.csv |  awk -F \',\' \'{ print "https://url_we_want_to_build.com/" $1 "/" $2 " , " $7 ", " $10 }\'' | \
sort -u 

```
Readlist, curl request in 10 parallel threads
```
cat list.txt | xargs -P10 -I {} curl -X GET -H "Host:127.0.0.1" {}
```

