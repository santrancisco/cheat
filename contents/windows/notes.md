### Cheatsheets

Interesting site for redteam: https://www.ired.team/
Good resource: https://0xsp.com/offensive/web-attacks-payloads-collections
Using windows, microsoft signed binary with "extra" functionality for redteam: https://lolbas-project.github.io
Offensive Windows Tools cheatsheet: https://wadcoms.github.io/

### Forensic

https://devblogs.microsoft.com/scripting/use-powershell-to-aid-in-security-forensics/

```powershell
Get-ChildItem C:\ -recurse | where { $_.extension -eq ".exe" -or $_.extension -eq ".ps1" -or $_.extension -eq ".bat" -or $_.extension -eq ".hda" -or $_.extension -eq ".eight" } |  where-object {$_.lastwritetime -gt [datetime]::parse("01/01/2022")}  
Get-Process | Export-Clixml -Path \\hyperv1\shared\forensics\EDPROC.XML
Get-Service | Export-Clixml -Path \\hyperv1\shared\forensics\EDService.XML
Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-List 
Get-ScheduledTask | Export-ScheduledTask 
wmic startup get caption,command
```