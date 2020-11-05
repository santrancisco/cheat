Example for loop used for ping scan 192.168.5.0/24 subnet, extracting ip and time taken for response using `cut`

```bash
 for x in {1..254..1}; do ping -c 1 192.168.5.$x | grep "64 b"|cut -d " " -f4,7 ;done
```

Example of using while loop instead of `watch` command when there is no watch

```bash
while true; do echo "Do something; sleep 1; done
```