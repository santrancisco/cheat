## Logging
Audit log actually goes into cloudtrail

## Setting up SES to receive email and verify a sending email:
 - Go to AWS SES -> Email Receiving ->create rule set -> create rule -> ship to s3 & create a new s3 bucket for it
 - Set up mx record points to `10 inbound-smtp.{region}.amazonaws.com`
 - Go to AWS SES -> Verified Identities -> create identity -> email

## 