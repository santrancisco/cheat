# Kubectl

Haxor tip: Query kubernetes API directly without kubectl, Ignore self signed cert and use token stored in container.

```
curl -k --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" -X GET  "https://{KUBE api address}/api/v1/namespaces/$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace)/pods"
```

List out all permission for your current role:
```
kubectl auth can-i --list
```

Get all secrets:
```
kubectl get secrets
```
