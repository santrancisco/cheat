### Cheatsheets

List of linux binaries that may let you escalate: https://gtfobins.github.io/

If you must use plaintext password to login to multiple servers, eg, to check on task list, using sshpass might help
```bash
sshpass -p PASSWORDGOESHERE  ssh -oStrictHostKeyChecking=no SERVERADDRESS "hostname; ps aux; echo ==============="
```bash