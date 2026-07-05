# =============================================================================
# K3s Swiss Army Lab — Makefile
# Despliegue declarativo del cluster mediante `kubectl apply`.
#
# Uso rapido:
#   make            -> muestra la ayuda
#   make apply      -> despliega el stack activo
#   make apply-all  -> despliega TODO (incluye devtools y observability)
#   make status     -> muestra el estado del cluster
#
# Puedes sobreescribir kubectl:  make apply KUBECTL="kubectl --context=lab"
# =============================================================================

KUBECTL ?= kubectl

.DEFAULT_GOAL := help

.PHONY: help
help: ## Muestra esta ayuda
	@awk 'BEGIN {FS = ":.*##"; printf "\nUso:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' $(MAKEFILE_LIST)

##@ Despliegue global

.PHONY: apply
apply: namespaces swiss-army base shared ## Despliega el stack activo (namespaces + swiss-army + base + shared)
	@echo "OK: stack activo desplegado."

.PHONY: apply-all
apply-all: namespaces swiss-army base devtools shared observability ## Despliega TODO (incluye devtools y observability)
	@echo "OK: stack completo desplegado."

.PHONY: namespaces
namespaces: ## Crea los namespaces
	$(KUBECTL) apply -f 0-namespaces/

##@ Swiss Army (namespace: apps, NodePort)

.PHONY: swiss-army
swiss-army: stirling vaultwarden n8n drawio excalidraw cyberchef it-tools memos ## Despliega todas las apps swiss-army

.PHONY: stirling
stirling: ## Despliega Stirling PDF (:30081)
	$(KUBECTL) apply -f 1-swiss-army/stirling/

.PHONY: vaultwarden
vaultwarden: ## Despliega Vaultwarden (:30080)
	$(KUBECTL) apply -f 1-swiss-army/vaultwarden/

.PHONY: n8n
n8n: ## Despliega n8n (:30083)
	$(KUBECTL) apply -f 1-swiss-army/n8n/

.PHONY: drawio
drawio: ## Despliega draw.io (:30084)
	$(KUBECTL) apply -f 1-swiss-army/drawio/

.PHONY: excalidraw
excalidraw: ## Despliega Excalidraw (:30085)
	$(KUBECTL) apply -f 1-swiss-army/excalidraw/

.PHONY: cyberchef
cyberchef: ## Despliega CyberChef (:30086)
	$(KUBECTL) apply -f 1-swiss-army/cyberchef/

.PHONY: it-tools
it-tools: ## Despliega IT-Tools (:30087)
	$(KUBECTL) apply -f 1-swiss-army/it-tools/

.PHONY: memos
memos: ## Despliega Memos (:30088, con PVC)
	$(KUBECTL) apply -f 1-swiss-army/memos/

##@ Base (Ingress)

.PHONY: base
base: whoami homepage ## Despliega whoami + homepage

.PHONY: whoami
whoami: ## Despliega whoami (/whoami)
	$(KUBECTL) apply -f 2-base/whoami/

.PHONY: homepage
homepage: ## Despliega homepage (/)
	$(KUBECTL) apply -f 2-base/homepage/

##@ DevTools (opcional)

.PHONY: devtools
devtools: filebrowser gitea ## Despliega filebrowser + gitea

.PHONY: filebrowser
filebrowser: ## Despliega Filebrowser (/files)
	$(KUBECTL) apply -f 3-devtools/filebrowser/

.PHONY: gitea
gitea: ## Despliega Gitea (/gitea)
	$(KUBECTL) apply -f 3-devtools/gitea/

##@ Shared

.PHONY: shared
shared: ## Despliega middlewares compartidos de Traefik
	$(KUBECTL) apply -f 4-shared/ingress/

##@ Observability (opcional)

.PHONY: observability
observability: uptime-kuma grafana ## Despliega uptime-kuma + grafana

.PHONY: uptime-kuma
uptime-kuma: ## Despliega Uptime Kuma (/kuma)
	$(KUBECTL) apply -f 5-observability/uptime-kuma/

.PHONY: grafana
grafana: ## Despliega Grafana
	$(KUBECTL) apply -f 5-observability/grafana/

##@ Utilidades

.PHONY: status
status: ## Muestra pods, servicios e ingress del cluster
	@echo "== Pods =="
	@$(KUBECTL) get pods -A
	@echo "== Services =="
	@$(KUBECTL) get svc -A
	@echo "== Ingress =="
	@$(KUBECTL) get ingress -A
