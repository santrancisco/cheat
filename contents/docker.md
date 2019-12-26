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

Postgresql for development:

```bash
docker run --name pg-docker -e POSTGRES_PASSWORD=postgres -d -p 127.0.0.1:5432:5432 -v $HOME/docker/volumes/postgres:/var/lib/postgresql/data  postgres
```

Interactive php shell:
```bash
docker pull
docker run --rm -it php php -a
```

## Notes

 - Linux stores images, overlay file systems, etc here `/var/lib/docker/`
 - Learn about built step for the container : `docker image history -H --no-trunc ripsan`
 - Live stream of usage : `docker stats`
 - Run and immediately attach to stdout for a container `docker start 9b94b927f1fb --attach`
 - Overwrite entrypoint for that and start instance temporary `docker run -ti --entrypoint /bin/bash 413171555710`
 - Delete all unused docker containers: `docker rm $(docker ps -q --filter "status=exited")`
 - Build docker images from current folder and delete all intermediate containers `docker build -t=myimage --rm=true .`
 - Create tag and push to dockerhub
```bash
docker tag localproject:latest santrancisco/sanctf:latest
docker push santrancisco/sanctf:latest
```