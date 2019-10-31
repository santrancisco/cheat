Escape single quote : Use `\x27` instead `sed 's/user projects/user\x27 projects/g'`

If you want to replace all newlines with comma, simpler to use `tr` command:

```bash
cat file.txt | tr '\n' ','
```

An example of replacing a whole line after `##CHBASHCOMPLETION##` with REPLACELINEMARKER and then using 2nd sed command to replace REPLACELINEMARKER with content of environment variable which contains slashes "/" (hence we use `|` in sed replace command)

```bash
sed -i '/##CHBASHCOMPLETION##/!b;n;cREPLACELINEMARKER' $HOME/.bash_completion
sed -i "s|REPLACELINEMARKER|$autocomplete|g" $HOME/.bash_completion
``