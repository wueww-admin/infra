
## Inbetriebnahme Basis-Infrastruktur

Zunächst wird eine Kubernetes Instanz benötigt.  Zusätzlich werden folgende Dinge benötigt:

### Istio

```
wget https://github.com/istio/istio/releases/download/1.1.4/istio-1.1.4-linux.tar.gz
tar xvzf istio-1.1.4-linux.tar.gz
cd istio-1.1.4
kubectl create namespace istio-system
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -
helm template install/kubernetes/helm/istio --name istio --namespace istio-system \
    --set gateways.istio-ingressgateway.type=NodePort \
    --set global.disablePolicyChecks=false \
    --set mixer.policy.enabled=true \
    --set gateways.istio-ilbgateway.type=NodePort \
    | kubectl apply -f -
```

### Knative

```
kubectl apply -f https://github.com/knative/serving/releases/download/v0.5.0/serving.yaml
kubectl apply -f https://github.com/knative/build/releases/download/v0.5.0/build.yaml
kubectl apply -f https://raw.githubusercontent.com/knative/serving/v0.5.0/third_party/config/build/clusterrole.yaml
```

... in Knative muss noch eine (Default) Domain hinterlegt werden.
z.B. mittels `kubectl edit cm config-domain --namespace knative-serving`

### Lokale Docker Registry

Siehe Anleitung unter https://github.com/triggermesh/knative-local-registry.

### Namespace

```
kubectl create ns wueww-admin
kubectl label namespace wueww-admin istio-injection=enabled
```
