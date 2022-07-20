### Ports and services

Identify open port:

```bash
sudo lsof -n -i -P | grep LISTEN
```

Many daemon/services are started using launchd. To list all running instances, use `launchctl list` command.

To enable/disable builtin VNC or SSH server, go to "System Preference -> Sharing -> Screen Sharing or Remote Login

Reload Pulsesecure when it stuck on disconnecting or have dangling utun interface:
```bash
sudo launchctl unload -w /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
sudo launchctl load -w /Library/LaunchDaemons/net.pulsesecure.AccessService.plist
```