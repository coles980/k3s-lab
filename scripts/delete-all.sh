#!/usr/bin/env bash
set -euo pipefail

kubectl delete -f devtools/gitea/ --ignore-not-found
kubectl delete -f devtools/filebrowser/ --ignore-not-found

kubectl delete -f observability/grafana/ --ignore-not-found
kubectl delete -f observability/uptime-kuma/ --ignore-not-found

kubectl delete -f base/homepage/ --ignore-not-found
kubectl delete -f base/whoami/ --ignore-not-found

kubectl delete -f shared/ingress/ --ignore-not-found
kubectl delete -f namespaces/ --ignore-not-found
