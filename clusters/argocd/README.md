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
kubeclt create ns argocd
```
- Apply the latest stable version manifest
```console
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## ArgoCD CLI

- Installing cli
```console
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v2.1.5/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```
```console
chmod +x /usr/local/bin/argocd
```
### Commands

- Get admin password
```console
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > admin-pass.txt
```
- Help CLI
```console
argocd help
```