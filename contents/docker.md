## Useful aliases


Below are aliases and functions you can have in bashrc to help navigating docker containers. `dockershell[s]here` are functions to spawn docker with the current folder mapped to /<current directory name>

```bash
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"  
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

function dockershellhere() {  
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v `pwd`:/${dirname} -w /${dirname} "$@"
}
function dockershellshhere() {  
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v `pwd`:/${dirname} -w /${dirname} "$@"
}
```

----------
## Interesting docker containers

Create an unifi-controller container to manage UNIFI wifi APs

```bash
docker create --name=unifi-controller -e PUID=1000 -e PGID=1000 -e MEM_LIMIT=1024M -p 3478:3478/udp -p 10001:10001/udp -p 8080:8080 -p 8081:8081 -p 8443:8443 -p 8843:8843 -p 8880:8880 -p 6789:6789 -v home:/config --restart unless-stopped linuxserver/unifi-controller
```
