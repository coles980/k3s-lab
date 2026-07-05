#!/usr/bin/env bash
set -euo pipefail

kubectl apply -f 0-namespaces/

kubectl apply -f 1-swiss-army/stirling/
kubectl apply -f 1-swiss-army/vaultwarden/
kubectl apply -f 1-swiss-army/n8n/
kubectl apply -f 1-swiss-army/drawio/
kubectl apply -f 1-swiss-army/excalidraw/
kubectl apply -f 1-swiss-army/cyberchef/
kubectl apply -f 1-swiss-army/it-tools/
kubectl apply -f 1-swiss-army/memos/

kubectl apply -f 2-base/whoami/
kubectl apply -f 2-base/homepage/

# kubectl apply -f 3-devtools/filebrowser/
# kubectl apply -f 3-devtools/gitea/

kubectl apply -f 4-shared/ingress/

# kubectl apply -f 5-observability/uptime-kuma/
# kubectl apply -f 5-observability/grafana/

echo
echo "Listo. Comprueba con:"
echo "kubectl get pods -A"
echo "kubectl get svc -A"
echo "kubectl get ingress -A"
