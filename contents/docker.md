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
To get interactive bash inside a running container:

`docker exec -i {containerID} bash`

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

Automate decoding/decryption tool 

```bash
docker run -it --rm remnux/ciphey
```

WPScan

```bash
docker pull wpscanteam/wpscan
# Enumerate user
docker run -it --rm wpscanteam/wpscan --url https://ourtarget.com/ --enumerate u
# Scan website with wpvulndb token and output to a file in host
docker run -it -v `pwd`:/test --rm wpscanteam/wpscan --url https://ourtarget.com/ -o /test/scanoutput.txt --api-token {{https://wpvulndb.com/ token}}
# Scan with custom content and plugin directory
docker run -it --rm wpscanteam/wpscan --url https://ourtarget.com/ --wp-content-dir content  --wp-plugin-dir "content/plugins"
```

SFTP File transfer

```bash
docker pull atmoz/sftp
docker run -v /host/upload:/home/foo/upload -p 2222:22 -d atmoz/sftp foo:pass:1001
```

Splunk for local investigation. Splunk in docker: https://github.com/splunk/docker-splunk
```bash
docker run -d -p 8000:8000 -e "SPLUNK_START_ARGS=--accept-license" -e "SPLUNK_PASSWORD=$SPLUNKPASS" --name splunk splunk/splunk:latest
```

Need a chrome browser inside docker to checkout dodgy website? Use kasmweb/chrome. After running the command, visit https://localhost:6901 (Chrome may throw certificate issue and refuse to move forward. Just enter "thisisunsafe" and the page will reload). Use "kasm_user" as username and the password enter in command below to enter.

```bash
docker run --rm  -it --shm-size=512m -p 127.0.0.1:6901:6901 -e VNC_PW=password kasmweb/chrome:1.8.0-edge
```

Need a tor browser to look at some flashpoint intel feed? 

```bash
docker run --rm  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/tor-browser:1.10.0-rolling
```

Need a telegram:

```bash
docker run  -it --shm-size=512m -p 6901:6901 -e VNC_PW=password --name telegram  kasmweb/telegram:1.10.0-rolling
```

## Notes

 - Linux stores images, overlay file systems, etc here `/var/lib/docker/`
 - Learn about built step for the container : `docker image history -H --no-trunc ripsan`
 - Inspect a docker container and learn about things like environment variables: `docker inspect {id}`
 - Live stream of usage : `docker stats`
 - Run and immediately attach to stdout for a container `docker start 9b94b927f1fb --attach`
 - Overwrite entrypoint for that and start instance temporary `docker run -ti --entrypoint /bin/bash 413171555710`
 - Delete all unused docker containers: `docker rm $(docker ps -q --filter "status=exited")`
 - Build docker images from current folder and delete all intermediate containers `docker build -t=myimage --rm=true .`
 - Copy file from docker: `docker cp 628ff479a093:/eapol/test.config ./`
 - Create tag and push to dockerhub
 - Oneline docker escape GCP Cloudshell to host OS: `sudo docker -H unix:///google/host/var/run/docker.sock run -v /:/host -it ubuntu chroot /host /bin/bash`

```bash
docker tag localproject:latest santrancisco/sanctf:latest
docker push santrancisco/sanctf:latest
```

## ECR note:
 - List all repositories in a region `aws ecr describe-repositories --region ap-southeast-2`
 - Authenticate to ECR at a region: `aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin {Accountid}.dkr.ecr.ap-southeast-2.amazonaws.com`
 - Build the project `docker build -t firefoxsend .`
 - Tag it with ECR url `docker tag firefoxsend:latest {Accountid}.dkr.ecr.ap-southeast-2.amazonaws.com/firefoxsend:latest`
 - Pushing docker containers to ECR `docker push {Accountid}.dkr.ecr.ap-southeast-2.amazonaws.com/firefoxsend:latest`

Series of command to list all repositories in one region, list the images in it and grab the ECR vulnerability image scanning result.

```bash
aws --region ap-santranciscosoutheast-2 ecr describe-repositories 
aws --region ap-southeast-2 ecr describe-images --repository-name firefoxsend
aws --region ap-southeast-2 ecr describe-image-scan-findings --repository-name firefoxsend --image-id imageTag=latest
```

## Managing multiple docker swamp

Below is an easy way to manage docker remotely over SSH. Note that the user used here need to have docker access on remote server.

```bash
docker context create removeserver --default-stack-orchestrator=swarm  --docker "host=ssh://username@removeserverdocker.address:2222"
docker context use removeserver
## Or using environment variable to temporary switch:
DOCKER_CONTEXT=removeserver docker ps
```