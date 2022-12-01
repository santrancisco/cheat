To scan a specific file inside ECR image with virustotal:

```bash
AWS_PROFILE=AWS-User-Profile aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin {AccountID}.dkr.ecr.us-west-2.amazonaws.com

docker pull {AccountID}.dkr.ecr.us-west-2.amazonaws.com/{containername}@sha256:{containerversion}

docker run --rm -it --entrypoint=bash {AccountID}.dkr.ecr.us-west-2.amazonaws.com/{containername}@sha256:{containerversion}

export VTKEY=YOUR_VT_API_KEY
curl -vk --request POST --url 'https://www.virustotal.com/vtapi/v2/file/scan' --form "apikey=$VTKEY" --form 'file=@/file/location'
```