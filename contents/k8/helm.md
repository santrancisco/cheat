Helm is package manager for Kubernetes - like apt get for K8 O_o

Example of how you can install falcosecurity via helm:

```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm install falco falcosecurity/falco
```
Note: the repourl can sometimes throw a 404 because there is no index.html and that is fine because what helm looks for is the index.yaml file. In this case, it would be https://falcosecurity.github.io/charts/index.yaml