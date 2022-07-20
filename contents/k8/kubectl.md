### kubectl

List out all permission for your current role:

```bash
kubectl auth can-i --list
```

Get all secrets:

```bash
kubectl get secrets
```

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