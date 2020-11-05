
Example to rsync a remote files which require sudo permission and the ssh server is on unique port (2222)

```
rsync --rsync-path="sudo rsync" -r -v -e "ssh -p2222" pi@10.0.0.2:/remote/location ./local/folder
```

rsync all php files under folder and subfolder on server, compress file prior sending to local file

```
rsync -zav -e ssh --include="*.php" --include="*/" --exclude="*" username@serveraddress.com:'/var/www/serveraddress.com/htdocs' ./
```
