### Tips

Show and taint a terraform object to force recreation

```bash
terraform show
terraform taint module.ec2.aws_instance.this[0]
terraform apply
```

To show debugging log, set `TF_LOG` environment variable to TRACE, DEBUG, INFO, WARN or ERROR.

`tfswitch` is perfect to manage multiple 

set tfswitch alias in .bashrc so tfswitch target the softlink in ~/bin/ so no extra permission needed `alias tfswitch='/usr/local/bin/tfswitch -b ~/bin/terraform'`

To delete&recreat a resource, you can use `taint`: `terraform taint aws_secretsmanager_secret.mysecret`


Note: It's not possible to simply change from single region kms to multi region kms - Terraform will create new key.