Simple steps to elevate to highest permission (System) from Admin:
- Download pstools
- Run cmd as administrator by right click or `powershell.exe Start-Process -Verb RunAs cmd`
- Elevate to System using psexec `c:\tools\psexec.exe -sid cmd`

`taskkill /pid {pid} /f` simple taskkill

taskmgr -> go to service -> get service name or using `sc query type=service`
Stop service: `sc stop ds_agent`

powershell -> `wmic process where "name='coreServiceShell.exe'" delete`


To map/unmap remote drive (eg, c drive):
```
net use f: \\{SERVERNAMEORIP}\c$ /u:{domain\\test_user} {password}
net use /delete \\{SERVERNAMEORIP}\c$
```
Use `netstat -anb` to check what port is listening. 