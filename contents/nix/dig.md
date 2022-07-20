### Tips

Some interesting commands:

```bash
# Show ebfe.pw txt record only (Useful if we wanna pass some variables between servers 
# using ansible scripts or terraform startup scripts for example)
dig txt ebfe.pw  +short 
# Show full answer for PTR record of 8.8.8.8 
dig -x 8.8.8.8  +noall +answer
# Show just the reversed domain record for 8.8.8.8
dig -x 8.8.8.8  +short 
```