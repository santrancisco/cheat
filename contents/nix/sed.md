Escape single quote : Use `\x27` instead `sed 's/user projects/user\x27 projects/g'`

If you want to replace all newlines with comma, simpler to use `tr` command:

```bash
cat file.txt | tr '\n' ','
```

An example of replacing a whole line after `##CHBASHCOMPLETION##` with REPLACELINEMARKER and then using 2nd sed command to replace REPLACELINEMARKER with content of environment variable which contains slashes "/" (hence we use `|` in sed replace command)

```bash
sed -i '/##CHBASHCOMPLETION##/!b;n;cREPLACELINEMARKER' $HOME/.bash_completion
sed -i "s|REPLACELINEMARKER|$autocomplete|g" $HOME/.bash_completion
```

Combine **every** 3 strings into 1 and replace newline with comma.

```bash
sed 'N;N;N;/\n/,/g' -i filename.txt
```

Every file in the folder, replace the 2nd line with `author = "(Search result GROUP 1)"`

```bash
ls | xargs -I {} sed -i '2s/- \(.*\)\r/author = "\1"/' {}
```

Remove 4th line in file.txt

```bash
sed -i '4d' file.txt
```

Add 2nd line to file.txt

```bash
sed -i '1 a Content of new 2nd line' file.txt
```
