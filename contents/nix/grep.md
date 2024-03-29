Example of reading a file, extract only matching pattern of mp3 filename from that file. For each filename, we check if that name already in an existing list, if not, use wget to download the file.

```bash
cat longtext.js  | grep audio | grep -oP '\/\K([^\/]*)mp3'  | xargs -I {} bash -exc "if ! grep -Fxq {} list.txt; then wget https://storage.googleapis.com/pte-magic-question-2018/{} -O ../../{};fi"
```

Running tail on log file and use grep on continuous stream to filter out things you dont want

```bash
tail -F apache_error.log   | grep --line-buffered  -v 103.228.147.62
```

simple use of if with multiple grep to identify lines that contains some words AND does not contain specific word ... useful with xargs to run through large number of files

```bash
if ! grep -q "donotinclude" ~/test/meh.tt && grep -Pq "(this|that)" ~/test/meh.tt; then echo "found_it"; fi
```

tail a log file, find specific log string and fire alert to slack
```bash
export SLACKWEBHOOK=Yourwebhook
while [ 1 ]; do (tail -f -n0 /mnt/xvdf1/asanbuild/stderr.log & ) | grep -q "AddressSanitizer" ; curl -X POST --data "{'text':'Found it - check log'}" "$SLACKWEBHOOK"; done
```