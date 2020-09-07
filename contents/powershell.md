Using `Select-Object -Property *` will let you see what properties we have for that object/each object go down the pipe.

```
get-process | where {$_.id -match '2496'} | Select-Object -Property *
```

Check for Non-microsoft processes
```
get-process | where {$_.company -notmatch 'microsoft'} | Select-Object -Property * | sort-object -property 'cpu' | select id, CPU,  ProcessName,path,Company | format-table -Autosize
```

```
Get-CimInstance Win32_StartupCommand | Select-Object Name, command, Location, User | Format-List 
```

```
 
reg query  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce"
reg query  "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run"
reg query  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce"
reg query  "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
```

```
Get-ScheduledTask | where {$_.taskpath -notmatch 'microsoft'}
```