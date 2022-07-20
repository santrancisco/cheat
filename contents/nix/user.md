`adduser` creates user along with their home folder while `useradd` is low-level utility to add user

Add user to a group:

```bash
usermod -a -G groupname username
```

Remove user from group:

```bash
gpasswd -d username groupname
```