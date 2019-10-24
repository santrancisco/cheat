## TIPS

this is helpful when you want to color the first part of the command only using awk by printing it first then set that collumn to nothing "" and print the whole command $0

```
history | tail -n 20 | awk '{ printf "033[35m" $1 "033[0m"; $1 = ""; print $0;}'
```
