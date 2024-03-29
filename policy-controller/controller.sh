#!/bin/sh

namespace=${WATCH_NAMESPACE:-default}

base=http://localhost:8001
ns=namespaces/${namespace}

set -xe
set -o pipefail

curl -N -s "${base}/apis/serving.knative.dev/v1alpha1/${ns}/revisions/?watch=true&timeoutSeconds=86400" |
while read -r event; do
    type=$(echo "$event" | jq -r '.type')
    noAuthN=$(echo "$event" | jq -r '.object.metadata.annotations."wueww-admin.metafnord.de/noAuthN"')
    name=$(echo "$event" | jq -r .object.metadata.name)
    uid=$(echo "$event" | jq -r .object.metadata.uid)

    echo ""
    echo "Received event: ${event}"

    if [ "$type" = "ADDED" ] && [ "$noAuthN" = "1" ]; then
        (cat <<EOF
apiVersion: "authentication.istio.io/v1alpha1"
kind: "Policy"
metadata:
  name: ${name}-service
  ownerReferences:
  - apiVersion: serving.knative.dev/v1alpha1
    blockOwnerDeletion: false
    kind: Revision
    name: ${name}
    uid: ${uid}
spec:
  targets:
  - name: ${name}-service
  # no JWT Auth for this service
  origins: []
  principalBinding: USE_ORIGIN
EOF
        ) | curl -X POST "${base}/apis/authentication.istio.io/v1alpha1/${ns}/policies/" --data-binary "@-" -H "Content-Type: application/yaml"
    fi
done
