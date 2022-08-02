# Instalando Crossplane no Kind

O Crossplane deve ser instalado dentro de um cluster Kubernetes para que possa realizar o control plane da infraestrutura provisionada por ele.
Para executar o Crossplane em sua máquina, utilizaremos o kind como nosso cluster de teste local.


Dependências:

```
kind
kubectl
helm
kubectx
```
```
brew upgrade
brew install kind
brew install kubectl
brew install helm
brew install kubectx
```
```
// criando um cluster utilizando o kind
kind create cluster --image kindest/node:v1.23.0 --wait 5m
```

## Instalando Crossplane

 - Primeiro é necessário mudar o contexto atual do kubernetes para o kind:

```
kubectx kind-kind
```
- Depois basta instalar o Crossplane dentro do cluster

```
kubectl create namespace crossplane-system
```
```
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update
```
```
helm install crossplane --namespace crossplane-system crossplane-stable
/crossplane
```
---
# Configurando Provider

O CSP (Cloud Solution Provider) utilizado pelo PicPay é a AWS, ou seja, para configuração do provider no Crossplane, seguimos com a
premissa de que utilizaremos o provider atual utilizado pelo PicPay.

### Instalando pacote de configuração da AWS

A instalação do pacote de configuração utilizado pelo Crossplane referente a AWS, pode ser instalado via declaração de um arquivo YAML com
as informações do provider.

## Declarando arquivo de provider
- Crie um arquivo YAML nomeado  provider.yaml com a seguinte configuração:
```yaml
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: provider-aws
spec:
  package: crossplane/provider-aws:v0.29.0
```
:bulb: `Certifique-se de está no cluster certo antes de aplicar a config do provider.`

:information_source: `Para mudança de cluster, use o comando: kubectx seu_cluster`

- Aplique o arquivo provider.yamlno cluster:
```bash
kubectl apply -f provider.yaml
```

## Criando credencias AWS
Após instalar o package do provider-aws seguintes o passo anterior, é necessário criar um arquivo de credenciais que será utilizado pela configuração do provider.

No mesmo direito que foi criado o provider.yaml, crie um arquivo creds.conf com a seguinte configuração:

:information_source: `As credenciais de acesso são criadas no serviço IAM da AWS, associadas a um usuário.`
```
[default]
aws_access_key_id = "sua acess key"
aws_secret_access_key = "sua secret key"
```

## Criando secret do provider
Para que o provider consiga se autenticar do cluster com a AWS, é necessário que seja criada um component secret no kubernetes para ser utilizado pelo provider.

Utilizando o arquivo creds.conf como input, que foi criado anteriormente, execute o comando a seguir:

:bulb: `Certifique-se de está no diretório do arquivo creds.conf `

:information_source: `O comando pwd pode lhe auxiliar, mostrando em qual path seu cursor se encontra.`
```bash
kubectl create secret generic aws-creds -n crossplane-system --from-file=creds=./creds.conf
```

## Criando Provider Config
Iremos agora criar o objeto ProviderConfig para configurar as credenciais de acesso na AWS, utilizando a secret criada anteriormente.

- Basta declarar o seguinte YAML, providerconfig.yaml:
```yaml
apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-creds
      key: creds
```
:bulb: `O campo spec->credentials->secretRef->name deve ser atribuído a secret criada aws-creds que faz parte do namespace crossplane-system.`

- Por fim, aplicar o YAML no cluster:
```bash
kubectl apply -f providerconfig.yaml
```
