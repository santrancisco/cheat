### Inotify

The following script, `watchme.sh`, watches changes in the current running folder (`pwd`) and its subfolder - ignorning files under vendor,lib folder and file end with .log.
When there are changes, watchme.sh restart the watched process/app.

```
#!/bin/sh

## Save this script as watchme.sh
## Example USAGE: `watchme.sh python yourapp.py`

sigint_handler()
{
  kill $PID
  exit
}

trap sigint_handler SIGINT

while true; do
  $@ &
  PID=$!
  inotifywait -e modify -e move -e create -e delete -e attrib -r `pwd` --exclude (vendor|lib|\.log)
  kill $PID
done
```