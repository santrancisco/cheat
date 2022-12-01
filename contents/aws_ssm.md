## Setting up

Requirement for the EC2 instance:
 - Need internet access (public subnet = need internet IP | private subnet = need Internet GW installed)
 - Role attached to EC2 must have `AmazonSSMManagedInstanceCore` policy attached
 - Pick Amazon Linux2 AMI for pre-installed SSM

Tip: Follow the quick setup in system manager page - this should create the neccessary resource (IAM Role)

## Connect via SSM

Connect with ssm-user:

```bash
aws ssm start-session --target {InstanceID}
```

## Portfowarding

Local host:

```bash
aws ssm start-session --target {InstanceID} --parameters '{"portNumber":["80"],"localPortNumber":["9999"]}'
```

Remote host:

```bash
aws ssm start-session --target i-0fec5cb141131685d --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '{"portNumber":["80"],"localPortNumber":["8080"],"host":["172.31.10.139"]}'
```

## SSH over Session Manager

Add the following to `~/.ssh/config.`:

```bash
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

Then you can establish connection with `ssh -i ~/.ssh/YOUR_PRIVATE_KEY.pem ec2-user@{instanceID eg: i-0eda4ef0ffff1dbc4}`