Sending plaintext email using SES. To send formated, html, see https://docs.aws.amazon.com/cli/latest/reference/ses/send-email.html#examples

```bash
aws ses send-email --from youremail@gmail.com --to myemail@mailbox.org --message "test"
```

Execute a lambda function from cli

```bash
aws lambda invoke --function-name "lambdash-function-123456" --payload "{\"command\":\"$@\"}" output.txt

```

Short commands

`aws sts get-caller-identity` show current user/token/context