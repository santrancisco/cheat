
record the number of syscalls made by particular process:

```bash
## Logging all syscalls made in 10seconds
perf stat -p 1333337 -e 'syscalls:*'  -a sleep 10 2>&1 | tee 10seconds_perfstats.txt
## Logging the number of syscalls being made per second for particular PID by counting the number of sys_enter (syscall has 2 direction: enter & exit) 
perf stat -e raw_syscalls:sys_enter -I 1000 -p 1333337 
```

CPU usage (pidstat does average while top aggregate all CPU from all cores so this number can go over 100%):

```bash
pidstat -p 1333337
top -p 1333337
```