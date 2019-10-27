## Transfer file

Using verbose to know if connection success and `-N` to close socket once EOF reaches

```bash
nc -vl 44444 > pick_desired_name_for_received_file
nc -Nv 10.11.12.10 44444 < /path/to/file/you/want/to/send
```

