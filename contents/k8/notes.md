# K8 notes

### Tips!

Kubernettes lens (https://k8slens.dev/) is awesome project to manage Kubernettes cluster!

A haxor tip: Query kubernetes API directly without kubectl, Ignore self signed cert and use token stored in container.

```bash
curl -k --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -X GET  "https://{KUBE api address}/api/v1/namespaces/$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)/pods"
```

### kubectl

List out all permission for your current role:

```bash
kubectl auth can-i --list
```

Get all secrets:

```bash
kubectl get secrets
```

## Working with EKS

Update role name
```bash
aws eks --region us-west-2 update-kubeconfig --name development-non-prod-data-plane --role-arn arn:aws:iam::9999999999999:role/AdminRolename --profile dev
```

To mitm kubectl command:
 - put Burp certificate at the bottom here if we are using aws cli sts to assumerole: /usr/local/aws-cli/v2/current/dist/awscli/botocore/cacert.pem
 - Run with special insecure flag: `kubectl --insecure-skip-tls-verify --token=$(cat token) auth can-i --list`


## Access review:

Check pod's token access:

```bash
#!/bin/bash
#set -ex
NAMESPACE=$1
POD=$2
### Get the pod token
kubectl exec -n $NAMESPACE $POD -- cat /var/run/secrets/kubernetes.io/serviceaccount/token > tmp/$NAMESPACE.$POD.token
### Check access
kubectl --token=$(cat tmp/$NAMESPACE.$POD.token) auth can-i --list
```