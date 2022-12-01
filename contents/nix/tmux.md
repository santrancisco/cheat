How I used ASAN build to test vuls for clickhouse project with simple script to orchestra opening tmux, split screens etc:

```
tmux new -d -s asantest \; split-window -h ;\ split-window -v;\
tmux send-keys -t asantest.1 "while [ 1 ]; do (tail -f -n0 /mnt/xvdf1/asanbuild/stderr.log & ) | grep -q \"AddressSanitizer\" ; curl -X POST --data \"{'text':'ASAN build found something interesting.'}\" \"https://hooks.slack.com/services/{slacktoken}\"; done" ENTER
tmux send-keys -t asantest.2 "tail -F /mnt/xvdf1/asanbuild/stderr.log" ENTER
tmux send-keys -t asantest.0 "cd /mnt/xvdf1/ClickBench/clickhouse; while [ 1 ];do ASAN_SYMBOLIZER_PATH=`which llvm-symbolizer`  /mnt/xvdf1/asanbuild/clickhouse server 2>/mnt/xvdf1/asanbuild/stderr.log;done" ENTER
tmux a -t asantest
```