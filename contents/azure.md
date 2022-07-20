Switching subscriptions:

List all accounts

```bash
az account list
az account set --subscription "Subscription Name"
```

Azure is so shit... Interfaces without secgroup will be left open to the world... Use this to identify those interfaces without secgroups:
`az network nic list -g "Resource-Group-Name"  | jq '.[] as $i | "\($i.name) - \($i.networkSecurityGroup.id)"'`

Create a bashscript to snapshot all OS & data disks for specific Resource group - Do go through each of them to make sure it makes send before execute.

```bash
az vm list -d -g "Resource-Group-Name" | jq -r '.[].storageProfile.dataDisks[] as $o | "az snapshot create -g Resource-Group-Name -n\($o|.name)-snapshot --source \($o|.managedDisk.id)"'  > snapshot-images.sh
az vm list -d -g "Resource-Group-Name" | jq -r '.[].storageProfile.osDisk as $o | "az snapshot create -g Resource-Group-Name -n\($o|.name)-snapshot --source \($o|.managedDisk.id)"'  >> snapshot-images.sh
```

Mass attach security group to all intefaces on 192.168.1.0/24 network:
```bash
## Get the ID of the secgroup we wanna attach
SECGROUP=$(az network nsg show --resource-group "DevOpsCentral" -n "Mandiant_SecGroup" | jq -r '.id')
az network nic list   | jq -r '.[] as $i | "\($i.id) - \($i.ipConfigurations[0].privateIpAddress)"' | grep 192.168.0 | sed 's/ - .*//g' | xargs -I {} echo az network nic update --ids {} --network-security-group $SECGROUP > updatesecgroup.sh
```
