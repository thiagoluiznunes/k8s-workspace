# ArgoCD

## Dependencies:
- kubernetes
- kubectl
- helm
- kind
- argocd cli

## Installing ArgoCD in Kind Cluster
- Create cluster using kind:
```console
$ kind create cluster --name argocd
```
- Create namespace for ArgoCD
```console
kubeclt create namespace argocd
```
- Apply the latest stable version manifest
```console
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
- View deployment pods
```console
kubectl get pods -n argocd
```

## Expose ArgoCD UI
By default, ArgoCD is only accessible from within the cluster. To expose the UI to users you can utilize any of the standard Kubernetes networking machanisms such as: 
- Ingress(recommended for production)
- Load balancer(affects cloud cost)
- NodePort(simple but not very flexible)

Using port-foward to access argocd-server:
```console
$ nohup kubectl port-forward svc/argocd-server 8000:80 > /dev/null 2>&1 &
```
Log port-forward:
```console
$ ps -ef|grep port-forward
$ kill -9 PORT_NUMBER //kill port
```

### Login in the ArgoCD UI
- retrieve admin password created as default
```console
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > admin-pass.txt
```
## ArgoCD CLI

- Installing cli
```console
$ curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.1.5/argocd-linux-amd64
```
```console
$ chmod +x /usr/local/bin/argocd
```

### Login with CLI
- Authenticate
```console
$ argocd login admin localhost:30443 --insecure
```
### Commands

- Get admin password
```console
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > admin-pass.txt
```
- Help CLI
```console
$ argocd help
```