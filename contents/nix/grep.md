Example of reading a file, extract only matching pattern of mp3 filename from that file. For each filename, we check if that name already in an existing list, if not, use wget to download the file.

```
cat longtext.js  | grep audio | grep -oP '\/\K([^\/]*)mp3'  | xargs -I {} bash -exc "if ! grep -Fxq {} list.txt; then wget https://storage.googleapis.com/pte-magic-question-2018/{} -O ../../{};fi"
```

Running tail on log file and use grep on continuous stream to filter out things you dont want

```
tail -F apache_error.log   | grep --line-buffered  -v 103.228.147.62
```

simple use of if with multiple grep to identify lines that contains some words AND does not contain specific word ... useful with xargs to run through large number of files

```
if ! grep -q "donotinclude" ~/test/meh.tt && grep -Pq "(this|that)" ~/test/meh.tt; then echo "found_it"; fi
```
