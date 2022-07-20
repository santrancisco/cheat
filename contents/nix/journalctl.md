## Tips

 - `journalctl --list-boots` : list all boots being logs
 - `journalctl -b` : look at log for just the current boot, append md5 of previous boot if you want to look at old logs
 - `journalctl _COMM=chromium` : Look at chromium log specifically
 - `journalctl -n 50 -f _COMM=chromium` : Show last 50 logs and tail log from chromium
 - `journalctl _COMM=chromium --since "10 minutes ago"` : Show chromium logs in the last 10 minutes
 - `journalctl -u bluetooth.service` : Look at log for bluetooth service specifically (run `systemctl` to get the list)
 - `journalctl -f _UID=0` : Tail log from another user (Use `id {username}` to know their id or `cat /etc/passwd`)
 