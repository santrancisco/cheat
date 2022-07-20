Sending plaintext email using SES. To send formated, html, see https://docs.aws.amazon.com/cli/latest/reference/ses/send-email.html#examples

```bash
aws ses send-email --from youremail@gmail.com --to myemail@mailbox.org --message "test"
```

Execute a lambda function from cli

```bash
aws lambda invoke --function-name "lambdash-function-123456" --payload "{\"command\":\"$@\"}" output.txt

```

Generate a temporary token with limited IAM policy (loaded from file), the policy of the token depends on current user's IAM policy and what's in the json file.

```bash
aws sts get-federation-token --name test --policy file://testpolicy.json 
```

Short commands

`aws sts get-caller-identity` show current user/token/context

Find all public ip (base on all network interfaces in the network) - search by region:

`AWS_REGION=us-west-2  aws ec2 describe-network-interfaces  | jq -r '.NetworkInterfaces[].Association.PublicIp' | sort | uniq`

If we find interesting port open on a public ip, this comment could helps identifying which machine/elb it is attached to (Description is useful): 

`aws ec2 describe-network-interfaces --filter "Name=addresses.association.public-ip,Values={remoteIP}"`


Obtain information about a host base on its Id

`aws ec2 describe-instances  --filter "Name=instance-id,Values=i-071a3c3c5d33ce1b6"`