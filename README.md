# infra

Infrastrukturkonfiguration & -komponenten zum wueww-admin.

Du suchst Informationen, was der wueww-admin ist?  Ein Überblick findet sich in der README.md
des docs repositories.

* Installation von Istio & Knative, siehe infrastructure.md
* Installation & Schema für MySQL Datenbank, siehe database/README.md

## Knative Build Templates

### knative-php73-psr7

```
tm deploy buildtemplate -f https://raw.githubusercontent.com/stesie/knative-lambda-runtime-php/master/7.3-psr7/buildtemplate.yaml
```

## Konfiguration von Istio

Um den WueWW Admin zu betreiben, müssen folgende Istio-spezifischen Resourcen geladen werden:

* Virtual Services, um die externe API aus den einzelnen Funktionen zusammen zu bauen: `kubectl apply -f istio/virtualservices/`
* Default Policy für JWT Authentifizierung: `kubectl apply -f istio/policies/default.yml`
* Istio RBAC: `kubectl apply -f istio/cluster-rbac.yaml -f istio/servicerole -f istio/servicerolebindings/`

## Istio Policy Controller

Die Namen der Kubernetes Services enthalten einen zufälligen Bestandteil, nachdem sie sich vom
Knative Service ableiten.  Nachdem sich eine Istio Policy jedoch "by exact match" auf den Namen
eines Kubernetes Services beziehen muss, wird ein Controller benötigt, der on-the-fly die
erforderlichen Policies erstellt und im System registriert.  Dieser finde sich im
Verzeichnis `policy-controller`.

Um diesen mit Knative Build zu bauen, zunächst mit `kubectl apply -f policy-controller/build.yaml`
die Build Resource erstellen.  Wenn der Build durch ist, dann einen Serivce Account nebst
Kubernetes Role sowie Role Binding und last but not least Deployment erstellen,
mittels `kubectl apply -f policy-controller/deployment.yaml`.
